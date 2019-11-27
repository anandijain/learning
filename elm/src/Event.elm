module Event exposing(Event, decodeEvent, encodeEvent)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline

import Competitor exposing(Competitor, decodeCompetitor, encodeCompetitor)
import DisplayGroup exposing(DisplayGroup, decodeDisplayGroup, encodeDisplayGroup)

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

decodeEvent : Json.Decode.Decoder Event
decodeEvent =
    Json.Decode.succeed Event
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "type" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "link" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "status" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "sport" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "startTime" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "live" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "awayTeamFirst" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "denySameGame" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "teaserAllowed" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "competitionId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "notes" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "numMarkets" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "lastModified" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "competitors" (Json.Decode.list decodeCompetitor)
        |> Json.Decode.Pipeline.required "displayGroups" (Json.Decode.list decodeDisplayGroup)

encodeEvent : Event -> Json.Encode.Value
encodeEvent record =
    Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("description",  Json.Encode.string <| record.description)
        , ("type",  Json.Encode.string <| record.eventType)
        , ("link",  Json.Encode.string <| record.link)
        , ("status",  Json.Encode.string <| record.status)
        , ("sport",  Json.Encode.string <| record.sport)
        , ("startTime",  Json.Encode.int <| record.startTime)
        , ("live",  Json.Encode.bool <| record.live)
        , ("awayTeamFirst",  Json.Encode.bool <| record.awayTeamFirst)
        , ("denySameGame",  Json.Encode.string <| record.denySameGame)
        , ("teaserAllowed",  Json.Encode.bool <| record.teaserAllowed)
        , ("competitionId",  Json.Encode.string <| record.competitionId)
        , ("notes",  Json.Encode.string <| record.notes)
        , ("numMarkets",  Json.Encode.int <| record.numMarkets)
        , ("lastModified",  Json.Encode.int <| record.lastModified)
        , ("competitors",  Json.Encode.list encodeCompetitor record.competitors)
        , ("displayGroups",  Json.Encode.list encodeDisplayGroup record.displayGroups)
        ]