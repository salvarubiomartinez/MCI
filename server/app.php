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

$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write(file_get_contents("client/index.html"));

    return $response;
});

$app->post('/login', function (Request $request, Response $response) {
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

$app->group('/admin', function () use ($app, $users) {
    $app->get('/socio', function ($request, $response) {
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
})->add(function ($request, $response, $next) use ($key) {
    $user = implode ($request->getHeader('User'),'');
    //var_dump($user);
    $token = $request->getHeader('Token')[0];
    //var_dump($token);
    $validToken = $token === crypt($user, hash("sha256", $key));
    if ($validToken){
        $response = $response->withHeader('Content-type', 'application/json');
        $response = $next($request, $response);
    } else {
        //$response = $next($request, $response);
    }
    return $response;
});


$app->group('/api', function () use ($app, $mysqli){
    $app->post('/socio', function ($request, $response) use ($mysqli){
        $result = $request->getBody();
        $sql = "INSERT INTO socios (data) VALUES ('$result')";
        if ($mysqli->query($sql) === TRUE) {
            $response->getBody()->write($result);
            //$response->getBody()->write("New record created successfully");
        } else {
             $response->getBody()->write("Error: " . $sql . "<br>" . $mysqli->error);
        }

        $mysqli->close();
        return $response;
    });
    $app->post('/adhesionManifiesto', function ($request, $response){
            $response->getBody()->write("Error:");
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
