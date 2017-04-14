module Login exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)
import Http exposing (..)
import Settings exposing (..)
import Models exposing (..)
import Json.Encode as Encode

loginUpdate: LoginMsgActions -> Model -> (Model, Cmd Msg)
loginUpdate msg model =
            case msg of
                UpdateLoginEmail email ->
                    ({ model | login = {email = email, psw = model.login.psw}}, Cmd.none)
                UpdateLoginPsw psw ->
                    ({ model | login = {email = model.login.email, psw = psw}}, Cmd.none)
                SubmitLogin login ->
                    (model, loginSend login)
                GetLogin (Ok token) ->
                    ({ model | error = Just token}, Cmd.none)
                GetLogin (Err error) ->
                    ({ model | error = Just (toString error)}, Cmd.none)


loginPost : LoginUser -> Request String
loginPost login =
  Http.request
    { method = "POST"
    , headers = [Http.header "Content-Type" "application/json"]
    , url = apiUrl
    , body = jsonBody (Encode.object
      [ ("email", Encode.string login.email)
      , ("psswd", Encode.string login.psw)
      ])
    , expect = expectString
    , timeout = Nothing
    , withCredentials = False
    }

loginSend: LoginUser -> Cmd Msg
loginSend login = Http.send (\a -> LoginMsg (GetLogin a))  <| loginPost login

loginView: LoginUser -> Html Msg
loginView login = div [][
    p [][text <| "email :" ++ login.email],
    p [][text <| "passwotd :" ++ login.psw],
    h3 [][text "Login"],
    div [][
        div [class "form-group"][
                label [][text "Email"],
                input [class "form-control",placeholder "enter email", type_ "email", onInput (\st -> LoginMsg (UpdateLoginEmail st)) ][]
            ],
        div [class "form-group"][
                label [][text "Password"],
                input [class "form-control",placeholder "enter password", type_ "password", onInput (\st -> LoginMsg (UpdateLoginPsw st))][]
            ],
        div [class "form-group"][
             button [class "btn btn-default", onClick ( LoginMsg (SubmitLogin login) )][text "entrar"]
            ],
        div [class "form-group"][
             button [class "btn btn-default", onClick (UpdateRoute Index)][text "reggistrarse"]
            ]
        ]
    ]