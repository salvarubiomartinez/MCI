module Register exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)
import Http exposing (..)
import Settings exposing (..)
import Models exposing (..)
import Json.Encode as Encode

registerUpdate: RegisterMsgActions -> Model -> (Model, Cmd Msg)
registerUpdate msg model =
            case msg of
                UpdateRegisterEmail email ->
                    ({ model | register = {email = email, psw = model.register.psw, psw2 = model.register.psw2}}, Cmd.none)
                UpdateRegisterPsw psw ->
                    ({ model | register = {email = model.register.email, psw = psw, psw2 = model.register.psw2}}, Cmd.none)
                UpdateRegisterPsw2 psw2 ->
                    ({ model | register = {email = model.register.email, psw = model.register.psw, psw2 = psw2}}, Cmd.none)
                SubmitRegister register ->
                    (model, registerSend register)
                GetRegister (Ok messsage) ->
                    ({ model | route = Login, error = Just messsage }, Cmd.none)
                GetRegister (Err error) ->
                    ({ model | error = Just (toString error)}, Cmd.none)


registerPost : Register -> Request String
registerPost register =
  Http.request
    { method = "POST"
    , headers = [Http.header "Content-Type" "application/json"]
    , url = apiUrl ++ "/register"
    , body = jsonBody (Encode.object
      [ ("email", Encode.string register.email)
      , ("psswd", Encode.string register.psw)
      ])
    , expect = expectString
    , timeout = Nothing
    , withCredentials = False
    }

registerSend: Register -> Cmd Msg
registerSend register = Http.send (\a -> RegisterMsg (GetRegister a))  <| registerPost register
--
registerView: Register -> Html Msg
registerView register = div [][
    --p [][text <| "email :" ++ register.email],
    --p [][text <| "passwotd :" ++ register.psw],
    --p [][text <| "passwotd2 :" ++ register.psw2],
    h3 [][text "Register"],
    div [][
        div [class "form-group"][
                label [][text "Email"],
                input [class "form-control",placeholder "enter email", type_ "email", onInput (\st -> RegisterMsg (UpdateRegisterEmail st)) ][]
            ],
        div [class "form-group"][
                label [][text "Password"],
                input [class "form-control",placeholder "enter password", type_ "password", onInput (\st -> RegisterMsg (UpdateRegisterPsw st))][]
            ],
        div [class "form-group"][
                label [][text "Repeat Password"],
                input [class "form-control",placeholder "enter password", type_ "password", onInput (\st -> RegisterMsg (UpdateRegisterPsw2 st))][],
                p [style [("color","red")]][text (if register.psw == register.psw2 then "" else "el password no coincide" )]
            ],
        div [class "form-group"][
             button [class "btn btn-default", onClick ( RegisterMsg (SubmitRegister register) )][text "enviar"]
            ],
        div [class "form-group"][
             button [class "btn btn-default", onClick (UpdateRoute Index)][text "volver"]
            ]
        ]
    ]