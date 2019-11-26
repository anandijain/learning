module Price exposing(Price, decodePrice, encodePrice)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

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

decodePrice : Json.Decode.Decoder Price
decodePrice =
    Json.Decode.succeed Price
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "handicap" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "american" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "decimal" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "fractional" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "malay" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "indonesian" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "hongkong" (Json.Decode.string)

encodePrice : Price -> Json.Encode.Value
encodePrice record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("handicap",  Json.Encode.string <| record.handicap)
        , ("american",  Json.Encode.string <| record.american)
        , ("decimal",  Json.Encode.string <| record.decimal)
        , ("fractional",  Json.Encode.string <| record.fractional)
        , ("malay",  Json.Encode.string <| record.malay)
        , ("indonesian",  Json.Encode.string <| record.indonesian)
        , ("hongkong",  Json.Encode.string <| record.hongkong)
        ]