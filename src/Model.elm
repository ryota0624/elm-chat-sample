module Model exposing (..)

import Model.TalkCollection as TalkCollection
import Types.Page as Page exposing (Page)
import Types.User exposing (User)

type alias TalkCollectionPage = Page TalkCollection.Model TalkCollection.Resource

type alias Model = {
    talkCollectionPage: TalkCollectionPage
    , loginUser: User
  }

type PageModel = Login Model | Guest

updateTalkCollectionPage : TalkCollectionPage -> Model -> Model
updateTalkCollectionPage page model = { model | talkCollectionPage = page }

initialModel: User -> Model
initialModel user = {
        loginUser = user
        , talkCollectionPage = Page.Loading
    }

type MsgInLogin = Logout | TalkCollectionMsg TalkCollection.Msg
type MsgInGuest = LoginUser User

type Msg = InLogin MsgInLogin | InGuest MsgInGuest


updatePageModel : Msg -> PageModel -> (PageModel, Cmd Msg)
updatePageModel msg page = case (msg, page) of
    ((InLogin subMsg), (Login model)) -> update subMsg model |> mapCmdTuple (Login , InLogin)
    ((InGuest (LoginUser user)), (Guest)) ->
        Login (initialModel user) ! []
    _ -> Debug.crash ("invalid patten msg & model" ++ "|" ++ toString msg ++ "," ++ toString page)



update : MsgInLogin -> Model -> (Model, Cmd MsgInLogin)
update msg model = case msg of
    _ -> model ! []
--    TalkCollectionMsg subMsg ->
--        Page.updateModel TalkCollection.update subMsg model.talkCollectionPage
--           |>  mapCmdTuple (flip updateTalkCollectionPage <| model, TalkCollectionMsg)
--

mapCmdTuple: (a -> c, b -> d) -> (a, Cmd b) -> (c, Cmd d)
mapCmdTuple (aToc, bTod) = (Tuple.mapFirst (aToc) >> Tuple.mapSecond (Cmd.map bTod))