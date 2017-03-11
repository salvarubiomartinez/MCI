module Msgs exposing (..)

type Msg = LoginMsg LoginMsgNested
--   | RegistroMsg
--    | IndexMsg
--    | EnviarColaboracionMsg
--    | EnviarDenunciaMsg
--    | AdherirManifiestoMsg
--    | AdministracionMsg

type LoginMsgNested = UpdateLoginEmail String
    | UpdateLoginPsw String
    | SubmitLogin