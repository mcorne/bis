<?php
date_default_timezone_set('UTC');

return array(
    'development' => array(
        'base_path'  => __DIR__ . '/../application',
        'base_url'   => sprintf('http://%s/bits', $_SERVER['HTTP_HOST']), // the domain subpath MUST BE the same as the one used in .htaccess
        'data_path'  => __DIR__ . '/../application/data/development.issues.sqlite',
    ),
    'production'  => array(
        'base_path'  => __DIR__ . '/../../cgi-bin/bits',
        'base_url'   => sprintf('http://%s/bits', $_SERVER['HTTP_HOST']), // the domain subpath MUST BE the same as the one used in .htaccess
        'data_path'  => __DIR__ . '/../../cgi-bin/bits/data/issues.sqlite',
    ),
);
