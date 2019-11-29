module Decoders.Event exposing (Event, decodeEvent, encodeEvent)

import Decoders.Competitor exposing (Competitor, decodeCompetitor, encodeCompetitor)
import Decoders.DisplayGroup exposing (DisplayGroup, decodeDisplayGroup, encodeDisplayGroup)
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


type alias Event =
    { id : String
    , description : String
    , eventType : String
    , link : String
    , status : String
    , sport : String
    , startTime : Int
    , live : Bool
    , awayTeamFirst : Bool
    , denySameGame : String
    , teaserAllowed : Bool
    , competitionId : String
    , notes : String
    , numMarkets : Int
    , lastModified : Int
    , competitors : List Competitor
    , displayGroups : List DisplayGroup
    }


decodeEvent : D.Decoder Event
decodeEvent =
    D.succeed Event
        |> required "id" D.string
        |> required "description" D.string
        |> required "type" D.string
        |> required "link" D.string
        |> required "status" D.string
        |> required "sport" D.string
        |> required "startTime" D.int
        |> required "live" D.bool
        |> required "awayTeamFirst" D.bool
        |> required "denySameGame" D.string
        |> required "teaserAllowed" D.bool
        |> required "competitionId" D.string
        |> required "notes" D.string
        |> required "numMarkets" D.int
        |> required "lastModified" D.int
        |> required "competitors" (D.list decodeCompetitor)
        |> required "displayGroups" (D.list decodeDisplayGroup)


encodeEvent : Event -> E.Value
encodeEvent record =
    E.object
        [ ( "id", E.string <| record.id )
        , ( "description", E.string <| record.description )
        , ( "type", E.string <| record.eventType )
        , ( "link", E.string <| record.link )
        , ( "status", E.string <| record.status )
        , ( "sport", E.string <| record.sport )
        , ( "startTime", E.int <| record.startTime )
        , ( "live", E.bool <| record.live )
        , ( "awayTeamFirst", E.bool <| record.awayTeamFirst )
        , ( "denySameGame", E.string <| record.denySameGame )
        , ( "teaserAllowed", E.bool <| record.teaserAllowed )
        , ( "competitionId", E.string <| record.competitionId )
        , ( "notes", E.string <| record.notes )
        , ( "numMarkets", E.int <| record.numMarkets )
        , ( "lastModified", E.int <| record.lastModified )
        , ( "competitors", E.list encodeCompetitor record.competitors )
        , ( "displayGroups", E.list encodeDisplayGroup record.displayGroups )
        ]
