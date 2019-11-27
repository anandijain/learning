module Competition exposing(Competition, decodeCompetition, encodeCompetition)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

import Path exposing(Path, decodePath, encodePath)
import Event exposing(Event, decodeEvent, encodeEvent)

type alias Competition =
    { path : List Path.Path
    , events : List Event.Event
    }

decodeCompetition : Json.Decode.Decoder Competition
decodeCompetition =
    Json.Decode.succeed Competition
        |> Json.Decode.Pipeline.required "path" (Json.Decode.list decodePath)
        |> Json.Decode.Pipeline.required "events" (Json.Decode.list decodeEvent)

encodeCompetition : Competition -> Json.Encode.Value
encodeCompetition record =
    Json.Encode.object
        [ ("path",  Json.Encode.list encodePath record.path)
        , ("events",  Json.Encode.list encodeEvent record.events)
        ]