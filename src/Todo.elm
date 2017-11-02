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
    ( Model [ "New task", "Another task" ], Cmd.none )


type alias Model =
    { entries : List String
    }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "todomvc-wrapper" ]
        [ section [ class "todoapp" ]
            [ showEntries
                model.entries
            ]
        ]


showEntries entries =
    section [ class "main" ]
        [ ul [ class "todo-list" ] (List.map showEntry entries)
        ]


showEntry entry =
    li []
        [ div [ class "view" ]
            [ label [] [ text entry ]
            ]
        ]
