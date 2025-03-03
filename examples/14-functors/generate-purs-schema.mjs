// In your code replace this line with the npm package:
// import { generateSchemas } from 'purescript-graphql-client'
import { generateSchemas } from '../../codegen/schema/index.mjs'

generateSchemas({
  dir: './src/generated',
  modulePath: ['Generated'],
  useNewtypesForRecords: false
}, [
  {
    url: 'http://localhost:4892/graphql',
    moduleName: 'Functors'
  }
])
