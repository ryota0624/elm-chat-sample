module View exposing (..)

import Date exposing (Date)
import Html exposing (Html, button, div, img, text, textarea)
import Html.Attributes exposing (src, value, disabled)
import Html.Events exposing (onInput, onClick)
import Routes
import Styles
import Types.Page as Page
import Types.Talk exposing (Talk)
import Model exposing (Model)
import Model.TalkCollection as TalkCollection exposing (PostForm, isValidPortForm)
import Types.User exposing (User)


talkView : Talk -> Html msg
talkView talk =
    div [ Styles.talk ]
        [ div [ Styles.talkLeft ]
            [ img [ Styles.posterImg, src talk.user.iconImageUrl ] [] ]
        , div [ Styles.talkRight ]
            [ div [ Styles.posterName ] [ text talk.user.name ]
            , div [ Styles.message ] [ text talk.text ]
            , div [ Styles.talkFooter ]
                [ text <| dateToString talk.createdAt ]
            ]
        , Html.a [ Html.Attributes.href <| Routes.toHashUrl (Routes.TalkDetail talk.id)  ] [text "detail"]
        ]


dateToString : Date -> String
dateToString date =
    (date |> Date.year |> toString) ++ "/" ++ (date |> Date.month |> monthToInt |> toString) ++ "/" ++ (date |> Date.day |> toString) ++ " " ++ (date |> Date.hour |> toString) ++ ":" ++ (date |> Date.minute |> toString)


monthToInt : Date.Month -> Int
monthToInt month =
    case month of
        Date.Jan ->
            1

        Date.Feb ->
            2

        Date.Mar ->
            3

        Date.Apr ->
            4

        Date.May ->
            5

        Date.Jun ->
            6

        Date.Jul ->
            7

        Date.Aug ->
            8

        Date.Sep ->
            9

        Date.Oct ->
            10

        Date.Nov ->
            11

        Date.Dec ->
            12


view : Model -> Html Model.Msg
view model =
    div []
        [ loginUserView model
        , case model.currentPage of
            Model.InTalkCollectionPage page ->
                viewFrame model page (talkCollectionPageView model.loginUser)

            Model.InTalkDetailPage page ->
                viewFrame model page (toString >> \str -> div [] [ Html.a [Html.Attributes.href <| Routes.toHashUrl Routes.TalkCollection ] [ text str ]])
        ]

viewFrame : Model -> Page.Page m r -> (Page.Model m -> Html Model.Msg) -> Html Model.Msg
viewFrame model page modelView = case page of
    Page.Loading errors ->
        div [] [
        viewLoading
        ]
    Page.Viewable model ->
        div [] [
        viewErrors model.errors,
        modelView model
        ]

viewErrors : List String -> Html msg
viewErrors errors = div [] (errors |> List.map text)

viewLoading : Html msg
viewLoading = text "Loading"

loginUserView : Model -> Html msg
loginUserView { loginUser } =
    div [] [ text <| "LOGIN USER: " ++ loginUser.name ]


talkCollectionPageView : User -> TalkCollection.Model -> Html Model.Msg
talkCollectionPageView user talkCollectionPage =
    div [ Styles.mainWrap ]
        ([ postTalkForm user talkCollectionPage.postForm ]
            ++ talkViewList user talkCollectionPage
        )


talkViewList : User -> TalkCollection.Model -> List (Html msg)
talkViewList user model =
    model.talks |> List.map talkView


postTalkForm : User -> PostForm -> Html Model.Msg
postTalkForm user postForm =
    div [ Styles.postForm ]
        [ div [ Styles.formLeft ]
            [ img [ Styles.selfImg, src user.iconImageUrl ] []
            ]
        , div [ Styles.formRight ]
            [ textarea [ Styles.formArea, onInput (TalkCollection.UpdatePostTalkText >> Model.TalkCollectionMsg) ] []
            , button [ Styles.postButton, onClick (TalkCollection.PostTalk user |> Model.TalkCollectionMsg), disabled <| not <| isValidPortForm postForm ] [ text "投稿！" ]
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
