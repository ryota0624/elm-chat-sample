port module Ports exposing (..)

import Date exposing (Date)
import Time exposing (Time)
import Types.Talk exposing (Talk)


port requestTalkCollectionResource : () -> Cmd msg

type alias TalkPortDto = {
            userId: Int,
            userName: String,
            userIconImageUrl: String,
            text: String,
            talkId: Int,
            createdAt: Time
        }

port receiveTalkCollectionResource: (List TalkPortDto -> msg) -> Sub msg

type alias LoginUserPortDto = {
                  userId: Int
                , name: String
                , iconImageUrl: String
        }

port receiveLoginUser: (LoginUserPortDto -> msg) -> Sub msg

type alias PostTalkDto = {
        text: String,
        userId: String
    }

port requestPostTalk: PostTalkDto -> Cmd msg
