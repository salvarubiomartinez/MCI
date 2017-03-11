import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Json

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

--Model
type alias Usuario = {id : Int, nombre : String, dni :String}
type alias Denuncia = {id: Int, usuarioId : Int, fecha : String, nombre: String, exposicion : String, comentarios : List Comentario}
type alias Comentario = {autor: String, hora : String, contenido : String}

type alias Model = {usuario: Usuario, 
                    denuncias: List Denuncia,
                    selectedDenuncia: Denuncia, 
                    error : String}

--Decoders
usuarioDecoder: Json.Decoder Usuario
usuarioDecoder = Json.map3
  Usuario 
    (Json.field "id" Json.int)
    (Json.field "nombre" Json.string)
    (Json.field "dni" Json.string)

denunciaDecoder: Json.Decoder Denuncia
denunciaDecoder = Json.map6
  Denuncia
    (Json.field "id" Json.int)
    (Json.field "usuarioId" Json.int)
    (Json.field "fecha" Json.string)
    (Json.field "nombre" Json.string)
    (Json.field "exposicion" Json.string)
    (Json.field "comentarios" (Json.list comentarioDecoder))

comentarioDecoder: Json.Decoder Comentario
comentarioDecoder = Json.map3
    Comentario 
        (Json.field "autor" Json.string)
        (Json.field "hora" Json.string)
        (Json.field "contenido" Json.string)

-- Init
init : (Model, Cmd Msg)
init = (Model (Usuario 1 "Mario Casas" "12345678M")  [] (Denuncia 0 0 "" "" "" []) "no error", getDenuncias)

type Msg = GetDenuncias (Result Http.Error (List Denuncia))
  | CreateDenuncia (Result Http.Error (List Denuncia))
  | ReadDenuncia (Result Http.Error (Denuncia))
  | UpdateDenuncia (Result Http.Error (List Denuncia))
  | DeleteDenuncia (Result Http.Error (List Denuncia))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetDenuncias (Ok denuncias) ->
        ( {model | denuncias = denuncias }, Cmd.none)
    GetDenuncias (Err a) ->
        ({model|error = toString a}, Cmd.none)
    CreateDenuncia (Ok denuncias) ->
        ( {model | denuncias = denuncias }, Cmd.none)
    CreateDenuncia (Err a) ->
        ({model|error = toString a}, Cmd.none)
    ReadDenuncia (Ok denuncia) ->
        let denuncias = List.map 
                            (\ denun -> 
                                if denun.id == denuncia.id 
                                then denuncia 
                                else denun) 
                            model.denuncias
        in
        ( {model | denuncias = denuncias }, Cmd.none)
    ReadDenuncia (Err a) ->
        ({model|error = toString a}, Cmd.none)
    UpdateDenuncia (Ok denuncias) ->
        ( {model | denuncias = denuncias }, Cmd.none)
    UpdateDenuncia (Err a) ->
        ({model|error = toString a}, Cmd.none)
    DeleteDenuncia (Ok denuncias) ->
        ( {model | denuncias = denuncias }, Cmd.none)
    DeleteDenuncia (Err a) ->
        ({model|error = toString a}, Cmd.none)

view : Model -> Html Msg
view model = div [class "container"][
  div [class "panel panel-warning"][
    div [class "panel-body"][text ("error: " ++ model.error)]
  ],
  h1 [][text "Tus denuncias"],
  div [class "list-group"]
    <| List.map (\ denuncia ->
    a [class "list-group-item"][
        h4 [class "list-group-item-heading"][text denuncia.nombre],
        p[class "list-group-item-text"][text denuncia.fecha]
    ]
    
    ) model.denuncias]
   

getDenuncias: Cmd Msg
getDenuncias = Http.send GetDenuncias 
  <| Http.get "http://localhost:3000/denuncias" 
  <| Json.list denunciaDecoder
