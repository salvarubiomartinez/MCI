module Login exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)

loginUpdate msg model =
            case msg of
                UpdateLoginEmail email ->
                    ({ model | login = {email = email, psw = model.login.psw}}, Cmd.none)
                UpdateLoginPsw psw ->
                    ({ model | login = {email = model.login.email, psw = psw}}, Cmd.none)
                SubmitLogin ->
                    (model, Cmd.none)

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
             button [class "btn btn-default", onClick (UpdateRoute Administracion)][text "admin"]
            ],
        div [class "form-group"][
             button [class "btn btn-default", onClick (UpdateRoute Index)][text "user"]
            ]
        ]
    ]