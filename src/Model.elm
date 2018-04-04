module Model exposing (..)

import Model.TalkCollection as TalkCollection
import Types.Page as Page exposing (Page)
import Types.User as User exposing (User)
import Routes


type alias TalkCollectionPage =
    Page TalkCollection.Model TalkCollection.Resource


type alias Model =
    { talkCollectionPage : TalkCollectionPage
    , loginUser : User
    , currentRoute: Routes.Route
    }


updateTalkCollectionPage : TalkCollectionPage -> Model -> Model
updateTalkCollectionPage page model =
    { model | talkCollectionPage = page }


initialModel : User -> Routes.Route -> Model
initialModel user route =
    { loginUser = user
    , talkCollectionPage = Page.Loading
    , currentRoute = route
    }


type Msg
    = Logout
    | TalkCollectionMsg TalkCollection.Msg
    | ReceiveTalkCollectionResource TalkCollection.Resource
    | SetRoute Routes.Route

setRoute : Routes.Route -> Model -> (Model, Cmd msg)
setRoute route model = { model | currentRoute = route } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            model ! []

        SetRoute route ->
            setRoute route model

        TalkCollectionMsg subMsg ->
            Page.updateModel_ { update = TalkCollection.update, msg = subMsg, page = model.talkCollectionPage }
                |> mapCmdTuple ( flip updateTalkCollectionPage <| model, TalkCollectionMsg )

        ReceiveTalkCollectionResource resource ->
            { model | talkCollectionPage = Page.fillResource_ { page = model.talkCollectionPage, resource = resource, fill = TalkCollection.fillResource }} ! []


mapCmdTuple : ( a -> c, b -> d ) -> ( a, Cmd b ) -> ( c, Cmd d )
mapCmdTuple ( aToc, bTod ) =
    (Tuple.mapFirst (aToc) >> Tuple.mapSecond (Cmd.map bTod))
