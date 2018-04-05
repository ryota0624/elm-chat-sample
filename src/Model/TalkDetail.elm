module Model.TalkDetail exposing (..)

import Types.Page as Page
import Types.Talk exposing (Talk)

type alias Resource = {
        talk: Talk
        , comments: List String
    }

type alias InnerModel = {
        talk: Talk
        , comments: List String
        , errors : List String
    }

type alias Model =
    Page.Model InnerModel

fillResource : Resource -> Maybe (Page.Model InnerModel) -> Model
fillResource { comments, talk } maybeModel =
    case maybeModel of
        Just model ->
            { model | talk = talk , comments = comments }
        Nothing ->
            { talk = talk, comments = comments, errors = [] }

type Msg = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp -> model ! []