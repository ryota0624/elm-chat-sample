module View exposing (..)

import Date exposing (Date)
import Html exposing (Html, button, div, img, text, textarea)
import Html.Attributes exposing (src, value)
import Html.Events exposing (onInput, onClick)

import Styles
import Types.Talk exposing (Talk)
import Model exposing (Model, PageModel)
import Model.TalkCollection as TalkCollection
import Types.User exposing (User)

talkView: Talk -> Html msg
talkView talk = div [ Styles.talk ]
                            [ div [ Styles.talkLeft ]
                                [ img [ Styles.posterImg, src talk.user.iconImageUrl ] [] ]
                            , div [ Styles.talkRight ]
                                [ div [ Styles.posterName ] [ text talk.user.name ]
                                , div [ Styles.message ] [ text talk.text ]
                                , div [ Styles.talkFooter ]
                                    [ text <| dateToString talk.createdAt ]
                                ]
                            ]

dateToString: Date -> String
dateToString date = (date |> Date.year |> toString) ++ "/" ++ (date |> Date.month |> monthToInt |> toString) ++ "/" ++ (date |> Date.day |> toString) ++ " " ++ (date |> Date.hour |> toString) ++ ":" ++ (date |> Date.minute |> toString)

monthToInt: Date.Month -> Int
monthToInt month = case month of
    Date.Jan -> 1
    Date.Feb -> 2
    Date.Mar -> 3
    Date.Apr -> 4
    Date.May -> 5
    Date.Jun -> 6
    Date.Jul -> 7
    Date.Aug -> 8
    Date.Sep -> 9
    Date.Oct -> 10
    Date.Nov -> 11
    Date.Dec -> 12

view: PageModel -> Html Model.Msg
view page = case page of
    Model.Guest -> div [] [ text "welcome! please login"]
    Model.Login model ->
        div [] [
        loginUserView model
        , talkCollectionPageView model.loginUser model.talkCollectionPage
        ]

loginUserView: Model -> Html msg
loginUserView { loginUser } =
    div [] [ text <| "LOGIN USER: " ++ loginUser.name ]



talkCollectionPageView: User -> TalkCollection.PageModel -> Html Model.Msg
talkCollectionPageView user talkCollectionPage = div [ Styles.mainWrap ] (
        [postTalkForm user] ++
        talkViewList user talkCollectionPage
    )


talkViewList : User -> TalkCollection.PageModel -> List (Html msg)
talkViewList user talkCollectionPage = case talkCollectionPage of
    TalkCollection.Loaded model ->
        model.talks |> List.map talkView
    _ -> [
        text "now loading"
            ]

postTalkForm : User -> Html Model.Msg
postTalkForm user = div [ Styles.postForm ]
                           [ div [ Styles.formLeft ]
                               [ img [ Styles.selfImg, src user.iconImageUrl ] []
                               ]
                           , div [ Styles.formRight ]
                               [ textarea [ Styles.formArea, onInput (TalkCollection.UpdatePostTalkText >> Model.TalkCollectionMsg >> Model.InLogin) ] []
                               , button [ Styles.postButton, onClick (TalkCollection.PostTalk user |> Model.TalkCollectionMsg |> Model.InLogin) ] [ text "投稿！" ]
                               ]
                           ]

-- cf. 編集中はメッセージがtextarea表示になり、変更できるようになります


viewEditingTalk : Talk -> Html msg
viewEditingTalk { user, text, createdAt } =
    div [ Styles.talk ]
        [ div [ Styles.talkLeft ]
            [ img [ Styles.posterImg, src user.iconImageUrl ] [] ]
        , div [ Styles.talkRight ]
            [ div [ Styles.posterName ] [ Html.text user.name ]
            , textarea [ Styles.editingMessage, value text ] []
            , div [ Styles.talkFooter ]
                [ Html.text <| dateToString createdAt
                , div [ Styles.buttons ]
                    [ button [ Styles.editButton ] [ Html.text "完了" ]
                    , button [ Styles.deleteButton ] [ Html.text "削除" ]
                    ]
                ]
            ]
        ]