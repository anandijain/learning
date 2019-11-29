module Decoders.Price exposing (Price, decodePrice, encodePrice)

import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


type alias Price =
    { id : String
    , handicap : String
    , american : String
    , decimal : String
    , fractional : String
    , malay : String
    , indonesian : String
    , hongkong : String
    }


decodePrice : D.Decoder Price
decodePrice =
    D.succeed Price
        |> required "id" D.string
        |> required "handicap" D.string
        |> required "american" D.string
        |> required "decimal" D.string
        |> required "fractional" D.string
        |> required "malay" D.string
        |> required "indonesian" D.string
        |> required "hongkong" D.string


encodePrice : Price -> E.Value
encodePrice record =
    E.object
        [ ( "id", E.string <| record.id )
        , ( "handicap", E.string <| record.handicap )
        , ( "american", E.string <| record.american )
        , ( "decimal", E.string <| record.decimal )
        , ( "fractional", E.string <| record.fractional )
        , ( "malay", E.string <| record.malay )
        , ( "indonesian", E.string <| record.indonesian )
        , ( "hongkong", E.string <| record.hongkong )
        ]
