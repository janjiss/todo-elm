port module Todo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Json.Decode as Json
import String


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }


init : ( Model, Cmd msg )
init =
    ( 1, Cmd.none )


type alias Model =
    Int


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model + -1, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "button", onClick Increment, value "Increment" ] []
        , div [] []
        , text (toString model)
        , div [] []
        , input [ type_ "button", onClick Decrement, value "Decrement" ] []
        ]
