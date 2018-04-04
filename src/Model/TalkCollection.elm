module Model.TalkCollection exposing (..)
import Ports exposing (requestPostTalk, PostTalkDto)
import Types.Talk exposing (Talk)
import Types.User exposing (User)

type alias PostForm = {
    talkText: String
    }

initialPostForm: PostForm
initialPostForm = PostForm ""

updateTalkText: String -> PostForm -> PostForm
updateTalkText text form = { talkText = text }

type alias Resource = {
        talks: List Talk
    }

type alias Model = {
    talks: List Talk
    , postForm: PostForm
  }

fillResource : Resource -> Maybe Model -> model
fillResource resource maybeModel = case maybeModel of
    Just model -> { model | talks = resource.talks }
    Nothing -> Model resource.talks initialPostForm

--type PageModel = Loading | Loaded Model

--initialModel: Model
--initialModel = Model [] initialPostForm

--initialPageModel: PageModel
--initialPageModel = Loading

type Msg = UpdatePostTalkText String | PostTalk User

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    UpdatePostTalkText text -> { model | postForm = model.postForm |> updateTalkText text } ! []
    PostTalk user -> model ! [ requestPostTalk <| createPostTalkDto user model.postForm ]

createPostTalkDto: User -> PostForm -> PostTalkDto
createPostTalkDto user postForm = { text = postForm.talkText, userId = Types.User.idString user.id }

--updatePageModel : Msg -> PageModel -> (PageModel, Cmd Msg)
--updatePageModel msg pageModel = Tuple.mapFirst Loaded <| case pageModel of
--    Loading -> update msg initialModel
--    Loaded model -> update msg model