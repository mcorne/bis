-- tables are sorted in alphabetical order
-- table columns are sorted in alphabetical order, the primary and foreign keys are listed first
-- date time columns are in the UTC timezone

BEGIN TRANSACTION;

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS boolean;
CREATE TABLE boolean (
    id INTEGER PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS category;
CREATE TABLE category (
    id        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    domain_id TEXT    NOT NULL,
    created   TEXT    DEFAULT CURRENT_TIMESTAMP,
    enabled   INTEGER DEFAULT 1,
    name      TEXT    NOT NULL,
    updated   TEXT,
    FOREIGN KEY(domain_id) REFERENCES domain(id),
    FOREIGN KEY(enabled)   REFERENCES boolean(id)
);

DELIMITER ;;
CREATE TRIGGER category_update AFTER UPDATE OF domain_id, enabled, name ON category FOR EACH ROW
BEGIN
    UPDATE category SET updated = CURRENT_TIMESTAMP WHERE id = old.id;
END;;
DELIMITER ;

DROP TABLE IF EXISTS domain;
CREATE TABLE domain (
    id TEXT PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS domain_right_role;
CREATE TABLE domain_right_role (
    id        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    role_id   TEXT    NOT NULL, -- the role is listed first for displaying purposes with DB management tools
    domain_id TEXT    NOT NULL,
    right_id  TEXT    NOT NULL,
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
    created     TEXT    DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    subject     TEXT    NOT NULL,
    updated     TEXT,
    FOREIGN KEY(category_id) REFERENCES category(id),
    FOREIGN KEY(closed)      REFERENCES boolean(id),
    FOREIGN KEY(user_id)     REFERENCES user(id)
);

DELIMITER ;;
CREATE TRIGGER issue_update AFTER UPDATE OF category_id, user_id, closed, description, subject ON issue FOR EACH ROW
BEGIN
    UPDATE issue SET updated = CURRENT_TIMESTAMP WHERE id = old.id;
END;;
DELIMITER ;

DROP TABLE IF EXISTS right;
CREATE TABLE right (
    id TEXT PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS role;
CREATE TABLE role (
    id TEXT      PRIMARY KEY NOT NULL,
    domain_id    INTEGER,
    display_form DEFAULT 0,
    FOREIGN KEY(display_form) REFERENCES boolean(id),
    FOREIGN KEY(domain_id)    REFERENCES domain(id)
);

DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    role_id  TEXT    NOT NULL,
    created  TEXT    DEFAULT CURRENT_TIMESTAMP,
    enabled  INTEGER DEFAULT 1,
    name     TEXT    NOT NULL,
    password TEXT    NOT NULL,                  -- sha1 encrypted
    updated  TEXT,
    FOREIGN KEY(enabled) REFERENCES boolean(id),
    FOREIGN KEY(role_id) REFERENCES role(id)
);

DELIMITER ;;
CREATE TRIGGER user_update AFTER UPDATE OF role_id, enabled, name, password ON user FOR EACH ROW
BEGIN
    UPDATE user SET updated= CURRENT_TIMESTAMP WHERE id = old.id;
END;;
DELIMITER ;

PRAGMA foreign_keys = ON;

INSERT INTO boolean (id) VALUES (0);
INSERT INTO boolean (id) VALUES (1);

INSERT INTO domain (id) VALUES ('computer');
INSERT INTO domain (id) VALUES ('stewardship');

INSERT INTO right  (id) VALUES ('close');
INSERT INTO right  (id) VALUES ('create');
INSERT INTO right  (id) VALUES ('read');
INSERT INTO right  (id) VALUES ('reply');
INSERT INTO right  (id) VALUES ('update');

INSERT INTO role   (id) VALUES ('admin');

INSERT INTO user   (role_id, name, password) VALUES ('admin', 'admin', '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)

INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'computer', 'close' );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'computer', 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'computer', 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'computer', 'reply' );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'computer', 'update');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'stewardship', 'close' );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'stewardship', 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'stewardship', 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'stewardship', 'reply' );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('admin', 'stewardship', 'update');

END TRANSACTION;
