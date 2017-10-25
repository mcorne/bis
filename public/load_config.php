<?php
// uncomment the line below when the application is unavailable for maintenance
// exit('The application is down for maintenance. Sorry for the inconvenience. Please, come back soon.');

$config = require 'config.php';

$environment = getenv('ENVIRONMENT');

if (! isset($config[$environment])) {
    exit("Invalid environment: $environment");
}

$config = $config[$environment];

return $config;
