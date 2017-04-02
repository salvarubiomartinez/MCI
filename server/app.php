<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require '/server/vendor/autoload.php';

$app = new \Slim\App;
$app->get('/api/{name}', function (Request $request, Response $response) {
    $name = $request->getAttribute('name');
    $response->getBody()->write("Hello, $name");

    return $response;
});

$app->get('/', function (Request $request, Response $response) {
    //$response->getBody()->write("rrr");
    $response->getBody()->write(file_get_contents("client/index.html"));

    return $response;
});

$app->run();