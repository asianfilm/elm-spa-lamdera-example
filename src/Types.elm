module Types exposing (..)

import Browser
import Browser.Navigation as Nav
import Generated.Pages as Pages
import Global
import Url exposing (Url)


type alias FrontendModel =
    { key : Nav.Key
    , url : Url
    , global : Global.Model
    , page : Pages.Model
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Global Global.Msg
    | Page Pages.Msg
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
