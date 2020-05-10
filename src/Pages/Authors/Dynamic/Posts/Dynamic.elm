module Pages.Authors.Dynamic.Posts.Dynamic exposing
    ( Flags
    , Model
    , Msg
    , page
    )

import Html exposing (..)
import Html.Attributes as Attr exposing (class, href, rel)
import Page exposing (Document, Page)


type alias Flags =
    { param1 : String
    , param2 : String
    }


type alias Model =
    { authorId : String
    , postId : String
    }


type Msg
    = NoOp


page : Page Flags Model Msg
page =
    Page.element
        { init =
            \flags ->
                ( Model flags.param1 flags.param2
                , Cmd.none
                )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view = view
        }


view : Model -> Document msg
view model =
    { title = String.concat [ "Post ", model.postId, " by Author ", model.authorId ]
    , body =
        [ Html.node "link" [ rel "stylesheet", href "https://not-much-css.netlify.com/not-much.css" ] []
        , Html.node "link" [ rel "stylesheet", href "/main.css" ] []
        , h1 [ class "font--h1" ] [ text ("Post " ++ model.postId) ]
        , h3 [ class "font--h5" ] [ text ("Author: " ++ model.authorId) ]
        , p [] [ text "(but imagine an actual blog post here)" ]
        ]
    }
