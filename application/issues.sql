BEGIN TRANSACTION;

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS category;
CREATE TABLE category (
    id        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    domain_id TEXT    NOT NULL,
    created   TEXT    DEFAULT CURRENT_TIMESTAMP, -- UTC
    enabled   INTEGER DEFAULT 1,
    name      TEXT    NOT NULL,
    updated   TEXT,                              -- UTC
    FOREIGN KEY(domain_id) REFERENCES domain(id)
);

DROP TABLE IF EXISTS domain;
CREATE TABLE domain (
    id TEXT PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS domain_right_role;
CREATE TABLE domain_right_role (
    id        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    domain_id TEXT    NOT NULL,
    right_id  TEXT    NOT NULL,
    role_id   TEXT    NOT NULL,
    FOREIGN KEY(domain_id) REFERENCES domain(id),
    FOREIGN KEY(right_id)  REFERENCES right(id),
    FOREIGN KEY(role_id)   REFERENCES role(id)
);

DROP TABLE IF EXISTS issue;
CREATE TABLE issue (
    id          INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    category_id INTEGER NOT NULL,
    user_id     TEXT    NOT NULL,
    closed      INTEGER DEFAULT 0,
    created     TEXT    DEFAULT CURRENT_TIMESTAMP, -- UTC
    description TEXT,
    subject     TEXT    NOT NULL,
    updated     TEXT,                              -- UTC
    FOREIGN KEY(category_id) REFERENCES category(id),
    FOREIGN KEY(user_id)     REFERENCES user(id)
);

DROP TABLE IF EXISTS right;
CREATE TABLE right (
    id TEXT PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS role;
CREATE TABLE role (
    id TEXT PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    role_id  TEXT    NOT NULL,
    created  TEXT    DEFAULT CURRENT_TIMESTAMP, -- UTC
    enabled  INTEGER DEFAULT 1,
    name     TEXT    NOT NULL,
    password TEXT    NOT NULL,                  -- sha1 encrypted
    updated  TEXT,                              -- UTC
    FOREIGN KEY(role_id) REFERENCES role(id)
);

PRAGMA foreign_keys = ON;

INSERT INTO domain (id) VALUES ('computer');
INSERT INTO domain (id) VALUES ('stewardship');

INSERT INTO right  (id) VALUES ('close');
INSERT INTO right  (id) VALUES ('create');
INSERT INTO right  (id) VALUES ('read');
INSERT INTO right  (id) VALUES ('reply');
INSERT INTO right  (id) VALUES ('update');

INSERT INTO role   (id) VALUES ('admin');

INSERT INTO user   (role_id, name, password) VALUES ('admin', 'admin', '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)

INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'close' , 'admin');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'create', 'admin');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'read'  , 'admin');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'reply' , 'admin');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'update', 'admin');

END TRANSACTION;
