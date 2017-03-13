module Administracion exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)
import Models exposing (..)

administracionUpdate : AdministracionMsg -> Model -> (Model, Cmd Msg)
administracionUpdate msg model =
    case msg of 
        GetInfo (Ok info)->
            let
                allItems = model.allItems
            in
            ({ model | allItems = { allItems | denuncias = info} }, Cmd.none)
        GetInfo (Err error) ->
            ({model | error = Just (toString error)}, Cmd.none)

administracionView : Model -> Html Msg
administracionView model = div [][
                        h1 [][text "Tus denuncias"],
                        ul [class "nav nav-tabs"][
                            li [attribute "role" "presentation"][a [][text "Denuncias"]],
                            li [][a [][text "subscripciones"]],
                            li [][a [][text "colaboracion"]]
                        ],
                        div [class "tab-content"][
                            div [class "tab-pane"][
                                div [class "list-group"]
                            <| List.map (\ denuncia ->
                            a [class "list-group-item"][
                                h4 [class "list-group-item-heading"][text denuncia.nombre],
                                p[class "list-group-item-text"][text denuncia.fecha]]) model.allItems.denuncias
                            ],
                            div [class "tab-pane"][],
                            div [class "tab-pane"][]
                        ],
                        
                        button [class "btn btn-default", onClick (UpdateRoute Login)][text "Login"]
                        ]