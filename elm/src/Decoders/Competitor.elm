module Decoders.Competitor exposing (Competitor, decodeCompetitor, encodeCompetitor)

import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


type alias Competitor =
    { id : String
    , name : String
    , home : Bool
    }


decodeCompetitor : D.Decoder Competitor
decodeCompetitor =
    D.succeed Competitor
        |> required "id" D.string
        |> required "name" D.string
        |> required "home" D.bool


encodeCompetitor : Competitor -> E.Value
encodeCompetitor record =
    E.object
        [ ( "id", E.string <| record.id )
        , ( "name", E.string <| record.name )
        , ( "home", E.bool <| record.home )
        ]
