<?php
return array(
    'development' => array(
        'base_path'  => __DIR__ . '/../application',
        'base_url'   => sprintf('http://%s/bis', $_SERVER['HTTP_HOST']), // the domain subpath MUST BE the same as the one used in .htaccess
        'data_path'  => __DIR__ . '/../application/data/development.issues.sqlite',
    ),
    'production'  => array(
        'base_path'  => __DIR__ . '/../../cgi-bin/bis',
        'base_url'   => sprintf('http://%s/bis', $_SERVER['HTTP_HOST']), // the domain subpath MUST BE the same as the one used in .htaccess
        'data_path'  => __DIR__ . '/../../cgi-bin/bis/data/issues.sqlite',
    ),
);
