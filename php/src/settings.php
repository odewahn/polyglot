<?php
return [
    'settings' => [
        'displayErrorDetails' => true,

        'renderer' => [
            'template_path' => __DIR__ . '/../templates/',
        ],

        // Monolog settings
        'logger' => [
            'name' => 'slim-app',
            'path' =>'php://stderr',
        ],
    ],
];
