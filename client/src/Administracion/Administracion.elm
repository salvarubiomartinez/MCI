module Administracion exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)
import Models exposing (..)
import Http exposing (..)
import Json.Decode as Json
import Settings exposing (..)

administracionUpdate : AdministracionMsg -> Model -> (Model, Cmd Msg)
administracionUpdate msg model =
    case msg of 
        GetInfo (Ok info)->
            let
                allItems = model.allItems
                user = case model.usuario of
                    Nothing -> Usuario "" ""
                    Just u -> u
            in
            ({ model | allItems = { allItems | denuncias = info} }, getadhesionManifiesto user)
        GetInfo (Err error) ->
            ({model | error = Just (toString error)}, Cmd.none)
        GetadhesionManifiesto (Ok adhesiones) ->
            let
                allItems = model.allItems
                user = case model.usuario of
                    Nothing -> Usuario "" ""
                    Just u -> u
            in
            ({ model | allItems = { allItems | adhesiones = adhesiones} }, getColaboracion user)
        GetadhesionManifiesto (Err error) ->
            ({model | error = Just (toString error)}, Cmd.none)
        GetColaboracion (Ok colaboraciones) ->
            let
                allItems = model.allItems
            in
            ({ model | allItems = { allItems | colaboraciones = colaboraciones} }, Cmd.none)
        GetColaboracion (Err error) ->
            ({model | error = Just (toString error)}, Cmd.none)
        SelectDenuncia denuncia ->
            ({model | denuncia = Just denuncia}, Cmd.none)
        SelectAdhesion adhesion ->
            ({model | adhesion = Just adhesion}, Cmd.none)
        SelectColaboracion colaboracion ->
            ({model | colaboracion = Just colaboracion}, Cmd.none)
        ChangeTab selection ->
            ({model | selectedTab = selection, denuncia = Nothing, adhesion = Nothing, colaboracion = Nothing}, Cmd.none)


getDenuncias: Usuario -> Cmd Msg
getDenuncias usuario = Http.send (\a -> AdministracionMsg (GetInfo a)) 
  <| getItems "/admin/denuncia" usuario-- Http.get (apiUrl ++ "/admin/denuncia")
  <| Json.list denunciaDecoder

getadhesionManifiesto: Usuario -> Cmd Msg
getadhesionManifiesto usuario = Http.send (\a -> AdministracionMsg (GetadhesionManifiesto a)) 
  <| getItems "/admin/adhesionManifiesto" usuario--Http.get (apiUrl ++ "/admin/adhesionManifiesto")
  <| Json.list adhesionManifiestoDecoder

getColaboracion: Usuario -> Cmd Msg
getColaboracion usuario = Http.send (\a -> AdministracionMsg (GetColaboracion a)) 
  <| getItems  "/admin/socio" usuario -- Http.get (apiUrl ++ "/admin/socio")
  <| Json.list colaboracionDecoder

--getColaboracion : Usuario -> Colaboracion -> Request Colaboracion
getItems url usuario decoder =
  Http.request
    { method = "GET"
    , headers = [Http.header "Content-Type" "application/json", Http.header "Authorization" (usuario.email ++", "++ usuario.token)]
    , url = apiUrl ++ url
    , body = emptyBody
    , expect = expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

administracionView : Model -> Html Msg
administracionView model = 
                let 
                    denuncia = case model.denuncia of
                                Nothing -> {nombre = "", exposicion= ""}
                                Just denun -> {nombre= denun.nombre, exposicion = denun.exposicion}

                    adhesion = case model.adhesion of
                                Nothing -> {usuarioId = "", info = ""}
                                Just adhe -> {usuarioId = (toString adhe.usuarioId), info = adhe.info}

                    colaboracion = case model.colaboracion of
                                Nothing -> Colaboracion "" "" "" "" "" ""
                                Just cola -> cola

                    tabDenuncias = if model.selectedTab == TabDenuncias then "active" else ""
                    tabAdhesiones = if model.selectedTab == TabAdhesiones then "active" else ""
                    tabColaboraciones = if model.selectedTab == TabColaboraciones then "active" else ""
                in
                    div [][
                        h1 [][text "Administración"],
                        ul [class "nav nav-tabs nav-justified"][
                            li [ class tabDenuncias, attribute "role" "presentation"][
                                a [onClick (AdministracionMsg (ChangeTab TabDenuncias))][text "denuncias"]
                            ],
                            li [class tabAdhesiones][
                                a [ onClick (AdministracionMsg (ChangeTab TabAdhesiones))][text "subscripciones"]
                            ],
                            li [class tabColaboraciones][
                                a [onClick (AdministracionMsg (ChangeTab TabColaboraciones))][text "colaboraciones"]
                            ]
                        ],
                        br [][],
                        div [class "col-md-12"][
                            div [class "tab-content"][
                                div [class ("tab-pane" ++ tabDenuncias)][
                                    div [class "list-group col-md-4"]
                                    <| List.map (\ denun ->
                                    a [class ("list-group-item" ++ (if denuncia.nombre == denun.nombre then " active" else "")),
                                        onClick (AdministracionMsg (SelectDenuncia denun))][
                                        h4 [class "list-group-item-heading"][text denun.nombre],
                                        p[class "list-group-item-text"][text denun.fecha]]) model.allItems.denuncias,
                                    div [class "col-md-8"][
                                        div [][
                                            p [][text ("nombre: " ++ denuncia.nombre)],
                                            p [][text ("exposicion: " ++ denuncia.exposicion)]
                                        ]
                                    ]
                                ],
                                div [class ("tab-pane" ++ tabAdhesiones)][
                                    div [class "list-group col-md-4"]
                                    <| List.map (\ denuncia ->
                                    a [class ("list-group-item" ++ (if adhesion.info == denuncia.info then " active" else "")),
                                        onClick (AdministracionMsg (SelectAdhesion denuncia))][
                                        h4 [class "list-group-item-heading"][text (toString denuncia.usuarioId)],
                                        p[class "list-group-item-text"][text denuncia.info]]) model.allItems.adhesiones,
                                    div [class "col-md-8"][
                                        div [][
                                            p [][text ("nombre: " ++ adhesion.usuarioId)],
                                            p [][text ("exposicion: " ++ adhesion.info)]
                                        ]
                                    ]
                                ],
                                div [class ("tab-pane" ++ tabColaboraciones)][
                                    div [class "list-group col-md-4"]
                                    <| List.map (\ item ->
                                    a [class ("list-group-item" ++ (if colaboracion.dni == item.dni then " active" else "")), 
                                        onClick (AdministracionMsg (SelectColaboracion item))][
                                        h4 [class "list-group-item-heading"][text <| item.nom ++ " " ++ item.cognoms],
                                        p[class "list-group-item-text"][text item.email]]) model.allItems.colaboraciones,
                                    div [class "col-md-8"][
                                        div [][
                                            p [][text ("nom: " ++ colaboracion.nom)],
                                            p [][text ("cognoms: " ++ colaboracion.cognoms)],
                                            p [][text ("email: " ++ colaboracion.email)],
                                            p [][text ("dni: " ++ colaboracion.dni)],
                                            p [][text ("localitat: " ++ colaboracion.localitat)],
                                            p [][text ("població: " ++ colaboracion.poblacio)]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                        ,                        
                        hr [][],
                        button [class "btn btn-default", onClick (UpdateRoute Login)][text "Login"]
                        ]