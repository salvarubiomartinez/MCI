module EnviarColaboracion exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)
import Models exposing (..)
import Http exposing (..)
import Json.Decode as Json
import Json.Encode as Encode
import Settings exposing (..)


enviarColaboracionUpdate msg model =
    case msg of
        UpdateColaboracion info ->
            ({model | colaboracion = Just (Colaboracion 1 info)}, Cmd.none)
        PostColaboracion colaboracion ->
            case colaboracion of
                Nothing -> (model, Cmd.none)
                Just colab -> case model.usuario of
                                Nothing -> (model, Cmd.none)
                                Just user -> (model, postColaboracion user colab)
        PostColaboracionResponse (Ok response) ->
            ({model | route = Index}, Cmd.none)
        PostColaboracionResponse (Err error) ->
            ({model | error = Just (toString error)}, Cmd.none)

postColaboracion : Usuario -> Colaboracion -> Cmd Msg
postColaboracion usuario colaboracion = Http.send (\a -> EnviarColaboracionMsg (PostColaboracionResponse a)) 
  <| loginColaboracion usuario colaboracion--Http.post "http://localhost/mci/api/socio" (Http.jsonBody (encodeColaboracion colaboracion)) colaboracionDecoder


loginColaboracion : Usuario -> Colaboracion -> Request Colaboracion
loginColaboracion usuario colaboracion =
  Http.request
    { method = "POST"
    , headers = [Http.header "Content-Type" "application/json", Http.header "Authorization" (usuario.email ++", "++ usuario.token)]
    , url = apiUrl ++ "/api/socio"
    , body = jsonBody (encodeColaboracion colaboracion)
    , expect = expectJson colaboracionDecoder
    , timeout = Nothing
    , withCredentials = False
    }



encodeColaboracion : Colaboracion -> Encode.Value
encodeColaboracion colaboracion = 
    Encode.object
      [ ("usuarioId", Encode.int colaboracion.usuarioId)
      , ("info", Encode.string colaboracion.info)
      ]

enviarColaboracionView model = 
    let 
        colaboracion = case model.colaboracion of
            Nothing -> Colaboracion 1 ""
            Just colab -> colab
    in
    div [][
        h1 [][text "Colaboración"],
        p [][text <| "info: " ++ colaboracion.info],
        div [class "form-group"][
            label [][text "info"],
            textarea [class "form-control", attribute "rows" "3", onInput (\st -> EnviarColaboracionMsg (UpdateColaboracion st))][]
        ],
        div [class "form-group"][
            button [class "btn btn-default", onClick (EnviarColaboracionMsg (PostColaboracion model.colaboracion))][text "enviar"]
        ]
    ]