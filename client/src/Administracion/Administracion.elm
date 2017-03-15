module Administracion exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)
import Models exposing (..)
import Http exposing (..)
import Json.Decode as Json

administracionUpdate : AdministracionMsg -> Model -> (Model, Cmd Msg)
administracionUpdate msg model =
    case msg of 
        GetInfo (Ok info)->
            let
                allItems = model.allItems
            in
            ({ model | allItems = { allItems | denuncias = info} }, getadhesionManifiesto)
        GetInfo (Err error) ->
            ({model | error = Just (toString error)}, Cmd.none)
        GetadhesionManifiesto (Ok adhesiones) ->
            let
                allItems = model.allItems
            in
            ({ model | allItems = { allItems | adhesiones = adhesiones} }, getColaboracion)
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


getDenuncias: Cmd Msg
getDenuncias = Http.send (\a -> AdministracionMsg (GetInfo a)) 
  <| Http.get "http://localhost:3000/denuncias" 
  <| Json.list denunciaDecoder

getadhesionManifiesto: Cmd Msg
getadhesionManifiesto = Http.send (\a -> AdministracionMsg (GetadhesionManifiesto a)) 
  <| Http.get "http://localhost:3000/adhesionManifiesto" 
  <| Json.list adhesionManifiestoDecoder

getColaboracion: Cmd Msg
getColaboracion = Http.send (\a -> AdministracionMsg (GetColaboracion a)) 
  <| Http.get "http://localhost:3000/colaboracion" 
  <| Json.list colaboracionDecoder

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
                                Nothing -> {usuarioId = "", info = ""}
                                Just cola -> {usuarioId = (toString cola.usuarioId), info = cola.info}

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
                                    <| List.map (\ denuncia ->
                                    a [class ("list-group-item" ++ (if colaboracion.info == denuncia.info then " active" else "")), 
                                        onClick (AdministracionMsg (SelectColaboracion denuncia))][
                                        h4 [class "list-group-item-heading"][text (toString denuncia.usuarioId)],
                                        p[class "list-group-item-text"][text denuncia.info]]) model.allItems.colaboraciones,
                                    div [class "col-md-8"][
                                        div [][
                                            p [][text ("nombre: " ++ colaboracion.usuarioId)],
                                            p [][text ("exposicion: " ++ colaboracion.info)]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                        ,                        
                        hr [][],
                        button [class "btn btn-default", onClick (UpdateRoute Login)][text "Login"]
                        ]