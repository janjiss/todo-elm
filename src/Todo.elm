port module Todo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


main =
    Html.programWithFlags
        { view = view, subscriptions = subscriptions, update = updateWithStorage, init = init }


emptyModel =
    { entries = []
    , currentInput = ""
    , currentUid = 0
    }


port setStorage : Model -> Cmd msg


init : Maybe Model -> ( Model, Cmd Msg )
init model =
    ( Maybe.withDefault emptyModel model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = Add
    | UpdateInput String
    | Check Int
    | RemoveEntry Int


type alias Model =
    { entries : List Entry
    , currentInput : String
    , currentUid : Int
    }


type alias Entry =
    { description : String
    , uid : Int
    , isCompleted : Bool
    }


updateWithStorage msg model =
    let
        ( newModel, cmd ) =
            update msg model
    in
        ( newModel, Cmd.batch [ cmd, setStorage newModel ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add ->
            let
                newEntries =
                    List.append model.entries [ { description = model.currentInput, uid = model.currentUid, isCompleted = False } ]

                newUid =
                    model.currentUid + 1
            in
                ( { model | entries = newEntries, currentInput = "", currentUid = newUid }, Cmd.none )

        UpdateInput inputValue ->
            ( { model | currentInput = inputValue }, Cmd.none )

        Check uid ->
            let
                checkEntry entry =
                    if entry.uid == uid then
                        { entry | isCompleted = not entry.isCompleted }
                    else
                        entry

                newEntries =
                    List.map checkEntry model.entries
            in
                ( { model | entries = newEntries }, Cmd.none )

        RemoveEntry uid ->
            let
                newEntries =
                    List.filter (\e -> not (e.uid == uid)) model.entries
            in
                ( { model | entries = newEntries }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "todomvc-wrapper" ]
        [ section [ class "todoapp" ]
            [ showHeader model
            , showEntries model
            ]
        ]


showHeader : Model -> Html Msg
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


showEntries : Model -> Html Msg
showEntries model =
    section [ class "main" ]
        [ ul [ class "todo-list" ] (List.map showEntry model.entries) ]


showEntry : Entry -> Html Msg
showEntry entry =
    let
        completedClass =
            if entry.isCompleted then
                "completed"
            else
                ""
    in
        li [ class completedClass ]
            [ div [ class "view" ]
                [ input
                    [ class "toggle"
                    , type_ "checkbox"
                    , checked entry.isCompleted
                    , onClick (Check entry.uid)
                    ]
                    []
                , label [] [ text entry.description ]
                , button [ class "destroy", onClick (RemoveEntry entry.uid) ] []
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
