module Period exposing(Period, decodePeriod, encodePeriod)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

type alias Period =
    { id : String
    , description : String
    , abbreviation : String
    , live : Bool
    , main : Bool
    }

decodePeriod : Json.Decode.Decoder Period
decodePeriod =
    Json.Decode.succeed Period
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "abbreviation" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "live" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "main" (Json.Decode.bool)

encodePeriod : Period -> Json.Encode.Value
encodePeriod record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("description",  Json.Encode.string <| record.description)
        , ("abbreviation",  Json.Encode.string <| record.abbreviation)
        , ("live",  Json.Encode.bool <| record.live)
        , ("main",  Json.Encode.bool <| record.main)
        ]