module Main exposing (main)

{-| This is the main module of the application.


# main function

@docs main

-}

import Html exposing (Attribute, Html, a, button, div, h1, header, li, nav, node, p, program, text, ul)
import Html.Attributes exposing (class, href, rel)
import Array exposing (Array)
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
    , nav : Array NavItem
    }


type NavItem
    = HomeLink String String
    | InitDropdown String (Array NavItem)
    | Dropdown String DropdownConfig (Array NavItem)
    | NavLink String String


type alias DropdownConfig =
    { name : String
    , event : ToggleEvent
    , attribute : Attribute Msg
    , state : Dropdown.State
    , message : Bool -> Msg
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { tmp = "Hewwo!"
      , nav =
            initDropdowns
                [ HomeLink "Home" "/"
                , InitDropdown
                    "Social Media"
                    (initDropdowns
                        [ NavLink "Tumblr" "/"
                        , NavLink "Facebook" "/"
                        , NavLink "YouTube" "/"
                        , NavLink "Instagram" "/"
                        , NavLink "Google+" "/"
                        ]
                    )
                , NavLink "AskBox" "/"
                , NavLink "Submit" "/"
                , NavLink "Me" "/"
                , InitDropdown
                    "Test"
                    (initDropdowns
                        [ NavLink "One" "/"
                        , NavLink "Two" "/"
                        ]
                    )
                ]
      }
    , Cmd.none
    )


defaultDropdownConfig : DropdownConfig
defaultDropdownConfig =
    { name = "dropdown1"
    , event = OnClick
    , attribute = class "dropdown"
    , state = False
    , message = ToggleDropdown 0
    }


initDropdown : Int -> NavItem -> NavItem
initDropdown index item =
    case item of
        Dropdown name config items ->
            Dropdown
                name
                { config
                    | name = "dropdown" ++ (toString index)
                    , message = ToggleDropdown index
                }
                items

        InitDropdown name items ->
            Dropdown
                name
                { defaultDropdownConfig
                    | name = "dropdown" ++ (toString index)
                    , message = ToggleDropdown index
                }
                items

        other ->
            other


initDropdowns : List NavItem -> Array NavItem
initDropdowns =
    Array.indexedMap initDropdown << Array.fromList



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
            [ ul [] (Array.map navItem model.nav |> Array.toList)
            ]
        ]


homeLink : String -> String -> Html Msg
homeLink name url =
    li [ class "home-item" ]
        [ div []
            [ a [ class "nav-link", href url ]
                [ div [ class "button-wrapper" ]
                    [ p [] [ text name ]
                    ]
                ]
            ]
        ]


navItem : NavItem -> Html Msg
navItem item =
    case item of
        NavLink name url ->
            navLink name url

        Dropdown name config items ->
            navDropdown name config items

        HomeLink name url ->
            homeLink name url

        _ ->
            text ""


navLink : String -> String -> Html Msg
navLink name url =
    li [ class "nav-item" ]
        [ div []
            [ a [ class "nav-link", href url ]
                [ div [ class "button-wrapper" ]
                    [ p [] [ text name ]
                    ]
                ]
            ]
        ]


navDropdown : String -> DropdownConfig -> Array NavItem -> Html Msg
navDropdown name config items =
    li [ class "nav-item" ]
        [ dropdown
            config.state
            (dropdownConfig config)
            (toggle div
                (if config.state then
                    [ class "dropdown-active", class "button-wrapper" ]
                 else
                    [ class "button-wrapper" ]
                )
                [ p [] [ text name ]
                ]
            )
            (drawer ul [ class "dropdown" ] (Array.map subItem items |> Array.toList))
        ]


subItem : NavItem -> Html Msg
subItem item =
    case item of
        NavLink name url ->
            li [ class "sub-item" ]
                [ a [ class "nav-link", href url ]
                    [ p [] [ text name ]
                    ]
                ]

        _ ->
            text ""


dropdownConfig : DropdownConfig -> Dropdown.Config Msg
dropdownConfig config =
    Dropdown.Config
        config.name
        config.event
        config.attribute
        config.message



-- UPDATE


type Msg
    = One
    | Two
    | ToggleDropdown Int Bool


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

        ToggleDropdown index state ->
            ( { model | nav = updateDropdown index state model.nav }
            , Cmd.none
            )


updateDropdown : Int -> Bool -> Array NavItem -> Array NavItem
updateDropdown index state navArray =
    case Array.get index navArray of
        Just dropdown ->
            case dropdown of
                (Dropdown name config items) as dropdown ->
                    Array.set index (Dropdown name { config | state = state } items) navArray

                _ ->
                    navArray

        Nothing ->
            navArray



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
