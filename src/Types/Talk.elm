module Types.Talk exposing (..)

import Date exposing (Date)
import Types.User exposing (User)


type Id
    = TalkId String


idString : Id -> String
idString (TalkId str) =
    str


type alias Talk =
    { id : Id
    , text : String
    , createdAt : Date
    , user : User
    }
