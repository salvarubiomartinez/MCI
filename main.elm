import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Routing exposing (Routing(..))
import Login exposing (..)
import Msgs exposing (..)

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = (\ model -> Sub.none)
    }
 
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
        Cmd.none)

update msg model = 
    case msg of LoginMsg a ->
        loginUpdate a model
        
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
            

--getDenuncias: Cmd Msg
--getDenuncias = Http.send GetDenuncias 
--  <| Http.get "http://localhost:3000/denuncias" 
--  <| Json.list denunciaDecoder

--sendLogin: Cmd Msg
--sendLogin = Http.send GetDenuncias 
--  <| Http.get "http://localhost:3000/denuncias" 
--  <| Json.list denunciaDecoder
