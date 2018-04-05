port module Ports exposing (..)

import Date exposing (Date)
import Time exposing (Time)
import Types.Talk exposing (Talk)


port requestTalkCollectionResource : () -> Cmd msg

port requestTalkDetailResource : (String) -> Cmd msg


type alias TalkPortDto =
    { userId : Int
    , userName : String
    , userIconImageUrl : String
    , text : String
    , talkId : Int
    , createdAt : Time
    }


type alias PortTaskResult d =
    { errors : List String
    , data : Maybe d
    }


toResult : PortTaskResult d -> Result (List String) d
toResult { data, errors } =
    case data of
        Just d ->
            Result.Ok d

        Nothing ->
            Result.Err errors


port receiveTalkCollectionResource : (List TalkPortDto -> msg) -> Sub msg

type alias TalkDetailResourceDto = {
        talk: TalkPortDto,
        comments: List String
    }

port receiveTalkDetailResource: (TalkDetailResourceDto -> msg) -> Sub msg

port receivePostedTalk : (PortTaskResult TalkPortDto -> msg) -> Sub msg


type alias LoginUserPortDto =
    { userId : Int
    , name : String
    , iconImageUrl : String
    }


port receiveLoginUser : (LoginUserPortDto -> msg) -> Sub msg


type alias PostTalkDto =
    { text : String
    , userId : String
    }


port requestPostTalk : PostTalkDto -> Cmd msg
