module DisplayGroup exposing(DisplayGroup, decodeDisplayGroup, encodeDisplayGroup)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

import Market exposing(Market, decodeMarket, encodeMarket)

type alias DisplayGroup =
    { id : String
    , description : String
    , defaultType : Bool
    , alternateType : Bool
    , markets : List Market
    , order : Int
    }

decodeDisplayGroup : Json.Decode.Decoder DisplayGroup
decodeDisplayGroup =
    Json.Decode.succeed DisplayGroup
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "defaultType" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "alternateType" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "markets" (Json.Decode.list decodeMarket)
        |> Json.Decode.Pipeline.required "order" (Json.Decode.int)

encodeDisplayGroup : DisplayGroup -> Json.Encode.Value
encodeDisplayGroup record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("description",  Json.Encode.string <| record.description)
        , ("defaultType",  Json.Encode.bool <| record.defaultType)
        , ("alternateType",  Json.Encode.bool <| record.alternateType)
        , ("markets",  Json.Encode.list encodeMarket record.markets)
        , ("order",  Json.Encode.int <| record.order)
        ]