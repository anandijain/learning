module Outcome exposing(Outcome, decodeOutcome, encodeOutcome)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

import Price exposing(Price, decodePrice, encodePrice)

type alias Outcome =
    { id : String
    , description : String
    , status : String
    , outcomeType : String
    , competitorId : String
    , price : Price
    }


decodeOutcome : Json.Decode.Decoder Outcome
decodeOutcome =
    Json.Decode.succeed Outcome
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "status" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "competitorId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "price" (decodePrice)


encodeOutcome : Outcome -> Json.Encode.Value
encodeOutcome record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("description",  Json.Encode.string <| record.description)
        , ("status",  Json.Encode.string <| record.status)
        , ("type",  Json.Encode.string <| record.outcomeType)
        , ("competitorId",  Json.Encode.string <| record.competitorId)
        , ("price",  encodePrice <| record.price)
        ]

