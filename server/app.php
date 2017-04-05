<?php

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require './server/vendor/autoload.php';

$users = array(array('email' => 'pepe@yahoo.es', 'psswd' => 'p@ssw0rd'),array('email' => 'juan@gmail.com', 'psswd' => 'p@ssw0rd'),array('email' => 'maria@yahoo.es', 'psswd' => 'p@ssw0rd'));

$app = new \Slim\App;

$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write(file_get_contents("client/index.html"));

    return $response;
});

$app->post('/login', function (Request $request, Response $response) use ($users){
    $json = $request->getBody();
    $login = json_decode($json);
    $userOk = array_filter($users, function ($item) use ($login) {
        return ($item['email'] === $login->email && $item['psswd'] === $login->psswd);
    });
    //$response->getBody()->write($json);
//    $response = $response->withJson($userOk);
    if (sizeof($userOk) > 0){
        $response->getBody()->write("ok");
    } else {
        $response->getBody()->write("fail");
    }
    return $response;
});

$app->post('/register', function (Request $request, Response $response){
    
});

$app->group('/admin', function () use ($app, $users) {
    $app->get('/socio', function ($request, $response) {
        $response->getBody()->write('[]');
        return $response;
    });
    $app->get('/adhesionManifiesto', function ($request, $response) {
        $response->getBody()->write('[]');
        return $response;
    });
    $app->get('/denuncia', function ($request, $response) {
        $response->getBody()->write('[]');
        return $response;
    });
    $app->get('/donacion', function ($request, $response) {
        $response->getBody()->write('[]');
        return $response;
    });
    $app->get('/users', function ($request, $response) use ($users) {
        return $response->withJson($users);
    });
})->add(function ($request, $response, $next) {
    $response = $response->withHeader('Content-type', 'application/json');
    $response = $next($request, $response);

    return $response;
});


$app->group('/api', function () use ($app){
    $app->post('/socio', function ($request, $response){
        
        return $response;
    });
        $app->post('/adhesionManifiesto', function ($request, $response){
        return $response;
    });
        $app->post('/denuncia', function ($request, $response){
        return $response;
    });
        $app->post('/donacion', function ($request, $response){
        return $response;
    });
});
//$app->get('/api/{name}', function (Request $request, Response $response) {
//    $name = $request->getAttribute('name');
//    $response->getBody()->write("Hello, $name");
//
//    return $response;
//});

$app->run();
