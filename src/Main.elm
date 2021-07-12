module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, p, pre, text)
import Html.Attributes as A
import Html.Events as Events
import Http

main = Browser.element { init = init, update = update, view = view, subscriptions = subscriptions}

type Model
    = Failure
    | Loading
    | Success String

init : () -> (Model, Cmd Msg)
init _ =
    ( Loading
    , fetchDadJoke
    )

fetchDadJoke : Cmd Msg
fetchDadJoke =
    Http.request
            { method = "GET"
            , body = Http.emptyBody
            , headers = [ Http.header "Accept" "text/plain" ]
            , url = "https://icanhazdadjoke.com"
            , expect = Http.expectString GotJoke
            , timeout = Nothing
            , tracker = Nothing
            }

type Msg
    = GotJoke (Result Http.Error String)
    | RequestNewJoke

update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
    case msg of
        GotJoke result ->
            case result of
                Ok joke ->
                    ( Success joke, Cmd.none )
                Err _ ->
                    ( Failure, Cmd.none)

        RequestNewJoke ->
            ( Loading, fetchDadJoke )


view : Model -> Html Msg
view model =
    div [ A.style "text-align" "center" ]
        [ h1 [] [ text "Elm dad joke" ]
        , case model of
            Loading ->
                p [] [ text "Loading..." ]

            Failure ->
                div []
                    [ p [ A.style "color" "red" ] [ text "Ouch, something went wrong while fetching the stuff over the network" ]
                    , button [ Events.onClick RequestNewJoke, A.type_ "button"] [ text "Get another Joke" ]
                    ]

            Success theText ->
                div []
                    [ pre [] [ text theText ]
                    , button [ Events.onClick RequestNewJoke, A.type_ "button" ] [ text "Get another Joke "]
                ]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none