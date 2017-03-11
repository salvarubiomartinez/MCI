import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
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

--Routing
type Routing = Login
    | Registro
    | Index
    | EnviarColaboracion
    | EnviarDenuncia
    | AdherirManifiesto
    | Administracion

--Model
type alias LoginUser = {email: String, psw : String}
type alias Usuario = {id : Int, nombre : String, dni :String}
type alias Denuncia = {id: Int, usuarioId : Int, fecha : String, nombre: String, exposicion : String} --, comentarios : List Comentario}
--type alias Comentario = {autor: String, hora : String, contenido : String}
type alias AdhesionManifiesto = {id: Int, usuarioId: Int, info : String}
type alias Colaboracion = {id: Int, usuarioId: Int, info : String}

type alias Model = {usuario: Maybe Usuario,
                    login: LoginUser,
                    route: Routing,
                    allItems : {denuncias: List Denuncia, adhesiones: List AdhesionManifiesto, colaboraciones: List Colaboracion},
                    denuncia : Maybe Denuncia,
                    adhesion : Maybe AdhesionManifiesto,
                    colaboracion : Maybe Colaboracion,
                    error : Maybe String}

--Decoders
usuarioDecoder: Json.Decoder Usuario
usuarioDecoder = Json.map3
  Usuario 
    (Json.field "id" Json.int)
    (Json.field "nombre" Json.string)
    (Json.field "dni" Json.string)

denunciaDecoder: Json.Decoder Denuncia
denunciaDecoder = Json.map5
  Denuncia
    (Json.field "id" Json.int)
    (Json.field "usuarioId" Json.int)
    (Json.field "fecha" Json.string)
    (Json.field "nombre" Json.string)
    (Json.field "exposicion" Json.string)
--   (Json.field "comentarios" (Json.list comentarioDecoder))

--comentarioDecoder: Json.Decoder Comentario
--comentarioDecoder = Json.map3
--    Comentario 
--        (Json.field "autor" Json.string)
--        (Json.field "hora" Json.string)
--        (Json.field "contenido" Json.string)

-- Init
init : (Model, Cmd Msg)
init = ({usuario = Nothing, 
            login = LoginUser "" "",
            route = Login,
            allItems = {denuncias = [], adhesiones= [], colaboraciones= []},
            denuncia = Nothing,
            adhesion = Nothing,
            colaboracion = Nothing,
            error = Nothing}, 
        getDenuncias)

type Msg = UpdateLoginEmail String
    | UpdateLoginPsw String
    | GetDenuncias (Result Http.Error (List Denuncia))
    | CreateDenuncia (Result Http.Error (List Denuncia))
    | ReadDenuncia (Result Http.Error (Denuncia))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
            case msg of
                UpdateLoginEmail email ->
                    ({ model | login = {email = email, psw = model.login.psw}}, Cmd.none)
                UpdateLoginPsw psw ->
                    ({ model | login = {email = model.login.email, psw = psw}}, Cmd.none)
                GetDenuncias (Ok denuncias) ->
                    ( { model | allItems = {  denuncias = denuncias,  adhesiones= model.allItems.adhesiones, colaboraciones= []} } , Cmd.none)
                GetDenuncias (Err a) ->
                    ({model|error = Just (toString a)}, Cmd.none)
                ReadDenuncia (Ok denuncia) ->
                    ( model, Cmd.none)
                ReadDenuncia (Err a) ->
                    ({model|error = Just (toString a)}, Cmd.none)
                CreateDenuncia (Ok denuncias) ->
                    ( model, Cmd.none)
                CreateDenuncia (Err a) ->
                    ({model|error = Just (toString a)}, Cmd.none)
        
  
    


view : Model -> Html Msg
view model = 
    
            div [class "container"][
            div [class "panel panel-warning"][
                div [class "panel-body"][text (case model.error of 
                                                    Nothing -> ""
                                                    Just error -> 
                                                    "error: " ++ error)]
            ],
            (
                case model.route of      
                    Login -> loginView model.login
                    Registro -> div [][]
                    Index -> div [][]                   
                    EnviarColaboracion -> div [][] 
                    EnviarDenuncia -> div [][] 
                    AdherirManifiesto -> div [][]                   
                    Administracion  ->
                        div [][
                        h1 [][text "Tus denuncias"],
                        div [class "list-group"]
                            <| List.map (\ denuncia ->
                            a [class "list-group-item"][
                                h4 [class "list-group-item-heading"][text denuncia.nombre],
                                p[class "list-group-item-text"][text denuncia.fecha]]) model.allItems.denuncias
                        ]
            )
            ]
            
loginView login = div [][
    p [][text login.email],
    h3 [][text "Login"],
    Html.form [][
        div [class "form-gorup"][
                label [][text "Email"],
                input [class "form-control",placeholder "enter email", type_ "email", onInput UpdateLoginEmail][]
            ],
        div [class "form-gorup"][
                label [][text "Password"],
                input [class "form-control",placeholder "enter password", type_ "password", onInput UpdateLoginPsw][]
            ],
        div [class "form-gorup"][
             button [class "btn btn-default", type_ "submit"][text "submit"]
            ]
        ]
    ]

getDenuncias: Cmd Msg
getDenuncias = Http.send GetDenuncias 
  <| Http.get "http://localhost:3000/denuncias" 
  <| Json.list denunciaDecoder
