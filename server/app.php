<?php

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require './server/vendor/autoload.php';

//sha1(value);
//crypt(value, key);

$mysqli = new mysqli('127.0.0.1', 'mci', 'mci', 'mci');

//$users = array(array('email' => 'pepe@yahoo.es', 'psswd' => '$2y$10$.4O1NR9FSOztr52bLw7aC.inKjVi0uLZ6SSTSYLELuAJmcerF4B7W'),array('email' => 'juan@gmail.com', 'psswd' => '$2y$10$.4O1NR9FSOztr52bLw7aC.inKjVi0uLZ6SSTSYLELuAJmcerF4B7W'),array('email' => 'maria@yahoo.es', 'psswd' => '$2y$10$.4O1NR9FSOztr52bLw7aC.inKjVi0uLZ6SSTSYLELuAJmcerF4B7W'));

$app = new \Slim\App;

$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write(file_get_contents("client/index.html"));

    return $response;
});

$app->post('/login', function (Request $request, Response $response) use ($mysqli){
    $json = $request->getBody();
    $login = json_decode($json);

    $stmt = $mysqli->prepare("SELECT password FROm users WHERE email = ?");
    $stmt->bind_param("s", $login->email);
    $userOk = $stmt->execute();
    $stmt->bind_result($password);
    $stmt->fetch();

    $stmt->close();
    $mysqli->close();

    if (!is_null($password)){
        var_dump(hash("sha256",'$5$rounds=5000$anexamplestringforsalt$'));
        if (password_verify($login->psswd, $password)){
            $token = crypt($login->email, hash("sha256",'$5$rounds=5000$anexamplestringforsalt$'));
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
    $hashed_password = password_hash($login->psswd, PASSWORD_DEFAULT);

    $stmt = $mysqli->prepare("INSERT INTO users (email, password) VALUES (?, ?)");
    $stmt->bind_param("ss", $login->email, $hashed_password);    
    if ($stmt->execute()===TRUE){
            $response->getBody()->write($hashed_password);
    } else {
            $response->getBody()->write("error");
    }    
    var_dump($hashed_password);
    $stmt->close();
    $mysqli->close();
    return $response;
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
