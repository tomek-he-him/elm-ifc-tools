module Tests.Ifc.Guid exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Ifc.Guid as Guid
import Random exposing (initialSeed)
import Regex
import Test exposing (..)


suite : Test
suite =
    describe "Ifc.Guid"
        [ describe "toString"
            [ fuzz int "produces a string of 22 characters" <|
                \seed ->
                    Random.step Guid.randomGuid (initialSeed seed)
                        |> Tuple.first
                        |> Guid.toString
                        |> String.length
                        |> Expect.equal 22
            , fuzz int "each character is within the IFC-specified range" <|
                \seed ->
                    Random.step Guid.randomGuid (initialSeed seed)
                        |> Tuple.first
                        |> Guid.toString
                        |> String.all
                            (\char ->
                                String.contains
                                    (String.fromChar char)
                                    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_$"
                            )
                        |> Expect.true "Expected all characters to conform with the IFC GUID base 64 encoding range."
            ]
        , describe "toUuid"
            [ fuzz int "produces a valid UUID v4 string" <|
                \seed ->
                    Random.step Guid.randomGuid (initialSeed seed)
                        |> Tuple.first
                        |> Guid.toUuid
                        |> Regex.contains uuidV4Regex
                        |> Expect.true "Matches pattern xxxxxxxx-xxxx-4xxx-[89ab]xxx-xxxxxxxxxxxx"
            ]
        ]


uuidV4Regex =
    Regex.fromString
        "^[\\da-f]{8}-[\\da-f]{4}-4[\\da-f]{3}-[89ab][\\da-f]{3}-[\\da-f]{12}$"
        |> Maybe.withDefault Regex.never
