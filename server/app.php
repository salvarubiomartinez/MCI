<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require './server/vendor/autoload.php';

$app = new \Slim\App;

$app->get('/', function (Request $request, Response $response) {
    //$response->getBody()->write("rrr");
    $response->getBody()->write(file_get_contents("client/index.html"));

    return $response;
});

$app->get('/api', function (Request $request, Response $response) {
    $response->getBody()->write("Welcome to MCI Web Api");

    return $response;
});

$app->get('/api/denuncias', function (Request $request, Response $response) {
    $response->getBody()->write('[
    {
      "id": 1,
      "usuarioId": 1,
      "fecha": "12-12-2016",
      "nombre": "Maecenas vitae",
      "exposicion": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam tincidunt eros at risus convallis dapibus. Nulla facilisi. Etiam vel ante nibh. Maecenas nec lacus vel quam varius ultricies eu vitae sem. Mauris non ex et velit fringilla vehicula. Praesent quis aliquam elit. In hac habitasse platea dictumst. Etiam at turpis eu nisl interdum tincidunt. Maecenas hendrerit ultrices mi, vitae elementum elit tristique sed. Morbi ac augue nec ante posuere faucibus. Morbi tempus elit eget fringilla scelerisque.",
      "comentarios": [
        {
          "autor": "Felipe Martínez",
          "hora": "12:12:34:0000 12-12-2016",
          "contenido": "Curabitur ut tortor felis"
        }
      ]
    },
    {
      "id": 2,
      "usuarioId": 1,
      "fecha": "12-12-2016",
      "nombre": "Aliquam vehicula",
      "exposicion": "Aliquam ex erat, tristique sed dapibus ac, maximus nec tellus. Aliquam tincidunt posuere facilisis. Duis vel finibus justo, et rutrum lacus. Duis blandit mi velit. Vestibulum vitae elementum ligula, non hendrerit massa. Nam venenatis commodo augue, sit amet venenatis elit porta sed. Pellentesque facilisis, mauris at semper dignissim, ligula nunc venenatis mauris, nec cursus enim augue sit amet justo. Donec sagittis lacus a ipsum molestie, aliquam elementum eros lacinia. Maecenas quis sem egestas, dapibus orci sit amet, scelerisque ex.",
      "comentarios": [
        {
          "autor": "Felipe Martínez",
          "hora": "12:12:34:0000 12-12-2016",
          "contenido": "Vestibulum porta fermentum lorem, nec laoreet nunc sollicitudin vel"
        }
      ]
    }
  ]');
    return $response;
});

$app->get('/api/{name}', function (Request $request, Response $response) {
    $name = $request->getAttribute('name');
    $response->getBody()->write("Hello, $name");

    return $response;
});

$app->run();