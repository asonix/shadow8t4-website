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
    | ProjectLink GalleryLink


type alias GalleryImage =
    { url : String
    , mouseoverText : String
    }


type alias GalleryProject =
    { url : String
    , mouseoverText : String
    , title : String
    , description : List String
    }


type alias GalleryLink =
    { url : String
    , mouseoverText : String
    , title : String
    , description : List String
    , links : List ( String, String )
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
                            [ NavLink "Facebook" "https://facebook.com/shadow8t3"
                            , NavLink "Mastodon" "https://asonix.dog/@shadow8t4"
                            , NavLink "YouTube" "https://www.youtube.com/channel/UCZAXVnn6i1hcgDjV93HPbzg"
                            , NavLink "Google+" "https://plus.google.com/u/2/118253409016956205819"
                            ]
                        )
                    , InitDropdown
                        "Project Links"
                        (initDropdowns
                            [ NavLink "Revival Survival" "/revival-survival"
                            , NavLink "So Bow-y Cute" "https://double-darling-duo-deluxe.itch.io/so-bow-y-cute"
                            , NavLink "Project Undercover Github" "https://github.tamu.edu/jrdoli/dream-machine"
                            , NavLink "Project Undercover WebGL" "/project-undercover"
                            , NavLink "Procedural City" "https://github.com/shadow8t4/ProceduralCity"
                            , NavLink "PSVR Github" "https://github.com/k4sr4/PublicSpeaking-VR"
                            , NavLink "PSVR Research Paper" "/assets/other/Public_Speaking_in_VR_Research_Paper.pdf"
                            ]
                        )
                    ]
            }
      , welcome = welcomeBanner "Werefox Software" "A portfolio site"
      , gallery =
            initGallery
                "Portfolio Gallery"
                "Here's just a few project's I've worked on either personally or through school."
                [ galleryLink
                    "projectundercover-guard.png"
                    "The guard's view in ProjectUndercover."
                    "ProjectUndercover - guard view"
                    [ "Project Undercover is a game about pretending to be an AI. Or at least -- that's part of it."
                        ++ " Players will compete against one another, with one side trying to blend in with a crowd"
                        ++ " of non-player characters, and the other side attempting to identify them. It takes place"
                        ++ " at a party, and the undercover players are agents trying to infiltrate and complete"
                        ++ " several missions before the guard, or overseer, catches them."
                    , "The overseer is limited"
                        ++ " by a set of cameras, and slowly receives information over the course of the game to"
                        ++ " help identify the agents, thus putting the heat on them."
                    , "This picture is from the perspective of one of the guard's cameras."
                    ]
                    [ ( "Github Link"
                      , "https://github.tamu.edu/jrdoli/dream-machine"
                      )
                    ]
                , galleryLink
                    "procedural-city.png"
                    "A picture of some output from ProceduralCity"
                    "Procedural City"
                    [ "In this project my partner, Jeremy Martin, and I presented a way of procedurally generating a basic city by"
                        ++ " creating an .obj mesh file using some given template meshes. The goal was that when given a"
                        ++ " user input population density and some template meshes, the program would output"
                        ++ " a resulting mesh of a procedurally generated “city” using the template"
                        ++ " meshes along with some defined rules. The program takes the input files and duplicates it at"
                        ++ " procedurally determined intersections, creating a basic city structure in the"
                        ++ " resulting output .obj mesh file."
                    , " Unfortunately, the program was unable to be fully"
                        ++ " completed before our deadline, and currently takes one input mesh file and duplicates it"
                        ++ " based on user-defined amounts of layers from a central point with user-defined spacing."
                    , "Specific documentation on how to operate the program is detailed on the respective github page."
                    ]
                    [ ( "Github Link"
                      , "https://github.com/shadow8t4/ProceduralCity"
                      )
                    ]
                , galleryLink
                    "public-speaking-vr.png"
                    "A Case Study on Public Speaking in Virtual Reality."
                    "Public Speaking in VR"
                    [ "In this project, and the resulting research paper, a group I was assigned in and I show the results of"
                        ++ " a case study on the effectiveness and realism of using Virtual Reality technology to simulate the"
                        ++ " experience of public speaking in an effort to practice one’s speech skills."
                    , "We used a Development"
                        ++ " Kit 2 version of the Oculus Rift and the Unity editor to create and run our simulation. In the"
                        ++ " simulation, we presented users a large classroom environment with a handful of characters to"
                        ++ " present a mock speech in front of. We provided the users with an Xbox game controller to allow"
                        ++ " for easier camera movement as well as a way to switch through the given slides in the mock presentation."
                    , "The resulting research paper from the case study and a link to the project's github page can be found"
                        ++ " below."
                    ]
                    [ ( "Github Link"
                      , "https://github.com/k4sr4/PublicSpeaking-VR"
                      )
                    , ( "Research Paper"
                      , "/assets/other/Public_Speaking_in_VR_Research_Paper.pdf"
                      )
                    ]
                , galleryLink
                    "projectundercover-spy.png"
                    "A spy's view in ProjectUndercover."
                    "Project Undercover - spy view"
                    [ "This is another picture from Project Undercover, this time from the perspective"
                        ++ " of a spy. In this picture, the spy is finishing a waving interaction with an AI spy."
                    ]
                    [ ( "Tamu Github Page Link"
                      , "https://github.tamu.edu/jrdoli/dream-machine"
                      )
                    , ( "In-browser Game Link"
                      , "/project-undercover"
                      )
                    ]
                , galleryLink
                    "revival-survival.png"
                    "A game where you save a soul you accidentally reaped as the grim reaper."
                    "Revival Survival"
                    [ "This was my entry for Chillennium 2017, a game jam held and hosted by students at Texas A&M."
                        ++ " I was in a group with 3 other students, and mostly worked on the sound design and"
                        ++ " game mechanics from the game. The game was made using Unity."
                    , "In Revival Survival, you play as the Grim Reaper in a 2D platformer that has to return"
                        ++ " the soul of someone they accidentally reaped. Throughout the game you are met with"
                        ++ " adversaries - hellhounds that want to eat the soul you reaped and paladins who wish to avenge"
                        ++ " that soul you reaped."
                    , "You can find a link to play this game in browser on the nav bar at the top of this page, as well"
                        ++ " as the link below. I've also provided a link to the itch.io submission page, where you"
                        ++ " can download a Windows standalone copy of the game."
                    ]
                    [ ( "itch.io Page Link"
                      , "https://d4-team.itch.io/revival-survival"
                      )
                    , ( "In-browser Game Link"
                      , "/revival-survival"
                      )
                    ]
                , galleryLink
                    "so-bow-y-cute.png"
                    "A game where you become cute."
                    "So Bow-y Cute"
                    [ "This was my entry for Chillennium 2016, a game jam held and hosted by students at Texas A&M."
                        ++ " This was my first time at the game jam and I was randomly patnered with one other person,"
                        ++ " who did the art for this game. Everything else was done by me. The game was made using Unity."
                    , "In So Bow-y Cute - When your parent decides to limit you cuteness potential by prohibiting all bows, you must"
                        ++ " rebel against their tyranny and become the cutest you possibly can. Be careful not to get"
                        ++ " caught! or else you're out of luck."
                    , "You can find a link to the itch.io page below."
                    ]
                    [ ( "itch.io Page Link"
                      , "https://double-darling-duo-deluxe.itch.io/so-bow-y-cute"
                      )
                    ]
                ]
      , footer =
            [ initFooterSection
                ""
                ""
                ""
                "/"
            , initFooterSection
                ""
                ""
                ""
                "/"
            , initFooterSection
                ""
                ""
                ""
                "/"
            ]
      }
    , Task.perform WindowWidth Window.width
    )


smallImagePath : String -> String
smallImagePath filename =
    "/assets/images/420/" ++ filename


fullImagePath : String -> String
fullImagePath filename =
    "/assets/images/full/" ++ filename


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


galleryProject : String -> String -> String -> List String -> GalleryItem
galleryProject url text title description =
    Project { url = url, mouseoverText = text, title = title, description = description }


galleryLink : String -> String -> String -> List String -> List ( String, String ) -> GalleryItem
galleryLink url text title description links =
    ProjectLink { url = url, mouseoverText = text, title = title, description = description, links = links }


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
                ([ class "button-wrapper" ]
                    ++ if config.state then
                        [ class "dropdown-active" ]
                       else
                        []
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
                        |> Array.map (div [ class "gallery-column" ] << List.map displayImage << List.reverse)
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
                    [ a [ href (fullImagePath image.url) ]
                        [ img [ src (smallImagePath image.url), title image.mouseoverText ] []
                        ]
                    ]
                ]

        Project project ->
            article [ class "gallery-image" ]
                [ div [ class "gallery-image-wrapper" ]
                    [ a [ href (fullImagePath project.url) ]
                        [ img [ src (smallImagePath project.url), title project.mouseoverText ] []
                        ]
                    , div [ class "gallery-image-info" ]
                        [ h4 [] [ text project.title ]
                        , div [] (List.map (\t -> p [] [ text t ]) project.description)
                        ]
                    ]
                ]

        ProjectLink projectlink ->
            article [ class "gallery-image" ]
                [ div [ class "gallery-image-wrapper" ]
                    [ a [ href (fullImagePath projectlink.url) ]
                        [ img [ src (smallImagePath projectlink.url), title projectlink.mouseoverText ] []
                        ]
                    , div [ class "gallery-image-info" ]
                        [ h4 [] [ text projectlink.title ]
                        , div [] (List.map (\t -> p [] [ text t ]) projectlink.description)
                        , p [] (List.map (\( t, url ) -> a [ href url ] [ text t ]) projectlink.links)
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
