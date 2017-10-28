module Main exposing (main)

{-| This is the main module of the application.


# main function

@docs main

-}

import Html exposing (Html, a, button, div, h1, header, li, nav, node, p, program, text, ul)
import Html.Attributes exposing (class, href, rel)
import Dropdown exposing (ToggleEvent(..), drawer, dropdown, toggle)


-- MAIN


{-| The main function of the application
-}
main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { tmp : String
    , dropdown : Dropdown.State
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { tmp = "Hewwo!"
      , dropdown = False
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ headerBar model
        , welcome model
        , div [ class "tmp" ]
            [ p [] [ text model.tmp ]
            ]
        ]


welcome : Model -> Html Msg
welcome model =
    div [ class "welcome" ]
        [ div [ class "welcome-wrapper" ]
            [ div [ class "dimmer" ]
                [ div [ class "centered" ]
                    [ div [ class "content" ]
                        [ h1 [ class "title" ] [ text "Welcome" ]
                        , p [ class "description" ] [ text "What are frogs tho" ]
                        ]
                    ]
                ]
            ]
        ]


headerBar : Model -> Html Msg
headerBar model =
    header []
        [ nav []
            [ ul []
                [ homeItem "Home"
                , navItemDropdown model
                , navItem "ASKBOX"
                , navItem "SUBMIT"
                , navItem "ME"
                ]
            ]
        ]


navItemDropdown : Model -> Html Msg
navItemDropdown model =
    li [ class "nav-item" ]
        [ dropdown
            model.dropdown
            dropdownConfig
            (toggle div
                (if model.dropdown then
                    [ class "dropdown-active", class "button-wrapper" ]
                 else
                    [ class "button-wrapper" ]
                )
                [ p []
                    [ text "SOCIAL MEDIA" ]
                ]
            )
            (drawer ul
                [ class "dropdown" ]
                [ subItem "Tumblr"
                , subItem "Facebook"
                , subItem "YouTube"
                , subItem "Instagram"
                , subItem "Google+"
                ]
            )
        ]


subItem : String -> Html Msg
subItem name =
    li [ class "sub-item" ]
        [ p []
            [ text name ]
        ]


homeItem : String -> Html Msg
homeItem name =
    li [ class "home-item" ]
        [ div []
            [ div [ class "button-wrapper" ]
                [ p []
                    [ text name ]
                ]
            ]
        ]


navItem : String -> Html Msg
navItem name =
    li [ class "nav-item" ]
        [ div []
            [ div [ class "button-wrapper" ]
                [ p []
                    [ text name ]
                ]
            ]
        ]


dropdownConfig : Dropdown.Config Msg
dropdownConfig =
    Dropdown.Config
        "dropdown"
        OnClick
        (class "visible")
        ToggleDropdown



-- UPDATE


type Msg
    = One
    | Two
    | ToggleDropdown Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        One ->
            ( { model | tmp = "Mr Obama?" }
            , Cmd.none
            )

        Two ->
            ( { model | tmp = "Hewwo!" }
            , Cmd.none
            )

        ToggleDropdown newState ->
            ( { model | dropdown = newState }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
