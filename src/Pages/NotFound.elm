module Pages.NotFound exposing
    ( Flags
    , Model
    , Msg
    , page
    )

import Html exposing (..)
import Html.Attributes as Attr exposing (class, href, rel)
import Page exposing (Document, Page)


type alias Flags =
    ()


type alias Model =
    {}


init : Model
init =
    {}


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
view _ =
    { title = "NotFound"
    , body =
        [ Html.node "link" [ rel "stylesheet", href "https://not-much-css.netlify.com/not-much.css" ] []
        , Html.node "link" [ rel "stylesheet", href "/main.css" ] []
        , h1 [ class "font--h1" ] [ text "Page not found..." ]
        ]
    }
