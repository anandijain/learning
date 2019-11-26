module Path exposing(Path, decodePath, encodePath)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

type alias Price =
    { id : String
    , link : String
    , description : String
    , type : String
    , sportCode : String
    , order : Int
    , leaf : Bool
    , current : Bool
    }

decodePrice : Json.Decode.Decoder Price
decodePrice =
    Json.Decode.succeed Price
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "link" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "sportCode" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "order" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "leaf" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "current" (Json.Decode.bool)

encodePrice : Price -> Json.Encode.Value
encodePrice record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("link",  Json.Encode.string <| record.link)
        , ("description",  Json.Encode.string <| record.description)
        , ("type",  Json.Encode.string <| record.type)
        , ("sportCode",  Json.Encode.string <| record.sportCode)
        , ("order",  Json.Encode.int <| record.order)
        , ("leaf",  Json.Encode.bool <| record.leaf)
        , ("current",  Json.Encode.bool <| record.current)
        ]