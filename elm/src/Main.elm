module Main exposing (..)

import Browser
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav

import Http
import HttpBuilder
import HttpBuilder exposing (Task)

import Html exposing (..)
import Html.Attributes exposing(..)
import Html.Events exposing (onClick)
import Url exposing(Url)
import RemoteData exposing(WebData)

import Json.Decode exposing (Decoder, field, string, index, decodeString)

import Decoders.Competition exposing(Competition, decodeCompetition, encodeCompetition)



{-
TODO:
  - format json into tables
    - String -> Competition using Json.Decode
    - mimic bov.parse_event to take List Event into row :: List String
    - use cases to serialize row :: List String -> List Maybe Number
  - route to game_id endpoints
-}


-- MAIN


main : Program () Model Msg
main =
  application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL


type alias Model =
  { competitions : WebData (List Competition)
  }


-- init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
-- init maybeViewer url navKey =
--     changeRouteTo (Route.fromUrl url)
--         (Redirect (Session.fromViewer navKey maybeViewer))


init : ( Model, Cmd Msg )
init = 
  let
    model = {
      competitions = RemoteData.Loading
      }

  in 
  model 
    ! [ getCompetitions
        |> Task
    
    ]
  ( {}, Cmd.none )


-- Requests --


-- getSport : Cmd Msg
-- getSport = 
--   Http.get
--     { url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball/nba"
--     , expect = Http.expectString GotJson
--     }

decodeCompetitions : D.Decoder (List Competition)
decodeCompetitions =
    D.map (List.map Tuple.second) <| required "competitions" (D.list decodeCompetition)

 

getCompetitions : Task.Task Never (WebData (List Competition))
getCompetitions = 
  HttpBuilder.get("https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball")
    |> HttpBuilder.withExpect (Http.expectJson decodeCompetition)
    |> HttpBuilder.toTask
    |> RemoteData.fromTask 



-- UPDATE


-- type Msg
--   = NextSport
--   | GotJson (Result Http.Error String)


type Msg
    = ChangedUrl Url
    | ClickedLink UrlRequest
    | GotHomeMsg Home.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NextSport ->
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

view : Model -> Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [ text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]
      , ul []
          [ viewLink "/home"
          , viewLink "/index.html"
          , viewLink "/nba"
          , viewLink "/nfl"
          , viewLink "/nhl"
          ]
      ]
  }


viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]

-- view : Model -> Html Msg
-- view model =
--   div []
--     [ h2 [] [ text "Moneylines" ]
--     , viewSport model
--     ]



-- viewSport : Model -> Html Msg
-- viewSport model =
--   case model of
--     Failure ->
--       div []
--         [ text "could not load"
--         , button [ onClick NextSport ] [ text "next sport" ]
--         ]
--     Loading ->
--       text "Loading..."

--     Success fullJson -> onSuccess fullJson


onSuccess : String -> Html Msg
onSuccess textData =
  div []
    [ button [ onClick NextSport ] [ text "next sport" ]
    , button [ onClick NextSport ] [ text textData ]
    ]






