module Competitor exposing(Competitor, decodeCompetitor, encodeCompetitor)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

type alias Competitor =
    { id : String
    , name : String
    , home : Bool
    }

decodeCompetitor : Json.Decode.Decoder Competitor
decodeCompetitor =
    Json.Decode.succeed Competitor
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "home" (Json.Decode.bool)

encodeCompetitor : Competitor -> Json.Encode.Value
encodeCompetitor record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("name",  Json.Encode.string <| record.name)
        , ("home",  Json.Encode.bool <| record.home)
        ]