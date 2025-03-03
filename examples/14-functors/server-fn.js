module.exports = (onListening) => {
  const express = require("express");
  const { graphqlHTTP } = require("express-graphql");
  const { buildSchema } = require("graphql");

  const schema = buildSchema(`
    type Query {
        user(id: Int!, password: String): User!
    }

    type User {
        id: Int!
        name: String!
        email: String!
        age: String!
    }
    `);

  const rootValue = {
    user: ({ id, password }) => {
      if (id == 1) {
        if (password == "supersecret") {
          return {
            id: 1,
            name: "Foo",
            email: "foo@bar.baz",
            age: "forty two",
          };
        } else if (password === undefined){
          return {
            id: 1,
            name: "Foo",
            age: "42",
            email: () => {
              throw new Error("Permission denied");
            }
          };
        } else {
          throw new Error("Wrong password");
        }
      } else {
        throw new Error("User not found")
      }
    }
  };

  const app = express();

  app.use(
    "/graphql",
    graphqlHTTP({
      schema,
      rootValue,
      graphiql: true,
    })
  );

  app.listen(4892, onListening);
};
