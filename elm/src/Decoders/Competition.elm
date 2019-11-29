module Decoders.Competition exposing (Competition, decodeCompetition, encodeCompetition)

import Decoders.Event exposing (Event, decodeEvent, encodeEvent)
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Path exposing (Path, decodePath, encodePath)



-- type alias Competitions =
--     { competitions : List Competition
--     }


type alias Competition =
    { path : List Path
    , events : List Event
    }


decodeCompetition : D.Decoder Competition
decodeCompetition =
    D.succeed Competition
        |> required "path" (D.list decodePath)
        |> required "events" (D.list decodeEvent)


encodeCompetition : Competition -> E.Value
encodeCompetition record =
    E.object
        [ ( "path", E.list encodePath record.path )
        , ( "events", E.list encodeEvent record.events )
        ]



-- encodeCompetitions : Competition -> E.Value
-- encodeCompetitions record =
--     E.object
--         [ ("competitions",  E.list encodePath record.path)
--         ]
