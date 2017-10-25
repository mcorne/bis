<?php
$config = require 'load_config.php';

set_include_path($config['base_path']);

try {
    require_once 'controller.php';
    $controller = new controller($config);
    $controller->run_application();
} catch (Exception $exception) {
    echo 'There is a technical problem. Sorry for the inconvenience. Please contact the administrator.';
    echo '<br>';
    echo $exception->getMessage();
}
