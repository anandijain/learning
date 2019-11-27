module Path exposing(Path, decodePath, encodePath)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

type alias Path =
    { id : String
    , link : String
    , description : String
    , pathType : String
    , sportCode : String
    , order : Int
    , leaf : Bool
    , current : Bool
    }

decodePath : Json.Decode.Decoder Path
decodePath =
    Json.Decode.succeed Path
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "link" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "sportCode" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "order" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "leaf" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "current" (Json.Decode.bool)

encodePath : Path -> Json.Encode.Value
encodePath record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("link",  Json.Encode.string <| record.link)
        , ("description",  Json.Encode.string <| record.description)
        , ("type",  Json.Encode.string <| record.pathType)
        , ("sportCode",  Json.Encode.string <| record.sportCode)
        , ("order",  Json.Encode.int <| record.order)
        , ("leaf",  Json.Encode.bool <| record.leaf)
        , ("current",  Json.Encode.bool <| record.current)
        ]