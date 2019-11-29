module Decoders.Period exposing (Period, decodePeriod, encodePeriod)

import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


type alias Period =
    { id : String
    , description : String
    , abbreviation : String
    , live : Bool
    , main : Bool
    }


decodePeriod : D.Decoder Period
decodePeriod =
    D.succeed Period
        |> required "id" D.string
        |> required "description" D.string
        |> required "abbreviation" D.string
        |> required "live" D.bool
        |> required "main" D.bool


encodePeriod : Period -> E.Value
encodePeriod record =
    E.object
        [ ( "id", E.string <| record.id )
        , ( "description", E.string <| record.description )
        , ( "abbreviation", E.string <| record.abbreviation )
        , ( "live", E.bool <| record.live )
        , ( "main", E.bool <| record.main )
        ]
