module Login exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (..)
import Routing exposing (..)

indexUpdate msg model=
    (model, Cmd.none)

indexView model = div [][
    h1 [][text "Welcome"]
]