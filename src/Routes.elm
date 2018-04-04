module Routes exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (..)

type Route = TalkCollection | NotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map TalkCollection top
        ]


toUrlStr : Route -> String
toUrlStr route =
    case route of
        TalkCollection ->
            "/"

        _ ->
            "notfound"


toHashUrl : Route -> String
toHashUrl =
    toUrlStr >> (++) "#"


fromLocation : Location -> Route
fromLocation location =
    case parseHash matchers location of
        Just route ->
            route

        Nothing ->
            NotFound