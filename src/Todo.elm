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


init =
    ( 1, Cmd.none )


type alias Model =
    Int


type Msg
    = Add


update cmd model =
    ( model, Cmd.none )


view model =
    text (toString model)
