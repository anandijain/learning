module Main exposing (..)

import Browser exposing (sandbox)
import Decoders.Competition exposing (Competition, decodeCompetition, encodeCompetition)
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import HttpBuilder
import Json.Decode as D exposing (Decoder, decodeString, field, index, string)
import Json.Decode.Pipeline as P
import Json.Encode as E
import RemoteData exposing (WebData)
import String.Conversions exposing (fromList, fromRecord)
import Task



{-
   TODO:
     - format json into tables
       - String -> Competition using Json.Decode
       - mimic bov.parse_event to take List Event into row :: List String
       - use cases to serialize row :: List String -> List Maybe Number
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
    | Success (List Competition)



-- init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
-- init maybeViewer url navKey =
--     changeRouteTo (Route.fromUrl url)
--         (Redirect (Session.fromViewer navKey maybeViewer))


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getCompetitions )



---- Requests ----


type alias Competitions =
    List Competition


decodeCompetitions : D.Decoder Competitions
decodeCompetitions =
    D.succeed Competitions
        |> required D.list decodeCompetition


getCompetitions : Cmd Msg
getCompetitions =
    Http.get
        { url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball/nba"
        , expect = Http.expectJson GotCompetitions decodeCompetitions
        }



---- UPDATE ----


type Msg
    = Refresh
    | GotCompetitions (Result Http.Error (List Competition))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Refresh ->
            ( Loading, getCompetitions )

        GotCompetitions result ->
            case result of
                Ok comps ->
                    ( Success comps, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            div []
                [ text "couldn't load "
                , button [ onClick Refresh ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success comps ->
            div []
                [ div []
                    [ button [ onClick Refresh, style "display" "block" ] [ text "More Please!" ] ]
                , div []
                    [ ul [ class "events" ]
                        [ li [] (List.map text (List.map .id (List.concatMap .events comps))) ]
                    ]
                ]



-- viewComp : List Competition -> Html Msg
-- viewComp comp =
--     [ ul [ class "events" ]
--         li [] (List.map text (List.concatMap .id (List.concatMap .events comp)))
--     ]
-- map viewEvent comp.events
-- viewEvent : Event -> Html Msg
