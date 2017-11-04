module Todo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Html.program
        { view = view, subscriptions = subscriptions, update = update, init = init }


init : ( Model, Cmd Msg )
init =
    ( { entries = [ "My first task", "My second task" ] }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = Add


type alias Model =
    { entries : List String
    }


update msg model =
    ( model, Cmd.none )


view model =
    div [ class "todomvc-wrapper" ]
        [ section [ class "todoapp" ]
            [ showHeader
            , showEntries model
            ]
        ]


showHeader =
    header [ class "header" ]
        [ h1 [] [ text "todos" ]
        ]


showEntries model =
    section [ class "main" ]
        [ ul [ class "todo-list" ] (List.map showEntry model.entries) ]


showEntry entry =
    li []
        [ div [ class "view" ]
            [ label [] [ text entry ]
            ]
        ]
