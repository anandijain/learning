module Outcome exposing(Outcome, decodeOutcome, encodeOutcome)

import Json.Encode as E
import Json.Decode as D
import Json.Decode.Pipeline exposing(required)

import Price exposing(Price, decodePrice, encodePrice)

type alias Outcome =
    { id : String
    , description : String
    , status : String
    , outcomeType : String
    , competitorId : String
    , price : Price
    }


decodeOutcome : D.Decoder Outcome
decodeOutcome =
    D.succeed Outcome
        |> required "id" (D.string)
        |> required "description" (D.string)
        |> required "status" (D.string)
        |> required "type" (D.string)
        |> required "competitorId" (D.string)
        |> required "price" (decodePrice)


encodeOutcome : Outcome -> E.Value
encodeOutcome record =
    E.object
        [ ("id",  E.string <| record.id)
        , ("description",  E.string <| record.description)
        , ("status",  E.string <| record.status)
        , ("type",  E.string <| record.outcomeType)
        , ("competitorId",  E.string <| record.competitorId)
        , ("price",  encodePrice <| record.price)
        ]

