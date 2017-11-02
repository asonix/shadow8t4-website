module Main exposing (main)

{-| This is the main module of the application.


# main function

@docs main

-}

import Html exposing (Attribute, Html, a, button, div, h1, h3, header, img, li, nav, node, p, program, text, ul)
import Html.Attributes exposing (class, href, rel, src, title)
import Array exposing (Array)
import Dropdown exposing (ToggleEvent(..), drawer, dropdown, toggle)
import Window exposing (resizes, width)
import Task exposing (perform)


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
    , welcome : WelcomeBanner
    , gallery : Gallery
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


type alias WelcomeBanner =
    { title : String
    , description : String
    }


type alias Gallery =
    { title : String
    , description : String
    , columns : Int
    , images : List GalleryImage
    }


type alias GalleryImage =
    { url : String
    , mouseoverText : String
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
      , welcome = welcomeBanner "Welcome" "What are frogs tho"
      , gallery =
            initGallery
                "Gallery"
                "Here are some pictures I've taken"
                [ image "assets/gallery01.jpg" "woah"
                , image "assets/gallery02.png" "hey"
                , image "assets/gallery03.png" "why"
                , image "assets/gallery04.png" "pls"
                , image "assets/gallery05.png" "i cant"
                , image "assets/gallery06.png" "stop"
                , image "assets/gallery07.jpg" "making"
                , image "assets/gallery08.png" "this"
                , image "assets/gallery09.jpg" "website"
                , image "assets/gallery10.png" "dear"
                , image "assets/gallery11.png" "god"
                , image "assets/gallery12.png" "help"
                , image "assets/gallery13.png" "me"
                , image "assets/gallery14.png" "aaaaa"
                ]
      }
    , Task.perform WindowWidth Window.width
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


welcomeBanner : String -> String -> WelcomeBanner
welcomeBanner title description =
    { title = title, description = description }


image : String -> String -> GalleryImage
image url text =
    { url = url, mouseoverText = text }


initGallery : String -> String -> List GalleryImage -> Gallery
initGallery title description images =
    { title = title, description = description, columns = 4, images = images }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ headerBar model
        , welcome model.welcome
        , gallery model.gallery
        , div [ class "tmp" ]
            [ p [] [ text model.tmp ]
            ]
        ]


welcome : WelcomeBanner -> Html Msg
welcome banner =
    div [ class "welcome" ]
        [ div [ class "welcome-wrapper" ]
            [ div [ class "dimmer" ]
                [ div [ class "centered" ]
                    [ div [ class "content" ]
                        [ h1 [ class "title" ] [ text banner.title ]
                        , p [ class "description" ] [ text banner.description ]
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


gallery : Gallery -> Html Msg
gallery gallery =
    let
        arr : Array (List GalleryImage)
        arr =
            gallery.images
                |> List.indexedMap (\index item -> ( index, item ))
                |> List.foldl
                    (\( index, item ) arr ->
                        if (index % gallery.columns) < Array.length arr then
                            case
                                arr
                                    |> Array.get (index % gallery.columns)
                                    |> Maybe.map ((::) item)
                            of
                                Just column ->
                                    Array.set (index % gallery.columns) column arr

                                Nothing ->
                                    arr
                        else
                            Array.push [ item ] arr
                    )
                    Array.empty
    in
        div [ class "gallery" ]
            [ div [ class "gallery-wrapper" ]
                [ div [ class "gallery-info" ]
                    [ h3 [] [ text gallery.title ]
                    , p [] [ text gallery.description ]
                    ]
                , div [ class "gallery-columns" ]
                    (arr
                        |> Array.map
                            (\x ->
                                div [ class "gallery-column" ]
                                    (x |> List.reverse |> List.map displayImage)
                            )
                        |> Array.toList
                    )
                ]
            ]


displayImage : GalleryImage -> Html Msg
displayImage image =
    div [ class "gallery-image" ]
        [ div [ class "gallery-image-wrapper" ]
            [ img [ src image.url, title image.mouseoverText ] [] ]
        ]



-- UPDATE


type Msg
    = One
    | Two
    | WindowWidth Int
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

        WindowWidth x ->
            ( { model | gallery = updateWidth x model.gallery }, Cmd.none )

        ToggleDropdown index state ->
            ( { model | nav = updateDropdown index state model.nav }
            , Cmd.none
            )


updateWidth : Int -> Gallery -> Gallery
updateWidth width gallery =
    if width < 630 then
        { gallery | columns = 1 }
    else if width < 930 then
        { gallery | columns = 2 }
    else
        { gallery | columns = 3 }


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
    Window.resizes (\{ width } -> WindowWidth width)
