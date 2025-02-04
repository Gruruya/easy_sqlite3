import std/unittest

import easy_sqlite3

type
  User = tuple[id: int, username: string, email: string]

proc createUsersTable() {.importdb: "create table users(id INTEGER PRIMARY KEY, username TEXT NOT NULL, email TEXT NOT NULL)".}
proc insertUser(username, email: string) {.importdb: "insert into users(username, email) values ($username, $email)".}
proc selectUserById(id: int): User {.importdb: "select * from users where id = $id".}
iterator iterateUsers(): User {.importdb: "select * from users".} = discard

suite "type decl":
  setup:
    var db = initDatabase(":memory:")
    db.createUsersTable()
    db.insertUser("user", "user@example.com")
    db.insertUser("abc", "abc@example.com")
  test "typed query":
    check db.selectUserById(1) == (id: 1, username: "user", email: "user@example.com")
  test "typed iterator":
    for id, username, email in db.iterateUsers():
      check email == (username & "@example.com")