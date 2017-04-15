module Index exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)

indexUpdate msg model=
    (model, Cmd.none)

indexView model = div [][
    h1 [][text "Welcome usuario"],
    div [][
        div [][
            a [class "btn btn-primary btn-lg",onClick (UpdateRoute Administracion)][text "Administración"]
        ],
        div [class "jumbotron"][
            h1[][text "Denuncias"],
            p [][text "Envianos una denuncia"],
            p [][
                a [class "btn btn-primary btn-lg",onClick (UpdateRoute EnviarDenuncia)][text "Adelante!"]
            ]
        ],
        div [class "jumbotron"][
            h1[][text "Subscripción al manifiesto"],
            p [][text "Danos tu apoyo en el manifiesto"],
            p [][
                a [class "btn btn-primary btn-lg",onClick (UpdateRoute AdherirManifiesto)][text "Adelante!"]
            ]
        ],
        div [class "jumbotron"][
            h1[][text "Colaboración"],
            p [][text "Somos una asociación que necesita colaboradores"],
            p [][
                a [class "btn btn-primary btn-lg",onClick (UpdateRoute EnviarColaboracion)][text "Adelante!"]
            ]
        ]
    ]
    ]