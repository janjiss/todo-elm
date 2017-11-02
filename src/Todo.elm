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
    ( Model [ "New task", "Another task" ] "", Cmd.none )


type alias Model =
    { entries : List String
    , currentInput : String
    }


type Msg
    = Add
    | ChangeInput String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Add ->
            ( { model | entries = List.append model.entries [ model.currentInput ], currentInput = "" }, Cmd.none )

        ChangeInput newInput ->
            ( { model | currentInput = newInput }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "todomvc-wrapper" ]
        [ section [ class "todoapp" ]
            [ showHeader model
            , showEntries model.entries
            ]
        ]


showHeader model =
    header [ class "header" ]
        [ h1 [] [ text "todos" ]
        , input [ class "new-todo", value model.currentInput, placeholder "What needs to be done?", onEnter Add, onInput ChangeInput ] []
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


onEnter msg =
    let
        isEnter key =
            if key == 13 then
                Json.succeed msg
            else
                Json.fail "Not Enter"
    in
        on "keydown" (Json.andThen isEnter keyCode)
