module Msgs exposing (..)
import Routing exposing (..)
import Http exposing (Error)
import Models exposing (..)

type Msg = LoginMsg LoginMsgActions
--    | RegistroMsg
--    | IndexMsg
--    | EnviarColaboracionMsg
--    | EnviarDenunciaMsg
--    | AdherirManifiestoMsg
    | AdministracionMsg AdministracionMsg
    | UpdateRoute Routing

type LoginMsgActions = UpdateLoginEmail String
    | UpdateLoginPsw String
    | SubmitLogin

type AdministracionMsg = 
    GetInfo (Result Http.Error (List Denuncia))