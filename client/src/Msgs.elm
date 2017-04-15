module Msgs exposing (..)
import Routing exposing (..)
import Http exposing (Error)
import Models exposing (..)

type Msg = LoginMsg LoginMsgActions
    | RegisterMsg RegisterMsgActions
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

type RegisterMsgActions = UpdateRegisterEmail String
    | UpdateRegisterPsw String
    | UpdateRegisterPsw2 String
    | SubmitRegister Register
    | GetRegister (Result Http.Error String)

type AdministracionMsg = 
    GetInfo (Result Http.Error (List Denuncia))
    | GetadhesionManifiesto (Result Http.Error (List AdhesionManifiesto))
    | GetColaboracion (Result Http.Error (List Colaboracion))
    | SelectDenuncia Denuncia
    | SelectAdhesion AdhesionManifiesto
    | SelectColaboracion Colaboracion
    | ChangeTab TabSelection

type EnviarColaboracionActions = 
    UpdateColaboracionNom String
    | UpdateColaboracionCognoms String
--    | UpdateColaboracionEmail String
    | UpdateColaboracionDni String
    | UpdateColaboracionLocalitat String
    | UpdateColaboracionPoblacio String
    | PostColaboracion Colaboracion
    | PostColaboracionResponse (Result Http.Error Colaboracion)