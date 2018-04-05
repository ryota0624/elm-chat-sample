module Model exposing (..)

import Model.TalkCollection as TalkCollection
import Model.TalkDetail as TalkDetail

import Ports exposing (requestTalkCollectionResource, requestTalkDetailResource)
import Types.Page as Page exposing (Page)
import Types.User as User exposing (User)
import Types.Talk as Talk exposing (Talk)

import Routes


type alias TalkCollectionPage =
    Page TalkCollection.Model TalkCollection.Resource

type alias TalkDetailPage =
    Page TalkDetail.Model TalkDetail.Resource

type CurrentPage
    = InTalkCollectionPage TalkCollectionPage
    | InTalkDetailPage TalkDetailPage


isLoading : CurrentPage -> Bool
isLoading currentPage =
    case currentPage of
        InTalkCollectionPage page ->
            Page.isLoading page
        InTalkDetailPage page ->
            Page.isLoading page


appendErrors : List String -> CurrentPage -> CurrentPage
appendErrors errors currentPage =
    case currentPage of
        InTalkCollectionPage page ->
            Page.appendErrors errors page |> InTalkCollectionPage
        InTalkDetailPage page ->
            Page.appendErrors errors page |> InTalkDetailPage


type alias Model =
    { loginUser : User
    , currentRoute : Routes.Route
    , currentPage : CurrentPage
    }


updateTalkCollectionPage : TalkCollectionPage -> Model -> Model
updateTalkCollectionPage page model =
    { model | currentPage = InTalkCollectionPage page }

updateTalkDetailPage : TalkDetailPage -> Model -> Model
updateTalkDetailPage page model =
    { model | currentPage = InTalkDetailPage page }

routeToPage: Routes.Route -> CurrentPage
routeToPage route = case route of
    Routes.TalkDetail id -> InTalkDetailPage Page.loading
    Routes.TalkCollection -> InTalkCollectionPage Page.loading
    Routes.NotFound -> InTalkCollectionPage Page.loading

initialize : User -> Routes.Route -> (Model, Cmd Msg)
initialize user route =
    { loginUser = user
    , currentRoute = route
    , currentPage = routeToPage route
    } |> setRoute route


type Msg
    = Logout
    | TalkCollectionMsg TalkCollection.Msg
    | TalkDetailMsg TalkDetail.Msg
    | ReceiveTalkCollectionResource TalkCollection.Resource
    | ReceiveTalkDetailResource TalkDetail.Resource
    | SetRoute Routes.Route
    | ReceiveErrors (List String)

setPrevPage: Model -> Model
setPrevPage model = { prevPage = model.currentPage }

setRoute : Routes.Route -> Model -> ( Model, Cmd msg )
setRoute route model =
    let
        updatedRouteModel =
            { model | currentRoute = route }

        a = Debug.log "" route
    in
        case route of
            Routes.TalkCollection ->
                { updatedRouteModel | currentPage = InTalkCollectionPage Page.loading } ! [ requestTalkCollectionResource () ]


            Routes.TalkDetail (Talk.TalkId id) ->
                { updatedRouteModel | currentPage = InTalkDetailPage Page.loading  } ! [ requestTalkDetailResource id ]

            Routes.NotFound ->
                updatedRouteModel ! []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.currentPage ) of
        ( Logout, _ ) ->
            model ! []

        ( SetRoute route, _ ) ->
            model |> (setPrevPage >> (setRoute route))

        ( TalkCollectionMsg subMsg, InTalkCollectionPage page ) ->
            Page.updateModel_ { update = TalkCollection.update, msg = subMsg, page = page }
                |> mapCmdTuple ( flip updateTalkCollectionPage <| model, TalkCollectionMsg )

        ( TalkDetailMsg subMsg, InTalkDetailPage page ) ->
            Page.updateModel_ { update = TalkDetail.update, msg = subMsg, page = page }
                |> mapCmdTuple ( flip updateTalkDetailPage <| model, TalkDetailMsg )

        ( ReceiveTalkCollectionResource resource, InTalkCollectionPage page ) ->
            { model | currentPage = InTalkCollectionPage <| Page.fillResource_ { page = page, resource = resource, fill = TalkCollection.fillResource } } ! []

        ( ReceiveTalkDetailResource resource, InTalkDetailPage page) ->
             { model | currentPage = InTalkDetailPage <| Page.fillResource_ { page = page, resource = resource, fill = TalkDetail.fillResource } } ! []

        ( ReceiveErrors errors, currentPage ) ->
            { model | currentPage = appendErrors errors currentPage } ! []

        _ ->
            let
                errorMsg = "Model.update No expected Pattern msg & model:" ++ ((toString model.currentPage) ++ "&" ++ (toString msg))
                logging = Debug.log "Model.update No expected Pattern msg & model:" ((toString model.currentPage) ++ "&" ++ (toString msg))
            in
                Debug.crash errorMsg


mapCmdTuple : ( a -> c, b -> d ) -> ( a, Cmd b ) -> ( c, Cmd d )
mapCmdTuple ( aToc, bTod ) =
    Tuple.mapFirst aToc >> Tuple.mapSecond (Cmd.map bTod)
