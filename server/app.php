<?php

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require './server/vendor/autoload.php';
require './server/db.php';
//sha1(value);
//crypt(value, key);

$key = '$5$rounds=5000$anexamplestringforsalt$';

$mysqli = new mysqli('127.0.0.1', 'mci', 'mci', 'mci');

$users = array(array('email' => 'pepe@yahoo.es', 'psswd' => '$2y$10$.4O1NR9FSOztr52bLw7aC.inKjVi0uLZ6SSTSYLELuAJmcerF4B7W'),array('email' => 'juan@gmail.com', 'psswd' => '$2y$10$.4O1NR9FSOztr52bLw7aC.inKjVi0uLZ6SSTSYLELuAJmcerF4B7W'),array('email' => 'maria@yahoo.es', 'psswd' => '$2y$10$.4O1NR9FSOztr52bLw7aC.inKjVi0uLZ6SSTSYLELuAJmcerF4B7W'));

$app = new \Slim\App;

function verifyToken($request, $key) {   
    if ($request->hasHeader('User') && $request->hasHeader('Token')) {
           if (count($request->getHeader('User')) > 0 && count($request->getHeader('Token')) > 0) {              
             $user = implode ($request->getHeader('User'),'');
             $oldToken = crypt($user, hash("sha256", $key));
             $token =implode ($request->getHeader('Token'),'');
             return $token == $oldToken;
            }
    }
    return false;
}

$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write(file_get_contents("client/index.html"));

    return $response;
});

$app->post('/login', function (Request $request, Response $response) use ($key) {
    $json = $request->getBody();
    $login = json_decode($json);
    $password = getPassword($login->email);
    
    if (!is_null($password)){
        if (password_verify($login->psswd, $password)){
            $token = crypt($login->email, hash("sha256",$key));
            $response->getBody()->write($token);
        } else {
            $response->getBody()->write("incorrect password");
        }
    } else {
        $response->getBody()->write("user not found");
    }
    return $response;
});

$app->post('/register', function (Request $request, Response $response) use ($mysqli){
    $json = $request->getBody();
    $login = json_decode($json);
    $result = createUsers($login->email, $login->psswd);
    
    if ($result === TRUE){
            $response->getBody()->write($hashed_password);
    } else {
            $response->getBody()->write("error");
    }    


    return $response;
});

$app->group('/admin', function () use ($app, $users, $key) {
    $app->get('/socio', function ($request, $response) use ($key) {
            $resultado = getEntities("socios");
            $response->getBody()->write($resultado);
        return $response;
    });
    $app->get('/adhesionManifiesto', function ($request, $response) {
        $resultado = getEntities("adhesionesmanifiesto");
        $response->getBody()->write($resultado);
        return $response;
    });
    $app->get('/denuncia', function ($request, $response) {
        $resultado = getEntities("denuncias");
        $response->getBody()->write($resultado);
        return $response;
    });
    $app->get('/donacion', function ($request, $response) {
        $resultado = getEntities("donaciones");
        $response->getBody()->write($resultado);
        return $response;
    });
    $app->get('/users', function ($request, $response) use ($users) {
        $resultado = "";
        $response->getBody()->write($resultado);
        return $response;
    });
})->add(function ($request, $response, $next) use ($key){
    $response = $response->withHeader('Content-type', 'application/json');
        if (verifyToken($request, $key)){
           $response = $next($request, $response);
        } else {
            $response->getBody()->write("no autorizado");
        }
    return $response;
});


$app->group('/api', function () use ($app, $mysqli){
    $app->post('/socio', function ($request, $response) use ($mysqli){
        $value = $request->getBody();
        $result = insertEntity("socios", $value);
        $response->getBody()->write($result);
        return $response;
    });
    $app->post('/adhesionManifiesto', function ($request, $response){
        $value = $request->getBody();
        $result = insertEntity("adhesionesmanifiesto", $value);
        $response->getBody()->write($result);
        return $response;
    });
    $app->post('/denuncia', function ($request, $response){
        $value = $request->getBody();
        $result = insertEntity("denuncias", $value);
        $response->getBody()->write($result);
        return $response;
    });
    $app->post('/donacion', function ($request, $response){
        $value = $request->getBody();
        $result = insertEntity("donaciones", $value);
        $response->getBody()->write($result);
        return $response;
    });
})->add(function ($request, $response, $next) use ($key){
    $response = $response->withHeader('Content-type', 'application/json');
        if (verifyToken($request, $key)){
           $response = $next($request, $response);
        } else {
            $response->getBody()->write("no autorizado");
        }
    return $response;
});

$app->run();
