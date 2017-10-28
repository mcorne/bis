BEGIN TRANSACTION;

INSERT INTO role (id, domain_id, display_form) VALUES ('prof', 'computer'   , 1);
INSERT INTO role (id, domain_id, display_form) VALUES ('attp', 'stewardship', 0);
INSERT INTO role (id, domain_id, display_form) VALUES ('op'  , 'stewardship', 0);

INSERT INTO user (role_id, name, password) VALUES ('prof', 'prof', '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)
INSERT INTO user (role_id, name, password) VALUES ('attp', 'attp', '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)
INSERT INTO user (role_id, name, password) VALUES ('op'  , 'op'  , '7c4a8d09ca3762af61e59520943dc26494f8941b'); -- sha1(123456)

INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('prof', 'computer'   , 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('prof', 'computer'   , 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('prof', 'computer'   , 'reply' );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('prof', 'stewardship', 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('prof', 'stewardship', 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('prof', 'stewardship', 'reply' );

INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'computer'   , 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'computer'   , 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'computer'   , 'reply' );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'computer'   , 'update');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'stewardship', 'close');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'stewardship', 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'stewardship', 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'stewardship', 'reply' );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('attp', 'stewardship', 'update');

INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('op', 'computer'     , 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('op', 'computer'     , 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('op', 'stewardship'  , 'create');
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('op', 'stewardship'  , 'read'  );
INSERT INTO domain_right_role (role_id, domain_id, right_id) VALUES ('op', 'stewardship'  , 'update'  );

INSERT INTO category (domain_id, name) VALUES ('computer', 'Panne informatique'    );
INSERT INTO category (domain_id, name) VALUES ('computer', 'Demande de consommable');

END TRANSACTION;
