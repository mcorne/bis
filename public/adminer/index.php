<?php
function adminer_object() {
    // required to run any plugin
    include_once "./plugins/plugin.php";

    // autoloader
    foreach (glob("plugins/*.php") as $filename) {
        include_once "./$filename";
    }

    $plugins = array(
        // specify enabled plugins here
        new AdminerEditForeign,
        new AdminerHashColumn,
        // new AdminerLoginSqlite, // uncomment to log into the database without authentication, eg to import database creation files
        new AdminerLoginSqliteTable, // uncomment to log into the database with authentication
    );

    /* It is possible to combine customization and plugins:
    class AdminerCustomization extends AdminerPlugin {
    }
    return new AdminerCustomization($plugins);
    */

    return new AdminerPlugin($plugins);
}

// include original Adminer or Adminer Editor
include "./adminer.php";
?>
