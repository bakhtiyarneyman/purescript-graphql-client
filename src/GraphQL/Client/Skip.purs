module GraphQL.Client.Skip
  ( Skip(..)
  , Skipped(..)
  ) where

import Prelude

-- | A type that can be used to skip a field in a query.
--
-- The return type is then `Maybe`, which is always `Nothing` at runtime. This is useful to
-- parameterize data structure with a functor wrapping the field type, so that the data structure
-- can be shared between the query API and the app state.
--
-- See `examples/14-functors` for an example.
data Skip = Skip

data Skipped :: forall k. k -> Type
data Skipped a = Skipped

derive instance Eq (Skipped a)
derive instance Ord (Skipped a)
derive instance Functor Skipped

instance Show (Skipped a) where
  show _ = "Skipped"
