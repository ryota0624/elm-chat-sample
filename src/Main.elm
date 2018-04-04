module Main exposing (..)

import Date
import Html exposing (Html, button, div, img, program, text, textarea)
import Html.Attributes exposing (src, value)
import Ports exposing (LoginUserPortDto, TalkPortDto, receiveLoginUser, receiveTalkCollectionResource, requestTalkCollectionResource)
import Styles
import Types.Talk exposing (Talk)
import Types.User exposing (User)
import View exposing (view)
import Model exposing (Msg, update, initialModel, Model)
import Model.TalkCollection as TalkCollection

talkDtoToModel: TalkPortDto -> Talk
talkDtoToModel dto =
    let
        user = {
            id = Types.User.UserId <| toString <| dto.userId
            , name = dto.userName
            , iconImageUrl = dto.userIconImageUrl
            }
    in
        {
                        user = user
                        , id = Types.Talk.TalkId <| toString <| dto.talkId
                        , text = dto.text
                        , createdAt = Date.fromTime <| dto.createdAt
                    }

loginUserDtoToModel: LoginUserPortDto -> User
loginUserDtoToModel dto = {
        id = Types.User.UserId <| toString <| dto.userId
        , name = dto.name
        , iconImageUrl = dto.iconImageUrl
    }

loginSubscriptions: Model.Model -> Sub Msg
loginSubscriptions model = receiveTalkCollectionResource (List.map
                            talkDtoToModel >>
                            TalkCollection.ReceiveResources >>
                            Model.TalkCollectionMsg >>
                            Model.InLogin)

subscriptions: Model.PageModel -> Sub Msg
subscriptions page = case page of
    Model.Login model -> loginSubscriptions model
    Model.Guest -> receiveLoginUser (loginUserDtoToModel >> Model.LoginUser >> Model.InGuest)


main : Program Never Model.PageModel Msg
main =
    program
        { init = init
        , view = view
        , update = Model.updatePageModel
        , subscriptions = subscriptions
        }


init : ( Model.PageModel, Cmd Msg )
init =
    Model.Guest ! []


