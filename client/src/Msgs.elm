module Msgs exposing (..)
import Routing exposing (..)
import Http exposing (Error)
import Models exposing (..)

type Msg = LoginMsg LoginMsgActions
--    | RegistroMsg
--    | IndexMsg
    | EnviarColaboracionMsg EnviarColaboracionActions
--    | EnviarDenunciaMsg
--    | AdherirManifiestoMsg
    | AdministracionMsg AdministracionMsg
    | UpdateRoute Routing

type LoginMsgActions = UpdateLoginEmail String
    | UpdateLoginPsw String
    | SubmitLogin LoginUser
    | GetLogin (Result Http.Error String)

type AdministracionMsg = 
    GetInfo (Result Http.Error (List Denuncia))
    | GetadhesionManifiesto (Result Http.Error (List AdhesionManifiesto))
    | GetColaboracion (Result Http.Error (List Colaboracion))
    | SelectDenuncia Denuncia
    | SelectAdhesion AdhesionManifiesto
    | SelectColaboracion Colaboracion
    | ChangeTab TabSelection

type EnviarColaboracionActions = 
    UpdateColaboracion String
    | PostColaboracion (Maybe Colaboracion)
    | PostColaboracionResponse (Result Http.Error Colaboracion)