module Types.Page exposing (..)

type Page model resource = Viewable model | Loading

fillResource : Page model resource -> resource -> (resource -> Maybe model -> model) -> Page model resource
fillResource page resource modelFillResource = case page of
    Loading -> modelFillResource resource Nothing |> Viewable
    Viewable model -> modelFillResource resource (Just model) |> Viewable

requestResource: Page model resource -> Cmd msg -> (Page model resource, Cmd msg)
requestResource page cmd = (toggleLoading page, cmd)

isViewable: Page m r -> Bool
isViewable page = case page of
    Loading -> False
    Viewable _ -> True

isLoading: Page m r -> Bool
isLoading = isViewable >> not

toggleLoading : Page m r -> Page m r
toggleLoading page = identity Loading

updateModel: (subMsg -> model -> (model, Cmd subMsg)) -> subMsg -> Page model resource -> (Page model resource, Cmd subMsg)
updateModel update subMsg page = case page of
    Loading -> (page, Cmd.none)
    Viewable model -> update subMsg model |> Tuple.mapFirst Viewable