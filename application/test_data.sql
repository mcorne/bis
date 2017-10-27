BEGIN TRANSACTION;

INSERT INTO "role" ("id") VALUES ('prof');
INSERT INTO "role" ("id") VALUES ('attp');
INSERT INTO "role" ("id") VALUES ('op');

INSERT INTO user (role_id, name, password) VALUES ('prof', 'prof', '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)
INSERT INTO user (role_id, name, password) VALUES ('attp', 'attp', '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)
INSERT INTO user (role_id, name, password) VALUES ('op'  , 'op'  , '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)

INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'create', 'prof');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'read'  , 'prof');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'reply' , 'prof');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'update', 'prof');

INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'create', 'attp');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'read'  , 'attp');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'reply' , 'attp');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'update', 'attp');

INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'create', 'op');
INSERT INTO domain_right_role (domain_id, right_id, role_id) VALUES ('computer', 'read'  , 'op');

INSERT INTO category (domain_id, name) VALUES ('computer', 'Panne informatique'    );
INSERT INTO category (domain_id, name) VALUES ('computer', 'Demande de consommable');

END TRANSACTION;
