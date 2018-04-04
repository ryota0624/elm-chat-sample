module Main exposing (..)

import Date
import Html exposing (Html, button, div, img, program, text, textarea)
import Html.Attributes exposing (src, value)
import Ports exposing (LoginUserPortDto, TalkPortDto, receiveLoginUser, receiveTalkCollectionResource, requestTalkCollectionResource)
import Styles
import Types.Talk as Talk exposing (Talk)
import Types.User as User exposing (User)
import View exposing (view)
import Model exposing (Msg, update, initialModel, Model)
import Model.TalkCollection as TalkCollection
import Json.Decode as Decode
import Navigation exposing (Location)
import Routes

talkDtoToModel : TalkPortDto -> Talk
talkDtoToModel dto =
    let
        user =
            { id = User.UserId <| toString <| dto.userId
            , name = dto.userName
            , iconImageUrl = dto.userIconImageUrl
            }
    in
        { user = user
        , id = Talk.TalkId <| toString <| dto.talkId
        , text = dto.text
        , createdAt = Date.fromTime <| dto.createdAt
        }


loginUserDtoToModel : LoginUserPortDto -> User
loginUserDtoToModel dto =
    { id = User.UserId <| toString <| dto.userId
    , name = dto.name
    , iconImageUrl = dto.iconImageUrl
    }


subscriptions : Model.Model -> Sub Msg
subscriptions model =
    receiveTalkCollectionResource
        (List.map
            talkDtoToModel
            >> TalkCollection.Resource
            >> Model.ReceiveTalkCollectionResource
        )


main : Program Decode.Value Model Msg
main =
    Navigation.programWithFlags (Routes.fromLocation >> Model.SetRoute)
        { init = init
        , view = view
        , update = Model.update
        , subscriptions = subscriptions
        }


init : Decode.Value -> Location -> ( Model, Cmd Msg )
init jsValue location =
    Model.initialModel { id = User.UserId "100", name = "SUZUKI", iconImageUrl = "https://grapee.jp/wp-content/uploads/32187_main2.jpg" } (Routes.fromLocation location) ! []
