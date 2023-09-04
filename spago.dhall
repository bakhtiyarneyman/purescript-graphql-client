{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "graphql-client"
, repository = "https://github.com/OxfordAbstracts/purescript-graphql-client"
, license = "MIT"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "affjax"
  , "affjax-node"
  , "affjax-web"
  , "argonaut-codecs"
  , "argonaut-core"
  , "argonaut-generic"
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
  , "filterable"
  , "foldable-traversable"
  , "foreign"
  , "foreign-object"
  , "functions"
  , "halogen-subscriptions"
  , "heterogeneous"
  , "http-methods"
  , "integers"
  , "language-cst-parser"
  , "lists"
  , "maybe"
  , "media-types"
  , "newtype"
  , "node-buffer"
  , "node-fs"
  , "now"
  , "nullable"
  , "numbers"
  , "ordered-collections"
  , "parsing"
  , "partial"
  , "prelude"
  , "profunctor"
  , "profunctor-lenses"
  , "psci-support"
  , "quickcheck"
  , "record"
  , "spec"
  , "spec-discovery"
  , "string-parsers"
  , "strings"
  , "strings-extra"
  , "tidy-codegen"
  , "transformers"
  , "tuples"
  , "typelevel-lists"
  , "unfoldable"
  , "unicode"
  , "unsafe-coerce"
  , "untagged-union"
  , "variant"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
