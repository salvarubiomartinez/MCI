import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Routing exposing (Routing(..))
import Login exposing (..)
import Administracion exposing (..)
import Index exposing(..)
import EnviarColaboracion exposing (..)
import EnviarDenuncia exposing (..)
import EnviarAdhesion exposing (..)
import Msgs exposing (..)
import Http exposing (..)
import Json.Decode as Json


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
            selectedTab = TabDenuncias,
            error = Nothing}, 
        Cmd.none)

--updateRoute route = 

update msg model = 
    case msg of UpdateRoute route ->
                    updateRoute route model
                LoginMsg action ->
                    loginUpdate action model
                AdministracionMsg action ->
                    administracionUpdate action model
                EnviarColaboracionMsg action ->
                    enviarColaboracionUpdate action model

updateRoute route model =
    case route of 
        Login -> ({model | route = route}, Cmd.none)
        Registro -> ({model | route = route}, Cmd.none)
        Index -> ({model | route = route}, Cmd.none)
        EnviarColaboracion -> ({model | route = route}, Cmd.none)
        EnviarDenuncia -> ({model | route = route}, Cmd.none)
        AdherirManifiesto -> ({model | route = route}, Cmd.none)
        Administracion -> ({model | route = route}, getDenuncias)
        

        
view : Model -> Html Msg
view model = 
            let error = case model.error of 
                            Nothing -> ""
                            Just error -> "error: " ++ error
            in
            div [class "container"][
            div [class "panel panel-warning"][
                div [class "panel-body"][text (error ++ "route: " ++ toString (model.route))]
            ],
            (
                case model.route of      
                    Login -> loginView model.login
                    Registro -> div [][]
                    Index -> indexView model                  
                    EnviarColaboracion -> enviarColaboracionView model 
                    EnviarDenuncia -> enviarDenunciaView model 
                    AdherirManifiesto -> enviarAdhesionView model                  
                    Administracion  -> administracionView model
            )
            ]