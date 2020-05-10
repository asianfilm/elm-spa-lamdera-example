module Pages.Top exposing (Flags, Model, Msg, page)

import Html exposing (div, img, node, text)
import Html.Attributes exposing (href, rel, src, style, width)
import Page exposing (Document, Page)


type alias Flags =
    ()


type alias Model =
    { message : String }


init : Model
init =
    { message = "Welcome to Lamdera!" }


type Msg
    = NoOp


page : Page Flags Model Msg
page =
    Page.sandbox
        { init = init
        , update = \_ model -> model
        , view = view
        }


view : Model -> Document Msg
view model =
    { title = "Homepage"
    , body =
        [ node "link" [ rel "stylesheet", href "https://not-much-css.netlify.com/not-much.css" ] []
        , node "link" [ rel "stylesheet", href "/main.css" ] []
        , div [ style "text-align" "center", style "padding-top" "40px" ]
            [ img [ src "https://lamdera.app/lamdera-logo-black.png", width 150 ] []
            , div
                [ style "font-family" "sans-serif"
                , style "padding-top" "40px"
                ]
                [ text model.message ]
            ]
        ]
    }
