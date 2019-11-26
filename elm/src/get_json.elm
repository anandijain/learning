import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string, int, float, bool)

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
  (Loading, getNBA)



-- UPDATE


type Msg
  = MorePlease
  | GotGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (Loading, getRandomCatGif)

    GotGif result ->
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
    , viewGif model
    ]


viewGif : Model -> Html Msg
viewGif model =
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


getNBA : Cmd Msg
getNBA =
  Http.get
    { url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/basketball/nba"
    , expect = Http.expectJson GotGif gifDecoder
    }

eventDecoder : Decoder Event
eventDecoder = 
  field "data" (field "image_url" string)

type alias Events = List GameEvent

type alias GameEvent = 
{ description : String
, id : Int
, competitors : list Competitor
, competitionId : Int
, displayGroups : List DisplayGroup
, lastModified : Int
, link : String
, live : Bool
, numMarkets : Int
, status : Char
, teaserAllowed : Bool
, type : String
, startTime : Int
, awayTeamFirst : Bool
, denySameGame : String
, }


type alias DisplayGroup =
{ description : String
, alternateType : Bool
, defaultType : Bool
, id : String
, markets : List Market
, order : Int
}

type alias Competitor =
{ name : String
, id : String
, home : Bool
}

type alias Market = 
{ description : String
, marketTypeId : Int
, marketKey : String
, outcome : List Outcome
, period : Period
, singleOnly : Bool
, status : String
}

type alias Outcome =
{ description : String
, competitorId : String
, id : Int
, price : Price
, type : Char
, status : Char
}

type alias Price =
{ id : Int
, american : Int
, decimal : Float
}

type alias Period = 
{ description : String
, abbreviation : String
, id : Int
, live : Bool
, main : Bool
}

