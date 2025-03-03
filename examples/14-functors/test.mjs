import { deepStrictEqual } from "assert";
import serverFn from "./server-fn.js";
import { main } from "./output/Main/index.js";

const logs = [];

console.log = (log) => {
  console.info(log);
  logs.push(log);
};

serverFn(main);

setTimeout(() => {
  deepStrictEqual(logs, [
    '{ thatUser: { age: (Const "42"), email: Nothing, id: 1, name: (Identity "Foo") }, thisUser: { age: (Const "forty two"), email: (Identity "foo@bar.baz"), id: 1, name: (Identity "Foo") } }',
    '{ age: (Left (IntParseError "forty two")), email: (Identity "foo@bar.baz"), id: 1, name: (Updatable { draft: "Foo", saved: "Foo", updateInProgress: false }) }',
    '{ age: (Just 42), email: Skipped, id: 1, name: (Identity "Foo") }',
    '[{ age: (Left (IntParseError "forty two")), email: (InR (Identity "foo@bar.baz")), id: 1, name: (InR (Updatable { draft: "Foo", saved: "Foo", updateInProgress: false })) },{ age: (Right 42), email: (InL Skipped), id: 1, name: (InL (Identity "Foo")) }]'
  ]);
  console.info("tests passed");
  process.exit(0);
}, 250);
