module Types.Page exposing (..)


type alias Model model =
    { model | errors : List String }


type Page model resource
    = Viewable (Model model)
    | Loading (Model {})


loading : Page m r
loading =
    Loading { errors = [] }


getErrors : Page m r -> List String
getErrors page =
    case page of
        Viewable { errors } ->
            errors

        Loading { errors } ->
            errors


getModel : Page m r -> Maybe (Model m)
getModel page =
    case page of
        Viewable model ->
            Just model

        Loading _ ->
            Nothing


appendErrors : List String -> Page m r -> Page m r
appendErrors errors page =
    case page of
        Viewable page ->
            { page | errors = errors } |> Viewable

        Loading page ->
            { page | errors = errors } |> Loading


type alias FillResourceArg model resource =
    { page : Page model resource
    , resource : resource
    , fill : resource -> Maybe (Model model) -> Model model
    }


fillResource_ : FillResourceArg model resource -> Page model resource
fillResource_ arg =
    fillResource arg.page arg.resource arg.fill


fillResource : Page model resource -> resource -> (resource -> Maybe (Model model) -> Model model) -> Page model resource
fillResource page resource modelFillResource =
    case page of
        Loading _ ->
            modelFillResource resource Nothing |> Viewable

        Viewable model ->
            modelFillResource resource (Just model) |> Viewable


requestResource : Page model resource -> Cmd msg -> ( Page model resource, Cmd msg )
requestResource page cmd =
    ( toggleLoading page, cmd )


isViewable : Page m r -> Bool
isViewable page =
    case page of
        Loading _ ->
            False

        Viewable _ ->
            True


isLoading : Page m r -> Bool
isLoading =
    isViewable >> not


toggleLoading : Page m r -> Page m r
toggleLoading page =
    identity Loading { errors = [] }


type alias UpdateModelArg msg model resource =
    { update : msg -> Model model -> ( Model model, Cmd msg )
    , msg : msg
    , page : Page model resource
    }


updateModel : (msg -> Model model -> ( Model model, Cmd msg )) -> msg -> Page model resource -> ( Page model resource, Cmd msg )
updateModel update msg page =
    case page of
        Loading _ ->
            ( page, Cmd.none )

        Viewable model ->
            update msg model |> Tuple.mapFirst Viewable


updateModel_ : UpdateModelArg msg model resource -> ( Page model resource, Cmd msg )
updateModel_ arg =
    updateModel arg.update arg.msg arg.page
