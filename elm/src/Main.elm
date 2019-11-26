module Main exposing (..)

import Browser
import Http
import Html.Events exposing (onClick)
import Html exposing (Html, button, div, text, pre)
import Json.Decode as D

import Competition

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
  | GotSport (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (Loading, getSport)

    GotSport result ->
      case result of
        Ok url ->
          (Success url, Cmd.none)

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
    [ h2 [] [ text "Random Cats" ]
    , viewMoneylines model
    ]


viewMoneylines : Model -> Html Msg
viewMoneylines model =
  case model of
    Failure ->
      div []
        [ text "I could not load a random cat for some reason. "
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]

    Loading ->
      text "Loading..."

    Success url ->
      div []
        [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
        , img [ src url ] []
        ]


-- HTTP

getSport : Cmd Msg
getSport = 
  Http.get
    { url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball/nba"
    , expect = Http.expectJson GotNBA decodeCompetiton
    }