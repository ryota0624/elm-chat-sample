module Routes exposing (..)

import Navigation exposing (Location)
import Types.Talk as Talk
import UrlParser exposing (..)


type Route
    = TalkCollection
    | TalkDetail Talk.Id
    | NotFound

talkIdParser : Parser (Talk.Id -> a) a
talkIdParser =
    custom "TALK" (Ok << Talk.TalkId)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map TalkCollection top,
          map TalkDetail (s "talk" </> talkIdParser)
        ]


toUrlStr : Route -> String
toUrlStr route =
    case route of
        TalkCollection ->
            "/"

        TalkDetail id ->
            "/talk/" ++ (Talk.idString id)

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
