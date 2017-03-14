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
    | GetadhesionManifiesto (Result Http.Error (List AdhesionManifiesto))
    | GetColaboracion (Result Http.Error (List Colaboracion))
    | SelectDenuncia Denuncia
    | SelectAdhesion AdhesionManifiesto
    | SelectColaboracion Colaboracion
    | ChangeTab TabSelection