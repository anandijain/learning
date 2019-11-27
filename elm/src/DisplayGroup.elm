module DisplayGroup exposing(DisplayGroup, decodeDisplayGroup, encodeDisplayGroup)

import Json.Encode as E
import Json.Decode as D
import Json.Decode.Pipeline exposing(required)

import Market exposing(Market, decodeMarket, encodeMarket)

type alias DisplayGroup =
    { id : String
    , description : String
    , defaultType : Bool
    , alternateType : Bool
    , markets : List Market
    , order : Int
    }

decodeDisplayGroup : D.Decoder DisplayGroup
decodeDisplayGroup =
    D.succeed DisplayGroup
        |> required "id" (D.string)
        |> required "description" (D.string)
        |> required "defaultType" (D.bool)
        |> required "alternateType" (D.bool)
        |> required "markets" (D.list decodeMarket)
        |> required "order" (D.int)

encodeDisplayGroup : DisplayGroup -> E.Value
encodeDisplayGroup record =
    E.object
        [ ("id",  E.string <| record.id)
        , ("description",  E.string <| record.description)
        , ("defaultType",  E.bool <| record.defaultType)
        , ("alternateType",  E.bool <| record.alternateType)
        , ("markets",  E.list encodeMarket record.markets)
        , ("order",  E.int <| record.order)
        ]