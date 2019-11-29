module Path exposing (Path, decodePath, encodePath)

import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


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


decodePath : D.Decoder Path
decodePath =
    D.succeed Path
        |> required "id" D.string
        |> required "link" D.string
        |> required "description" D.string
        |> required "type" D.string
        |> required "sportCode" D.string
        |> required "order" D.int
        |> required "leaf" D.bool
        |> required "current" D.bool


encodePath : Path -> E.Value
encodePath record =
    E.object
        [ ( "id", E.string <| record.id )
        , ( "link", E.string <| record.link )
        , ( "description", E.string <| record.description )
        , ( "type", E.string <| record.pathType )
        , ( "sportCode", E.string <| record.sportCode )
        , ( "order", E.int <| record.order )
        , ( "leaf", E.bool <| record.leaf )
        , ( "current", E.bool <| record.current )
        ]
