module Main exposing (..)

import Browser
import Http
import Html.Events exposing (onClick)
import Html exposing (..)
import Html.Attributes exposing(..)
import Maybe
import Dict

import Json.Decode exposing (Decoder, field, string, index, decodeString)

import Competition exposing(Competition, decodeCompetition, encodeCompetition)

{-
TODO:
  - format json into tables
  - route to game_id endpoints
-}


-- MAIN


main =
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
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getSport)


-- UPDATE


type Msg
  = MorePlease
  | GotJson (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (Loading, getSport)

    GotJson result ->
      case result of
        Ok fullJson ->
          (Success fullJson, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Moneylines" ]
    , viewMoneylines model
    ]


viewMoneylines : Model -> Html Msg
viewMoneylines model =
  case model of
    Failure ->
      div []
        [ text "could not load"
        , button [ onClick MorePlease ] [ text "different sport" ]
        ]
    Loading ->
      text "Loading..."

    Success fullJson ->
      div []
        [ button [ onClick MorePlease ] [ text "diff sport" ]
        , button [ onClick MorePlease ] [ text fullJson ]
        ]
        

-- HTTP



-- simpleDecoder : Decoder String
-- simpleDecoder =
--   field "events"



getSport : Cmd Msg
getSport = 
  Http.get
    { url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball/nba"
    , expect = Http.expectString GotJson
    }

getId : Decoder String
getId =
  index 0 (field "events" (index 0 (field "id" string)))
