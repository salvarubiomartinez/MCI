module Models exposing (..)

import Routing exposing (Routing(..))
import Json.Decode as Json

--Model
type alias LoginUser = {email: String, psw : String}
type alias Usuario = {id : Int, nombre : String, dni :String}
type alias Denuncia = {id: Int, usuarioId : Int, fecha : String, nombre: String, exposicion : String} --, comentarios : List Comentario}
--type alias Comentario = {autor: String, hora : String, contenido : String}
type alias AdhesionManifiesto = {id: Int, usuarioId: Int, info : String}
type alias Colaboracion = {id: Int, usuarioId: Int, info : String}
type TabSelection = TabDenuncias | TabAdhesiones | TabColaboraciones

type alias Model = {usuario: Maybe Usuario,
                    login: LoginUser,
                    route: Routing,
                    allItems : {denuncias: List Denuncia, adhesiones: List AdhesionManifiesto, colaboraciones: List Colaboracion},
                    denuncia : Maybe Denuncia,
                    adhesion : Maybe AdhesionManifiesto,
                    colaboracion : Maybe Colaboracion,
                    selectedTab : TabSelection,
                    error : Maybe String}

--Decoders
usuarioDecoder: Json.Decoder Usuario
usuarioDecoder = Json.map3
  Usuario 
    (Json.field "id" Json.int)
    (Json.field "nombre" Json.string)
    (Json.field "dni" Json.string)

denunciaDecoder: Json.Decoder Denuncia
denunciaDecoder = Json.map5
  Denuncia
    (Json.field "id" Json.int)
    (Json.field "usuarioId" Json.int)
    (Json.field "fecha" Json.string)
    (Json.field "nombre" Json.string)
    (Json.field "exposicion" Json.string)
--   (Json.field "comentarios" (Json.list comentarioDecoder))

adhesionManifiestoDecoder : Json.Decoder AdhesionManifiesto
adhesionManifiestoDecoder = Json.map3
  AdhesionManifiesto
    (Json.field "id" Json.int)
    (Json.field "usuarioId" Json.int)
    (Json.field "info" Json.string)

colaboracionDecoder = Json.map3
  Colaboracion
    (Json.field "id" Json.int)
    (Json.field "usuarioId" Json.int)
    (Json.field "info" Json.string)

--comentarioDecoder: Json.Decoder Comentario
--comentarioDecoder = Json.map3
--    Comentario 
--        (Json.field "autor" Json.string)
--        (Json.field "hora" Json.string)
--        (Json.field "contenido" Json.string)