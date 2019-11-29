module Main exposing (..)

import Browser exposing (sandbox)
import Decoders.Competition exposing (Competition, decodeCompetition, encodeCompetition)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import HttpBuilder
import Json.Decode as D exposing (Decoder, decodeString, field, index, string)
import Json.Decode.Pipeline as P
import Json.Encode as E
import RemoteData exposing (WebData)
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


main : Program Never Model Msg
main =
    Browser.sandbox
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
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


decodeCompetitions : D.Decoder (List Competition)
decodeCompetitions =

    -- map decodeCompetition (D.list )
    
    -- D.succeed (List Competition)
    --     |> required "competitions" (D.list decodeCompetition)


getCompetitions : Cmd Msg
getCompetitions =
    Http.get
        { url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball"
        , expect = Http.expectJson GotCompetitions decodeCompetitions
        }



-- "https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball"
--     |> HttpBuilder.get
--     |> HttpBuilder.withExpect (Http.expectJson GotCompetitions decodeCompetition)
--     |> HttpBuilder.request
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
                [ text "I could not load a random cat for some reason. "
                , button [ onClick Refresh ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success comps ->
            div []
                [ button [ onClick Refresh, style "display" "block" ] [ text "More Please!" ]
                , pre [ comps ] []
                ]

        _ ->
            "other"
