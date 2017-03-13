import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Routing exposing (Routing(..))
import Login exposing (..)
import Administracion exposing (..)
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
            error = Nothing}, 
        Cmd.none)

--updateRoute route = 

update msg model = 
    case msg of UpdateRoute route ->
                    updateRoute route model
                LoginMsg a ->
                    loginUpdate a model
                AdministracionMsg a ->
                    administracionUpdate a model

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
                    Routing.Index -> div [][]                   
                    EnviarColaboracion -> div [][] 
                    EnviarDenuncia -> div [][] 
                    AdherirManifiesto -> div [][]                   
                    Administracion  -> administracionView model
            )
            ]
            

--getDenuncias: Cmd Msg
getDenuncias = Http.send (\a -> AdministracionMsg (GetInfo a)) 
  <| Http.get "http://localhost:3000/denuncias" 
  <| Json.list denunciaDecoder

--sendLogin: Cmd Msg
--sendLogin = Http.send GetDenuncias 
--  <| Http.get "http://localhost:3000/denuncias" 
--  <| Json.list denunciaDecoder

type Lista a = Nada | Cons a (Lista a)

lista = Cons 3 (Cons 4(Cons 2 Nada))

mapear f lis =
    case lis of 
        Nada -> Nada
        Cons x xs -> Cons (f x) (mapear f xs)