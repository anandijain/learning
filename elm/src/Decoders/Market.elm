module Decoders.Market exposing (Market, decodeMarket, encodeMarket)

import Decoders.Outcome exposing (Outcome, decodeOutcome, encodeOutcome)
import Decoders.Period exposing (Period, decodePeriod, encodePeriod)
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


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


decodeMarket : D.Decoder Market
decodeMarket =
    D.succeed Market
        |> required "id" D.string
        |> required "description" D.string
        |> required "key" D.string
        |> required "marketTypeId" D.string
        |> required "status" D.string
        |> required "singleOnly" D.bool
        |> required "notes" D.string
        |> required "period" decodePeriod
        |> required "outcomes" (D.list decodeOutcome)


encodeMarket : Market -> E.Value
encodeMarket record =
    E.object
        [ ( "id", E.string <| record.id )
        , ( "description", E.string <| record.description )
        , ( "key", E.string <| record.key )
        , ( "marketTypeId", E.string <| record.marketTypeId )
        , ( "status", E.string <| record.status )
        , ( "singleOnly", E.bool <| record.singleOnly )
        , ( "notes", E.string <| record.notes )
        , ( "period", encodePeriod <| record.period )
        , ( "outcomes", E.list encodeOutcome record.outcomes ) -- worrisome
        ]
