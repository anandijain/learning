module Competition exposing(Competition, decodeCompetition, encodeCompetition)

import Json.Encode as E
import Json.Decode as D
import Json.Decode.Pipeline exposing(required)

import Path exposing(Path, decodePath, encodePath)
import Event exposing(Event, decodeEvent, encodeEvent)

type alias Competition =
    { path : List Path.Path
    , events : List Event.Event
    }

decodeCompetition : D.Decoder Competition
decodeCompetition =
    D.succeed Competition
        |> required "path" (D.list decodePath)
        |> required "events" (D.list decodeEvent)

encodeCompetition : Competition -> E.Value
encodeCompetition record =
    E.object
        [ ("path",  E.list encodePath record.path)
        , ("events",  E.list encodeEvent record.events)
        ]