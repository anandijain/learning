module Competition exposing(Competition, decodeCompetition, encodeCompetition)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

import Path
import Event

type alias Competition =
    { path : List Path
    , events : List Event
    }

decodeCompetition : Json.Decode.Decoder Competition
decodeCompetition =
    Json.Decode.succeed Competition
        |> Json.Decode.Pipeline.required "path" (Json.Decode.list decodePath)
        |> Json.Decode.Pipeline.required "events" (Json.Decode.list decodeEvent)

encodeCompetition : Competition -> Json.Encode.Value
encodeCompetition record =
    Json.Encode.object
        [ ("path",  Json.Encode.list <| List.map encodePath <| record.path)
        , ("events",  Json.Encode.list <| List.map encodeEvent <| record.events)
        ]