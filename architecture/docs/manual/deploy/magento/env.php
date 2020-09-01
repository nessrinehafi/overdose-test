<?php
return [
    'db' => [],
    'backend' => [
        'frontName' => '<project_bo_url>',
    ],
    'install' => [],
    'crypt' => [],
    'session' => [
        'save' => 'redis',
        'redis' => [
            'host' => 'myredis',
            'port' => '6380',
            'database' => '1'
        ],
    ],
    'cache' => [
        'frontend' => [
            'default' => [
                'backend' => 'Cm_Cache_Backend_Redis',
                'id_prefix' => '<project_name>',
                'backend_options' => [
                    'server' => 'myredis',
                    'port' => '6379',
                    'persistent' => '',
                    'database' => '1',
                    'force_standalone' => '0',
                    'connect_retries' => '1',
                    'read_timeout' => '10',
                    'automatic_cleaning_factor' => '0',
                    'compress_data' => '1',
                    'compress_tags' => '1',
                    'compress_threshold' => '20480',
                    'compression_lib' => 'gzip',
                ],
            ],
        ],
    ],
    'http_cache_hosts' => [
        0 => [
            'host' => 'myfront1',
            'port' => '<nginx_port>',
        ],
        1 => [
            'host' => 'myfront2',
            'port' => '<nginx_port>',
        ],
    ],
    'MAGE_MODE' => 'production',
];
