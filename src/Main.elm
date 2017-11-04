module Main exposing (main)

{-| This is the main module of the application.


# main function

@docs main

-}

import Html exposing (Attribute, Html, a, article, button, div, footer, h1, h2, h3, h4, header, img, li, nav, p, programWithFlags, section, span, text, ul)
import Html.Attributes exposing (class, href, rel, src, title)
import Html.Events exposing (onClick)
import Array exposing (Array)
import Dropdown exposing (ToggleEvent(..), drawer, dropdown, toggle)
import Window exposing (resizes, width)
import Task exposing (perform)


-- MAIN


{-| The main function of the application
-}
main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { flags : Flags
    , nav : Navigation
    , welcome : WelcomeBanner
    , gallery : Gallery
    , footer : List FooterSection
    }


type alias Navigation =
    { smallNav : Bool
    , showNav : Bool
    , navText : String
    , items : Array NavItem
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
    , images : List GalleryItem
    }


type GalleryItem
    = Image GalleryImage
    | Project GalleryProject


type alias GalleryImage =
    { url : String
    , mouseoverText : String
    }


type alias GalleryProject =
    { url : String
    , mouseoverText : String
    , title : String
    , description : String
    }


type alias FooterSection =
    { title : String
    , description : String
    , link : String
    , url : String
    }


type alias Flags =
    { mobile : Bool
    }



-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , nav =
            { showNav = False
            , smallNav = False
            , navText = "Navigation"
            , items =
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
            }
      , welcome = welcomeBanner "Welcome" "What are frogs tho"
      , gallery =
            initGallery
                "Gallery"
                "Here are some pictures I've taken"
                [ galleryProject
                    (imagePath "gallery01.jpg")
                    "Some mouseover text for your convenience"
                    "Image 1"
                    "Natani and Kathrine share an intimate moment with each other because they are both really gay except Natani is a boy who likes boys so that's a different gay"
                , galleryProject
                    (imagePath "gallery02.png")
                    "Another image with mouseover text"
                    "Image 2"
                    "Kathrine is an IT Professional"
                , galleryProject
                    (imagePath "gallery03.png")
                    "Mouseover text is neat, right?"
                    "Image 3"
                    "Kieth doesn't want to go streaking"
                , galleryProject
                    (imagePath "gallery04.png")
                    "Mouseover text is weird tho"
                    "Image 4"
                    "Natani relaxes in the water"
                , galleryProject
                    (imagePath "gallery05.png")
                    "I don't like mouseover text"
                    "Image 5"
                    "Flora chills out in some water"
                , galleryProject
                    (imagePath "gallery06.png")
                    "Mouseover text should go away"
                    "Image 6"
                    "Flora licks her leg seductively"
                , galleryProject
                    (imagePath "gallery07.jpg")
                    "Mouseover text is banned"
                    "Image 7"
                    "Ember is flying"
                , galleryProject
                    (imagePath "gallery08.png")
                    ""
                    "Image 8"
                    "Some dragon is being maybe lewd"
                , galleryProject
                    (imagePath "gallery09.jpg")
                    ""
                    "Image 9"
                    "Kathrine struggles with Christmas Lights"
                , galleryProject
                    (imagePath "gallery10.png")
                    "Okay I lied I like mouseover text"
                    "Image 10"
                    "Kathrine relaxes beneath a tree"
                , galleryProject
                    (imagePath "gallery11.png")
                    "See, mouseover text is good, actually."
                    "Image 11"
                    "Flora and a friend play some late-night videogames"
                , galleryProject
                    (imagePath "gallery12.png")
                    "Hey Ma, look! Mouseover text!"
                    "Image 12"
                    "Flora is an IT Professional"
                , galleryProject
                    (imagePath "gallery13.png")
                    "This text appears when you mouse over the image"
                    "Image 13"
                    "Flora stole Trace's boxers. Oh no!"
                , galleryProject
                    (imagePath "gallery14.png")
                    "Can you make mouseover text? Click here to find out!"
                    "Image 14"
                    "Raine, Kathrine, and Flora hang out at the beach"
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


imagePath : String -> String
imagePath filename =
    "/assets/images/" ++ filename


defaultDropdownConfig : DropdownConfig
defaultDropdownConfig =
    { name = "dropdown1"
    , event = OnClick
    , attribute = class "dropdown-active"
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


galleryImage : String -> String -> GalleryItem
galleryImage url text =
    Image { url = url, mouseoverText = text }


galleryProject : String -> String -> String -> String -> GalleryItem
galleryProject url text title description =
    Project { url = url, mouseoverText = text, title = title, description = description }


initGallery : String -> String -> List GalleryItem -> Gallery
initGallery title description images =
    { title = title, description = description, columns = 1, images = images }


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
    if model.flags.mobile || model.nav.smallNav then
        mobileHeaderbar model
    else
        desktopHeaderBar model


desktopHeaderBar : Model -> Html Msg
desktopHeaderBar model =
    header [ class "desktop-header" ]
        [ nav [ class "desktop-nav" ]
            [ div [ class "desktop-nav-wrapper", class "nav-wrapper" ]
                [ ul [] (Array.map navItem model.nav.items |> Array.toList)
                ]
            ]
        ]


mobileHeaderbar : Model -> Html Msg
mobileHeaderbar model =
    header [ class "mobile-header" ]
        [ div
            ([ class "show-nav", onClick (ToggleNav (not model.nav.showNav)) ]
                ++ if model.nav.showNav then
                    [ class "active" ]
                   else
                    []
            )
            [ p []
                [ text model.nav.navText
                , span [ class "carat" ] []
                ]
            ]
        , nav
            ([ class "mobile-nav" ]
                ++ if model.nav.showNav then
                    []
                   else
                    [ class "hidden" ]
            )
            [ div [ class "mobile-nav-wrapper", class "nav-wrapper" ]
                [ ul [] (Array.map navItem model.nav.items |> Array.toList)
                ]
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
        arr : Array (List GalleryItem)
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


displayImage : GalleryItem -> Html Msg
displayImage item =
    case item of
        Image image ->
            article [ class "gallery-image" ]
                [ div [ class "gallery-image-wrapper" ]
                    [ img [ src image.url, title image.mouseoverText ] []
                    ]
                ]

        Project project ->
            article [ class "gallery-image" ]
                [ div [ class "gallery-image-wrapper" ]
                    [ img [ src project.url, title project.mouseoverText ] []
                    , div [ class "gallery-image-info" ]
                        [ h4 [] [ text project.title ]
                        , p [] [ text project.description ]
                        ]
                    ]
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
    | ToggleNav Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowWidth x ->
            ( { model
                | gallery = updateGalleryWidth model.flags.mobile x model.gallery
                , nav = updateNavWidth x model.nav
              }
            , Cmd.none
            )

        ToggleDropdown index state ->
            ( { model | nav = updateDropdown index state model.nav }
            , Cmd.none
            )

        ToggleNav state ->
            ( { model | nav = toggleNav state model.nav }
            , Cmd.none
            )


toggleNav : Bool -> Navigation -> Navigation
toggleNav state nav =
    { nav | showNav = state }


updateGalleryWidth : Bool -> Int -> Gallery -> Gallery
updateGalleryWidth mobile width gallery =
    if mobile then
        gallery
    else if width < 632 then
        { gallery | columns = 1 }
    else if width < 932 then
        { gallery | columns = 2 }
    else
        { gallery | columns = 3 }


updateNavWidth : Int -> Navigation -> Navigation
updateNavWidth width nav =
    if width < 700 then
        { nav | smallNav = True }
    else
        { nav | smallNav = False, showNav = False }


updateDropdown : Int -> Bool -> Navigation -> Navigation
updateDropdown index state nav =
    case Array.get index nav.items of
        Just dropdown ->
            case dropdown of
                (Dropdown name config items) as dropdown ->
                    { nav | items = Array.set index (Dropdown name { config | state = state } items) nav.items }

                _ ->
                    nav

        Nothing ->
            nav



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes (\{ width } -> WindowWidth width)
