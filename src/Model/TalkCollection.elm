module Model.TalkCollection exposing (..)

import Ports exposing (requestPostTalk, PostTalkDto)
import Types.Talk exposing (Talk)
import Types.User exposing (User)


type alias PostForm =
    { talkText : String
    }

isValidPortForm: PostForm -> Bool
isValidPortForm form = (form.talkText |> String.length) > 0

initialPostForm : PostForm
initialPostForm =
    PostForm ""


updateTalkText : String -> PostForm -> PostForm
updateTalkText text form =
    { talkText = text }


type alias Resource =
    { talks : List Talk
    }


type alias Model =
    { talks : List Talk
    , postForm : PostForm
    , runningPostTalk: Bool
    }


fillResource : Resource -> Maybe Model -> Model
fillResource resource maybeModel =
    case maybeModel of
        Just model ->
            { model | talks = resource.talks }

        Nothing ->
            Model resource.talks initialPostForm False


type Msg
    = UpdatePostTalkText String
    | PostTalk User
    | FinishPostTalk (Result (List String) Talk)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatePostTalkText text ->
            { model | postForm = model.postForm |> updateTalkText text } ! []

        PostTalk user ->
            { model | runningPostTalk = True } ! [ requestPostTalk <| createPostTalkDto user model.postForm ]

        FinishPostTalk resultTalk ->
            case resultTalk of
                Result.Ok talk -> { model | runningPostTalk = False, talks = model.talks ++ [talk] } ! []
                Result.Err _ -> { model | runningPostTalk = False } ! []


createPostTalkDto : User -> PostForm -> PostTalkDto
createPostTalkDto user postForm =
    { text = postForm.talkText, userId = Types.User.idString user.id }
