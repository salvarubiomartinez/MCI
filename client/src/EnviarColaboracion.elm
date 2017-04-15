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

enviarColaboracionUpdate: EnviarColaboracionActions -> Model -> (Model, Cmd Msg)
enviarColaboracionUpdate msg model =
     case model.colaboracion of
                Nothing -> (model, Cmd.none)
                Just colab ->
                    case msg of
                        UpdateColaboracionNom val ->
                            ({model | colaboracion = Just ({colab | nom = val })}, Cmd.none)
                        UpdateColaboracionCognoms val ->
                            ({model | colaboracion = Just ({colab | cognoms = val })}, Cmd.none)
                        UpdateColaboracionDni val ->
                            ({model | colaboracion = Just ({colab | dni = val })}, Cmd.none)
                        UpdateColaboracionLocalitat val ->
                            ({model | colaboracion = Just ({colab | localitat = val })}, Cmd.none)
                        UpdateColaboracionPoblacio val ->
                            ({model | colaboracion = Just ({colab | poblacio = val })}, Cmd.none)
                        PostColaboracion colaboracion ->
                            if checkColaboracion colaboracion 
                            then
                                case model.usuario of
                                                Nothing -> (model, Cmd.none)
                                                Just user -> (model, postColaboracion user colaboracion)
                            else (model, Cmd.none)
                        PostColaboracionResponse (Ok response) ->
                            ({model | route = Index}, Cmd.none)
                        PostColaboracionResponse (Err error) ->
                            ({model | error = Just (toString error)}, Cmd.none)

checkColaboracion: Colaboracion -> Bool
checkColaboracion colaboracion = 
    if String.isEmpty colaboracion.nom || String.isEmpty colaboracion.cognoms || String.isEmpty colaboracion.dni then False else True  

postColaboracion : Usuario -> Colaboracion -> Cmd Msg
postColaboracion usuario colaboracion = Http.send (\a -> EnviarColaboracionMsg (PostColaboracionResponse a)) 
  <| loginColaboracion usuario colaboracion--Http.post "http://localhost/mci/api/socio" (Http.jsonBody (encodeColaboracion colaboracion)) colaboracionDecoder


loginColaboracion : Usuario -> Colaboracion -> Request Colaboracion
loginColaboracion usuario colaboracion =
  Http.request
    { method = "POST"
    , headers = [Http.header "Content-Type" "application/json", Http.header "Authorization" (usuario.email ++", "++ usuario.token)]
    , url = apiUrl ++ "/api/socio"
    , body = jsonBody (encodeColaboracion ({colaboracion| email = usuario.email}))
    , expect = expectJson colaboracionDecoder
    , timeout = Nothing
    , withCredentials = False
    }



encodeColaboracion : Colaboracion -> Encode.Value
encodeColaboracion colaboracion = 
    Encode.object
      [ ("nom", Encode.string colaboracion.nom)
      , ("cognoms", Encode.string colaboracion.cognoms)
      , ("email", Encode.string colaboracion.email)
      , ("dni", Encode.string colaboracion.dni)
      , ("localitat", Encode.string colaboracion.localitat)
      , ("poblacio", Encode.string colaboracion.poblacio)
      ]

enviarColaboracionView: Model -> Html Msg
enviarColaboracionView model = 
    let 
        colaboracion = case model.colaboracion of
            Nothing -> Colaboracion "" "" "" "" "" ""
            Just colab -> colab
    in
    div [][
        h1 [][text "Colaboración"],
 --       p [][text <| "nom: " ++ colaboracion.nom],
        inputView "Nom" UpdateColaboracionNom colaboracion.nom,
        inputView "Cognoms" UpdateColaboracionCognoms colaboracion.cognoms,
        inputView "Dni" UpdateColaboracionDni colaboracion.dni,
        inputView "Localitat" UpdateColaboracionLocalitat "not required",
        inputView "Poblacio" UpdateColaboracionPoblacio "not required",
        div [class "form-group"][
            button [class "btn btn-default", onClick (EnviarColaboracionMsg (PostColaboracion colaboracion))][text "enviar"]
        ],
        div [class "form-group"][
            button [class "btn btn-default", onClick (UpdateRoute Index)][text "cancel·lar"]
        ]
    ]


inputView labelName msg valor =
    div [class "form-group"][
            label [][text labelName],
            input [class "form-control", attribute "required" "true", onInput <| EnviarColaboracionMsg << msg][],
            p [style [("color","red")]][text (if valor == "" then "Aquest camp és obligatori" else "")]
        ]