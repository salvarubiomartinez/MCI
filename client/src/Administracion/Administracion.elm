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


--getDenuncias: Cmd Msg
getDenuncias = Http.send (\a -> AdministracionMsg (GetInfo a)) 
  <| Http.get "http://localhost:3000/denuncias" 
  <| Json.list denunciaDecoder


getadhesionManifiesto = Http.send (\a -> AdministracionMsg (GetadhesionManifiesto a)) 
  <| Http.get "http://localhost:3000/adhesionManifiesto" 
  <| Json.list adhesionManifiestoDecoder

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
                                Just adhe -> {usuarioId = (toString adhe.usuarioId), info = adhe.info}
                    tabDenuncias = if model.selectedTab == TabDenuncias then "tab-pane active" else "tab-pane"
                    tabAdhesiones = if model.selectedTab == TabAdhesiones then "tab-pane active" else "tab-pane"
                    tabColaboraciones = if model.selectedTab == TabColaboraciones then "tab-pane active" else "tab-pane"
                in
                    div [][
                        h1 [][text "Tus denuncias"],
                        ul [class "nav nav-tabs"][
                            li [attribute "role" "presentation"][
                                a [onClick (AdministracionMsg (ChangeTab TabDenuncias))][text "Denuncias"]
                            ],
                            li [][
                                a [ onClick (AdministracionMsg (ChangeTab TabAdhesiones))][text "subscripciones"]
                            ],
                            li [][
                                a [onClick (AdministracionMsg (ChangeTab TabColaboraciones))][text "colaboracion"]
                            ]
                        ],
                        div [class "tab-content"][
                            div [class tabDenuncias][
                                div [class "list-group col-md-4"]
                                <| List.map (\ denuncia ->
                                a [class "list-group-item", onClick (AdministracionMsg (SelectDenuncia denuncia))][
                                    h4 [class "list-group-item-heading"][text denuncia.nombre],
                                    p[class "list-group-item-text"][text denuncia.fecha]]) model.allItems.denuncias,
                                div [class "col-md-8"][
                                    div [][
                                        p [][text ("nombre: " ++ denuncia.nombre)],
                                        p [][text ("exposicion: " ++ denuncia.exposicion)]
                                    ]
                                ]
                            ],
                            div [class tabAdhesiones][
                                div [class "list-group col-md-4"]
                                <| List.map (\ denuncia ->
                                a [class "list-group-item", onClick (AdministracionMsg (SelectAdhesion denuncia))][
                                    h4 [class "list-group-item-heading"][text (toString denuncia.usuarioId)],
                                    p[class "list-group-item-text"][text denuncia.info]]) model.allItems.adhesiones,
                                div [class "col-md-8"][
                                    div [][
                                        p [][text ("nombre: " ++ adhesion.usuarioId)],
                                        p [][text ("exposicion: " ++ adhesion.info)]
                                    ]
                                ]
                            ],
                            div [class tabColaboraciones][
                                div [class "list-group col-md-4"]
                                <| List.map (\ denuncia ->
                                a [class "list-group-item", onClick (AdministracionMsg (SelectColaboracion denuncia))][
                                    h4 [class "list-group-item-heading"][text (toString denuncia.usuarioId)],
                                    p[class "list-group-item-text"][text denuncia.info]]) model.allItems.colaboraciones,
                                div [class "col-md-8"][
                                    div [][
                                        p [][text ("nombre: " ++ colaboracion.usuarioId)],
                                        p [][text ("exposicion: " ++ colaboracion.info)]
                                    ]
                                ]
                            ]
                        ],                        
                        hr [][],
                        button [class "btn btn-default", onClick (UpdateRoute Login)][text "Login"]
                        ]