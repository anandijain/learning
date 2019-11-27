module Market exposing(Market, decodeMarket, encodeMarket)


import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


import Outcome exposing(Outcome, decodeOutcome, encodeOutcome)
import Period exposing(Period, decodePeriod, encodePeriod)


type alias Market =
    { id : String
    , description : String
    , key : String
    , marketTypeId : String
    , status : String
    , singleOnly : Bool
    , notes : String
    , period : Period
    , outcomes : List Outcome
    }


decodeMarket : Json.Decode.Decoder Market
decodeMarket =
    Json.Decode.succeed Market
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "key" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "marketTypeId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "status" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "singleOnly" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "notes" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "period" (decodePeriod)
        |> Json.Decode.Pipeline.required "outcomes" (Json.Decode.list decodeOutcome)


encodeMarket : Market -> Json.Encode.Value
encodeMarket record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("description",  Json.Encode.string <| record.description)
        , ("key",  Json.Encode.string <| record.key)
        , ("marketTypeId",  Json.Encode.string <| record.marketTypeId)
        , ("status",  Json.Encode.string <| record.status)
        , ("singleOnly",  Json.Encode.bool <| record.singleOnly)
        , ("notes",  Json.Encode.string <| record.notes)
        , ("period",  encodePeriod <| record.period)
        , ("outcomes", Json.Encode.list encodeOutcome record.outcomes)  -- worrisome
        ]
