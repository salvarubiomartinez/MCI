<?php

function db ($fn){
    $hostname = hostname;
    $database = database;
    $username = username;
    $password = password;

    $mysqli = new mysqli($hostname, $username,$password, $database);
    if ($mysqli -> connect_errno) {
        die( "Fallo la conexión a MySQL: (" . $mysqli->connect_errno 
        . ") " . $mysqli->connect_error);
    }       
    $result = $fn($mysqli);
    $mysqli->close();
    return $result;
}

function getPassword($email){
    return db(function ($mysqli) use ($email){
        $stmt = $mysqli->prepare("SELECT password FROM users WHERE email = ? AND locked = 1");
        $stmt->bind_param("s", $email);
        $userOk = $stmt->execute();
        $stmt->bind_result($password);
        $stmt->fetch();
        $stmt->close();
        return $password;
    });
}

function createUsers($email, $password){
    return db(function ($mysqli) use ($email, $password){
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $mysqli->prepare("INSERT INTO users (email, password) VALUES (?, ?)");
        $stmt->bind_param("ss", $email, $hashed_password);    
        $response = $stmt->execute(); 
        $stmt->close();
        return $response;
    });   
}

function getEntities($entityName){
    return db(function ($mysqli) use ($entityName){
        $sql = "SELECT data FROM $entityName";
        $result = $mysqli->query($sql);
        $response = '[' . $result->fetch_assoc()['data'];
        if ($result){
            while ($entity = $result->fetch_assoc()) {
                $response = $response .',' .  $entity['data'];
            }   
        }
        $response = $response . ']';
        return $response;
    });
}

function insertEntity($entityName, $value){
    return db(function ($mysqli) use ($entityName, $value){
        $sql = "INSERT INTO $entityName (data) VALUES ('$value')";
        if ($mysqli->query($sql) === TRUE) {
            $response = $value;
        } else {
             $response = "Error: " . $sql . "<br>" . $mysqli->error;
        } 
        return $response;
    });
}

function enableUser($mail){
    return db(function ($mysqli) use ($mail){
        $sql = "UPDATE users SET locked = 1 WHERE email = '$mail'";
        if ($mysqli->query($sql) === TRUE) {
            $response = "usuario activado";
        } else {
             $response = "Error: " . $sql . "<br>" . $mysqli->error;
        } 
        return $response;
    });
}