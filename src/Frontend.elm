module Frontend exposing (app)

import Browser exposing (Document)
import Browser.Navigation as Nav exposing (Key)
import Generated.Pages as Pages
import Generated.Route as Route exposing (Route)
import Global
import Html
import Lamdera
import Types exposing (..)
import Url exposing (Url)


app =
    Lamdera.frontend
        { init = init
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions
        , view = view
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : Url -> Key -> ( FrontendModel, Cmd FrontendMsg )
init url key =
    let
        ( global, globalCmd ) =
            Global.init url key

        ( page, pageCmd, pageGlobalCmd ) =
            Pages.init (fromUrl url) global
    in
    ( { url = url
      , key = key
      , global = global
      , page = page
      }
    , Cmd.batch
        [ Cmd.map Global globalCmd
        , Cmd.map Global pageGlobalCmd
        , Cmd.map Page pageCmd
        ]
    )


update : FrontendMsg -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
update msg model =
    case msg of
        LinkClicked (Browser.Internal url) ->
            ( model, Cmd.batch [ Nav.pushUrl model.key (Url.toString url) ] )

        LinkClicked (Browser.External href) ->
            ( model, Nav.load href )

        UrlChanged url ->
            let
                ( page, pageCmd, globalCmd ) =
                    Pages.init (fromUrl url) model.global
            in
            ( { model | url = url, page = page }
            , Cmd.batch
                [ Cmd.map Page pageCmd
                , Cmd.map Global globalCmd
                ]
            )

        Global globalMsg ->
            let
                ( global, globalCmd ) =
                    Global.update globalMsg model.global
            in
            ( { model | global = global }
            , Cmd.map Global globalCmd
            )

        Page pageMsg ->
            let
                ( page, pageCmd, pageGlobalCmd ) =
                    Pages.update pageMsg model.page model.global
            in
            ( { model | page = page }
            , Cmd.batch
                [ Cmd.map Page pageCmd
                , Cmd.map Global pageGlobalCmd
                ]
            )

        NoOpFrontendMsg ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateFromBackend msg model =
    ( model, Cmd.none )


subscriptions : FrontendModel -> Sub FrontendMsg
subscriptions model =
    Sub.batch
        [ model.global
            |> Global.subscriptions
            |> Sub.map Global
        , model.page
            |> (\page -> Pages.subscriptions page model.global)
            |> Sub.map Page
        ]


view : FrontendModel -> Browser.Document FrontendMsg
view model =
    let
        documentMap :
            (msg1 -> msg2)
            -> Document msg1
            -> Document msg2
        documentMap fn doc =
            { title = doc.title
            , body = List.map (Html.map fn) doc.body
            }
    in
    Global.view
        { page = Pages.view model.page model.global |> documentMap Page
        , global = model.global
        , toMsg = Global
        }


fromUrl : Url -> Route
fromUrl =
    Route.fromUrl >> Maybe.withDefault Route.NotFound
