module Todo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


main =
    Html.program
        { view = view, subscriptions = subscriptions, update = update, init = init }


init : ( Model, Cmd Msg )
init =
    ( { entries = [ "My first task", "My second task" ], currentInput = "" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = Add
    | UpdateInput String


type alias Model =
    { entries : List String
    , currentInput : String
    }


update msg model =
    case msg of
        Add ->
            let
                newEntries =
                    List.append model.entries [ model.currentInput ]
            in
                ( { model | entries = newEntries, currentInput = "" }, Cmd.none )

        UpdateInput inputValue ->
            ( { model | currentInput = inputValue }, Cmd.none )


view model =
    div [ class "todomvc-wrapper" ]
        [ section [ class "todoapp" ]
            [ showHeader model
            , showEntries model
            ]
        ]


showHeader model =
    header [ class "header" ]
        [ h1 [] [ text "todos" ]
        , input
            [ class "new-todo"
            , placeholder "What needs to be done?"
            , onEnter Add
            , onInput UpdateInput
            , value model.currentInput
            ]
            []
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


onEnter msg =
    let
        isEnter key =
            if key == 13 then
                Json.succeed msg
            else
                Json.fail "Not enter"
    in
        on "keydown" (Json.andThen isEnter keyCode)
