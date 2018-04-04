module Types.Page exposing (..)


type Page model resource
    = Viewable model
    | Loading

type alias FillResourceArg model resource = {
        page: Page model resource
        , resource : resource
        , fill: (resource -> Maybe model -> model)
    }

fillResource_ : FillResourceArg model resource -> Page model resource
fillResource_ arg = fillResource arg.page arg.resource arg.fill

fillResource : Page model resource -> resource -> (resource -> Maybe model -> model) -> Page model resource
fillResource page resource modelFillResource =
    case page of
        Loading ->
            modelFillResource resource Nothing |> Viewable

        Viewable model ->
            modelFillResource resource (Just model) |> Viewable


requestResource : Page model resource -> Cmd msg -> ( Page model resource, Cmd msg )
requestResource page cmd =
    ( toggleLoading page, cmd )


isViewable : Page m r -> Bool
isViewable page =
    case page of
        Loading ->
            False

        Viewable _ ->
            True


isLoading : Page m r -> Bool
isLoading =
    isViewable >> not


toggleLoading : Page m r -> Page m r
toggleLoading page =
    identity Loading

type alias UpdateModelArg msg model resource = {
        update: (msg -> model -> (model, Cmd msg))
        , msg: msg
        , page: Page model resource
    }

updateModel : (msg -> model -> ( model, Cmd msg )) -> msg -> Page model resource -> ( Page model resource, Cmd msg )
updateModel update msg page =
    case page of
        Loading ->
            ( page, Cmd.none )

        Viewable model ->
            update msg model |> Tuple.mapFirst Viewable

updateModel_ : UpdateModelArg msg model resource -> (Page model resource, Cmd msg)
updateModel_ arg = updateModel arg.update arg.msg arg.page