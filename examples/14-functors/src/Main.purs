module Main
  ( ThatUserPayload
  , AnyUserModel
  , IntParseError(..)
  , Sum(..)
  , ThisUserPayload
  , Updatable(..)
  , User
  , main
  , queryGql
  ) where

import Prelude

import Data.Argonaut.Decode (class DecodeJson)
import Data.Const (Const(..))
import Data.Either (Either, note)
import Data.Generic.Rep (class Generic)
import Data.Identity (Identity(..))
import Data.Int as Int
import Data.Maybe (Maybe)
import Data.Newtype (unwrap)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class.Console (logShow)
import Generated.Schema.Functors (Query)
import GraphQL.Client.Alias ((:))
import GraphQL.Client.Args ((=>>))
import GraphQL.Client.Operation (OpQuery)
import GraphQL.Client.Query (query_)
import GraphQL.Client.Skip (Skip(..), Skipped(..))
import GraphQL.Client.Types (class GqlQuery)
import Type.Data.List (Nil')
import Type.Proxy (Proxy(..))

-- | Generic user type.
type User f g h =
  { id :: Int
  , name :: f String -- Read-write if the password is given, read-only otherwise.
  , email :: g String -- Read-only if the password is given, no access otherwise
  , age :: h Int -- Stored in the backend as a string but is represented in the client as an Int.
  }

-- | User returned by the server when the password is given.
type ThisUserPayload = User
  Identity -- Read.
  Identity -- Read.
  (Const String) -- Read in original representation.

-- | User state stored in the client when the password is given.
type ThisUserModel = User
  Updatable -- Store as read-write.
  Identity -- Store as read-only.
  (Either IntParseError) -- Store with error if fails to parse.

-- | User returned by the server when the password is not given.
type ThatUserPayload = User
  Identity -- Read.
  Maybe -- Skip reading.
  (Const String) -- Read in original representation.

-- | User state stored in the client when the pa`ssword is not given.
type ThatUserModel = User
  Identity -- Store as read-only.
  Skipped -- Don't store
  Maybe -- Store without the error if fails to parse.

-- | User with some fields requested stored in the client.
type AnyUserModel = User
  (Sum Identity Updatable)
  (Sum Skipped Identity)
  (Either IntParseError)

data Sum :: forall k. (k -> Type) -> (k -> Type) -> k -> Type
data Sum f g a = InL (f a) | InR (g a)

instance (Show (f a), Show (g a)) => Show (Sum f g a) where
  show = case _ of
    InL a -> "(InL " <> show a <> ")"
    InR a -> "(InR " <> show a <> ")"

newtype Updatable a = Updatable
  { saved :: a
  , draft :: a
  , updateInProgress :: Boolean
  }

derive instance Generic (Updatable a) _

instance Show a => Show (Updatable a) where
  show = genericShow

data IntParseError = IntParseError String

derive instance Generic IntParseError _

instance Show IntParseError where
  show = genericShow

main :: Effect Unit
main =
  launchAff_ do
    response <- queryGql "user"
      { thisUser: Proxy @"user" : { id: 1, password: "supersecret" } =>>
          { id: unit
          , name: Identity unit
          , email: Identity unit
          , age: Const unit
          }
      , thatUser: Proxy @"user" : { id: 1 } =>>
          { id: unit
          , name: Identity unit
          , email: Skip
          , age: Const unit
          }
      }

    logShow response
    logShow $ toThisUserModel response.thisUser
    logShow $ toThatUserModel response.thatUser
    logShow
      [ thisUserToAnyUserState response.thisUser
      , otherUserToAnyUserState response.thatUser
      ]

toThisUserModel :: ThisUserPayload -> ThisUserModel
toThisUserModel user =
  { id: user.id
  , name: toUpdatable user.name
  , email: user.email
  , age: parseInt user.age
  }

toThatUserModel :: ThatUserPayload -> ThatUserModel
toThatUserModel user =
  { id: user.id
  , name: user.name
  , email: Skipped
  , age: Int.fromString $ unwrap user.age
  }

thisUserToAnyUserState :: ThisUserPayload -> AnyUserModel
thisUserToAnyUserState user =
  { id: user.id
  , name: InR $ toUpdatable user.name
  , email: InR user.email
  , age: parseInt user.age
  }

otherUserToAnyUserState :: ThatUserPayload -> AnyUserModel
otherUserToAnyUserState user =
  { id: user.id
  , name: InL user.name
  , email: InL Skipped
  , age: parseInt user.age
  }

toUpdatable :: forall a. Identity a -> Updatable a
toUpdatable (Identity a) = Updatable { saved: a, draft: a, updateInProgress: false }

parseInt :: Const String Int -> Either IntParseError Int
parseInt (Const s) = note (IntParseError s) $ Int.fromString s

-- Run gql query
queryGql
  :: forall query returns
   . GqlQuery Nil' OpQuery Query query returns
  => DecodeJson returns
  => String
  -> query
  -> Aff returns
queryGql = query_ "http://localhost:4892/graphql" (Proxy :: Proxy Query)
