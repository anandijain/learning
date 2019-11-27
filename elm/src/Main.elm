module Main exposing (..)

import Browser
import Http
import Html.Events exposing (onClick)
import Html exposing (..)
import Html.Attributes exposing(..)
import Random

import Json.Decode exposing (Decoder, field, string, index, decodeString)

import Competition exposing(Competition, decodeCompetition, encodeCompetition)

{-
TODO:
  - format json into tables
  - route to game_id endpoints
-}


-- MAIN


document =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL
type Model
  = Failure
  | Loading
  | Success String  -- suffix


init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getSport)


type alias SportModel =
  { sport : Sport
  }

-- UPDATE


type Msg
  = NextSport
  | GotJson (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    nextSport ->
      (Loading, getSport)

    GotJson result ->
      case result of
        Ok fullJson ->
          (Success fullJson, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)


sportGenerator : Random.Generator
sportGenerator =
  Random.uniform "basketball/nba"
    [ "baseball/mlb"
    , "football/nfl"
    , "hockey/nhl"
    , "esports"
    , "tennis"
    , "volleyball"
    , "badminton"
    , "table-tennis"
    ]

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Moneylines" ]
    , viewSport model
    ]


viewSport : Model -> Html Msg
viewSport model =
  case model.status of
    Failure ->
      div []
        [ text "could not load"
        , button [ onClick getSport ] [ text "next sport" ]
        ]
    Loading ->
      text "Loading..."

    Success fullJson -> onSuccess fullJson


onSuccess : String -> Html Msg
onSuccess textData =
  div []
    [ button [ onClick nextSport ] [ text "next sport" ]
    , button [ onClick nextSport ] [ text textData ]
    ]


-- HTTP


getSport : Cmd Msg
getSport = 
  Http.get
    { url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/"
    , expect = Http.expectString GotJson
    }







