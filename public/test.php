<?php
$config = require 'load_config.php';

set_include_path($config['base_path']);

require_once 'database.php';
$database = new database($config['data_path']);

/*
$id = $database->insert('issue', [
    'category_id' => 1,
    'user_id' => 1,
    'description' => 'there is a problem',
    'subject' => 'the new issue',
]);
 */

// echo $database->insert('role', ['id' => 'new role']);

// $database->update('role', ['id' => 'new role2'], ['id' => 'new role']);
// $database->update('role', ['default_domain_id' => null], ['id' => 'new role']);
// $database->update('role', ['display_form' => 1], ['id' => 'new role', 'default_domain_id' => null]);

// $database->delete('role', ['id' => 'new role', 'default_domain_id' => null]);

// print_r($database->get_row('role', ['id' => 'admin', 'default_domain_id' => null]));
print_r($database->get_rows('role', ['id' => 'admin', 'default_domain_id' => null]));
