module Main exposing (main)

{-| This is the main module of the application.


# main function

@docs main

-}

import Html exposing (Attribute, Html, a, article, button, div, footer, h1, h2, h3, header, img, li, nav, p, program, section, span, text, ul)
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
    { nav : Array NavItem
    , welcome : WelcomeBanner
    , gallery : Gallery
    , footer : List FooterSection
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


type alias FooterSection =
    { title : String
    , description : String
    , link : String
    , url : String
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { nav =
            initDropdowns
                [ HomeLink "Home" "/"
                , InitDropdown
                    "Social Media"
                    (initDropdowns
                        [ NavLink "Tumblr" "https://shadow8t4.tumblr.com"
                        , NavLink "Facebook" "https://facebook.com/shadow8t3"
                        , NavLink "Mastodon" "https://asonix.dog/@shadow8t4"
                        , NavLink "YouTube" "https://www.youtube.com/channel/UCZAXVnn6i1hcgDjV93HPbzg"
                        , NavLink "Instagram" "https://instagram.com/shadow8t4"
                        , NavLink "Google+" "https://plus.google.com/u/2/118253409016956205819"
                        ]
                    )
                , NavLink "AskBox" "https://shadow8t4.tumblr.com/ask"
                , NavLink "Submit" "https://shadow8t4.tumblr.ccom/submit"
                , NavLink "Me" "https://shadow8t4.tumblr.com/tagged/me"
                , NavLink "Revival Survival" "/revival-survival"
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
      , footer =
            [ initFooterSection
                "Video Games"
                "I have an extensive collection and hope to someday go into design maybe."
                "This link is useless"
                "/"
            , initFooterSection
                "Programming"
                "I really love to program, probably one of my favorite hobbies, and hopefully someday I'll make it part of my career."
                "So is this one"
                "/"
            , initFooterSection
                "Music"
                "\"Music is my life\" is such a 90's thing to say, but it's still true. Wish I could make more time for it."
                "MEMES THO???"
                "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
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


initFooterSection : String -> String -> String -> String -> FooterSection
initFooterSection title description link url =
    { title = title, description = description, link = link, url = url }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ headerBar model
        , welcome model.welcome
        , gallery model.gallery
        , footerSections model.footer
        ]


welcome : WelcomeBanner -> Html Msg
welcome banner =
    section [ class "welcome" ]
        [ div [ class "welcome-wrapper" ]
            [ div [ class "dimmer" ]
                [ div [ class "centered" ]
                    [ article [ class "content" ]
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
                [ p []
                    [ text name
                    , span [ class "carat" ] []
                    ]
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
            [ section [ class "gallery-wrapper" ]
                [ article [ class "gallery-info" ]
                    [ h2 [] [ text gallery.title ]
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
    article [ class "gallery-image" ]
        [ div [ class "gallery-image-wrapper" ]
            [ img [ src image.url, title image.mouseoverText ] [] ]
        ]


footerSection : FooterSection -> Html Msg
footerSection item =
    div [ class "footer-column" ]
        [ article [ class "footer-column-wrapper" ]
            [ h3 [] [ text item.title ]
            , p [] [ text item.description ]
            , p []
                [ a [ href item.url ]
                    [ text item.link ]
                ]
            ]
        ]


footerSections : List FooterSection -> Html Msg
footerSections items =
    footer []
        [ section [ class "footer-wrapper" ] (List.map footerSection items)
        ]



-- UPDATE


type Msg
    = WindowWidth Int
    | ToggleDropdown Int Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
