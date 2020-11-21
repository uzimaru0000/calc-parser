port module Main exposing (..)

import Calc
import Platform
import Parser
import Html exposing (output)
import Json.Encode as JE

type alias Model =
    { source : String
    , ast : Result String Calc.AST
    , result : Maybe Float
    }

main : Program String Model ()
main =
    Platform.worker
        { init = init
        , update = \_ model -> (model, Cmd.none)
        , subscriptions = \_ -> Sub.none
        }

init : String -> (Model, Cmd ())
init str =
    let
        ast = Parser.run Calc.parser str |> Result.mapError Parser.deadEndsToString
        result = Result.toMaybe ast |> Maybe.map Calc.run
    in 
        ({ source = str
         , ast = ast
         , result = result
         }
        , JE.object
            [ ("source", JE.string str)
            , ("ast"
              , case ast of
                    Ok tree -> Calc.encoder tree
                    Err err -> JE.string err
              )
            , ("result", Maybe.map JE.float result |> Maybe.withDefault JE.null)
            ]
            |> output
        )

port output : JE.Value -> Cmd msg
