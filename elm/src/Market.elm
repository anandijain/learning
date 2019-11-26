module Market exposing(Market, decodeMarket, encodeMarket)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

import Outcome
import Period

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

type alias MarketPeriod =
    { id : String
    , description : String
    , abbreviation : String
    , live : Bool
    , main : Bool
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
        |> Json.Decode.Pipeline.required "period" (decodeMarketPeriod)
        |> Json.Decode.Pipeline.required "outcomes" (Json.Decode.list decodeOutcome)

decodeMarketPeriod : Json.Decode.Decoder MarketPeriod
decodeMarketPeriod =
    Json.Decode.succeed MarketPeriod
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "abbreviation" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "live" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "main" (Json.Decode.bool)

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
        , ("outcomes",  Json.Encode.list <| List.map encodeOutcome <| record.outcomes)
        ]
