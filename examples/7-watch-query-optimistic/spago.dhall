{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "affjax"
  , "argonaut-codecs"
  , "argonaut-core"
  , "arrays"
  , "bifunctors"
  , "console"
  , "control"
  , "datetime"
  , "debug"
  , "effect"
  , "either"
  , "enums"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "foreign-generic"
  , "foreign-object"
  , "functions"
  , "halogen-subscriptions"
  , "heterogeneous"
  , "http-methods"
  , "integers"
  , "lists"
  , "maybe"
  , "media-types"
  , "newtype"
  , "node-buffer"
  , "node-fs"
  , "nullable"
  , "numbers"
  , "ordered-collections"
  , "parsing"
  , "prelude"
  , "profunctor"
  , "profunctor-lenses"
  , "psci-support"
  , "record"
  , "string-parsers"
  , "strings"
  , "strings-extra"
  , "transformers"
  , "tuples"
  , "unicode"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs", "../../src/**/*.purs" ]
}
