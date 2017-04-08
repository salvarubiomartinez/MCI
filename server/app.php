<?php

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require './server/vendor/autoload.php';
require './server/db.php';
require './server/mail.php';
include('settings.php');

$app = new \Slim\App;

function verifyToken($request) {   
    if ($request->hasHeader('User') && $request->hasHeader('Token')) {
           if (count($request->getHeader('User')) > 0 && count($request->getHeader('Token')) > 0) {              
             $user = implode ($request->getHeader('User'),'');
             $token =implode ($request->getHeader('Token'),'');
             return password_verify($user, $token);
            }
    }
    return false;
}

$app->get('/', function (Request $request, Response $response) {
    $response->getBody()->write(file_get_contents("client/index.html"));

    return $response;
});

$app->post('/login', function (Request $request, Response $response)  {
    $json = $request->getBody();
    $login = json_decode($json);
    $password = getPassword($login->email);
    
    if (!is_null($password)){
        if (password_verify($login->psswd, $password)){
            $token = password_hash($login->email, PASSWORD_DEFAULT); 
            $response->getBody()->write($token);
        } else {
            $response->getBody()->write("incorrect password");
        }
    } else {
        $response->getBody()->write("user not found");
    }
    return $response;
});

$app->post('/register', function (Request $request, Response $response) {
    $json = $request->getBody();
    $login = json_decode($json);
    $email = $login->email;
    $result = createUsers($email, $login->psswd);
    
    if ($result === TRUE){
            $verifyToken = crypt($email, KEY);
            $link = "http://localhost/mci/mailVerification?mail=$email&token=$verifyToken";
            sendMail($email, $link);
            $response->getBody()->write("Hemos enviado un correo a $email. Por favor, accede al link para activar tu cuenta.");
    } else {
            $response->getBody()->write("error");
    }    
    return $response;
});

$app->get('/mailVerification', function (Request $request, Response $response)  {
    $mail = $request->getParam('mail');
    $token = $request->getParam('token');
    $verifyToken = crypt($mail, KEY);
    if ($verifyToken == $token){
        $result = enableUser($mail);
        $response->getBody()->write($result);
    } else {
         $response->getBody()->write("error");
    }
    return $response;
});

$app->group('/admin', function () use ($app) {
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
    $app->get('/users', function ($request, $response) {
        $resultado = "";
        $response->getBody()->write($resultado);
        return $response;
    });
})->add(function ($request, $response, $next) {
    $response = $response->withHeader('Content-type', 'application/json');
        if (verifyToken($request)){
           $response = $next($request, $response);
        } else {
            $response->getBody()->write("no autorizado");
        }
    return $response;
});


$app->group('/api', function () use ($app) {
    $app->post('/socio', function ($request, $response){
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
})->add(function ($request, $response, $next) {
    $response = $response->withHeader('Content-type', 'application/json');
        if (verifyToken($request)){
           $response = $next($request, $response);
        } else {
            $response->getBody()->write("no autorizado");
        }
    return $response;
});

//allow cors
$app->options('/{routes:.+}', function ($request, $response, $args) {
    return $response;
});

$app->add(function ($req, $res, $next) {
    $response = $next($req, $res);
    return $response
            ->withHeader('Access-Control-Allow-Origin', 'http://mysite')
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
});


$app->run();
