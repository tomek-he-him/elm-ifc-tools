module Ifc.Guid exposing (Guid, randomGuid, toString, toUuid)

import Array
import Random exposing (Generator, map)
import Random.Extra exposing (andMap)


{-| The most convenient representation of binary data for working with both base
16 encoding and base 64 encoding.

Every base 16 digit represents 4 bits and every base 64 digit represents 6 bits.
The lowest common denominator of 4 and 6 is 2. Therefore, the most convenient
representation of binary data to work with both UUIDs (base 16) and IFC GUIDs
(base 64) seems to be just a pair of bits.

-}
type HalfNibble
    = HalfNibble Bool Bool


{-| An opaque type holding random binary data contained in a UUID v4.
-}
type Guid
    = Guid HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble HalfNibble


{-| Convert a Guid to an IFC-compliant GIUD string
-}
toString : Guid -> String
toString (Guid halfNibble1 halfNibble2 halfNibble3 halfNibble4 halfNibble5 halfNibble6 halfNibble7 halfNibble8 halfNibble9 halfNibble10 halfNibble11 halfNibble12 halfNibble13 halfNibble14 halfNibble15 halfNibble16 halfNibble17 halfNibble18 halfNibble19 halfNibble20 halfNibble21 halfNibble22 halfNibble23 halfNibble24 halfNibble27 halfNibble28 halfNibble29 halfNibble30 halfNibble31 halfNibble32 halfNibble34 halfNibble35 halfNibble36 halfNibble37 halfNibble38 halfNibble39 halfNibble40 halfNibble41 halfNibble42 halfNibble43 halfNibble44 halfNibble45 halfNibble46 halfNibble47 halfNibble48 halfNibble49 halfNibble50 halfNibble51 halfNibble52 halfNibble53 halfNibble54 halfNibble55 halfNibble56 halfNibble57 halfNibble58 halfNibble59 halfNibble60 halfNibble61 halfNibble62 halfNibble63 halfNibble64) =
    String.fromList <|
        base64Digit halfNibble1 halfNibble2 halfNibble3
            :: base64Digit halfNibble4 halfNibble5 halfNibble6
            :: base64Digit halfNibble7 halfNibble8 halfNibble9
            :: base64Digit halfNibble10 halfNibble11 halfNibble12
            :: base64Digit halfNibble13 halfNibble14 halfNibble15
            :: base64Digit halfNibble16 halfNibble17 halfNibble18
            :: base64Digit halfNibble19 halfNibble20 halfNibble21
            :: base64Digit halfNibble22 halfNibble23 halfNibble24
            :: base64Digit constantHalfNibble25 constantHalfNibble26 halfNibble27
            :: base64Digit halfNibble28 halfNibble29 halfNibble30
            :: base64Digit halfNibble31 halfNibble32 constantHalfNibble33
            :: base64Digit halfNibble34 halfNibble35 halfNibble36
            :: base64Digit halfNibble37 halfNibble38 halfNibble39
            :: base64Digit halfNibble40 halfNibble41 halfNibble42
            :: base64Digit halfNibble43 halfNibble44 halfNibble45
            :: base64Digit halfNibble46 halfNibble47 halfNibble48
            :: base64Digit halfNibble49 halfNibble50 halfNibble51
            :: base64Digit halfNibble52 halfNibble53 halfNibble54
            :: base64Digit halfNibble55 halfNibble56 halfNibble57
            :: base64Digit halfNibble58 halfNibble59 halfNibble60
            :: base64Digit halfNibble61 halfNibble62 halfNibble63
            :: base64Digit halfNibble64
                (HalfNibble False False)
                (HalfNibble False False)
            :: []


base64Digit : HalfNibble -> HalfNibble -> HalfNibble -> Char
base64Digit (HalfNibble bit1 bit2) (HalfNibble bit3 bit4) (HalfNibble bit5 bit6) =
    let
        number =
            binaryComponent 32 bit1
                + binaryComponent 16 bit2
                + binaryComponent 8 bit3
                + binaryComponent 4 bit4
                + binaryComponent 2 bit5
                + binaryComponent 1 bit6
    in
    Array.get number base64Characters
        |> Maybe.withDefault '?'


base64Characters =
    Array.fromList
        [ '0'
        , '1'
        , '2'
        , '3'
        , '4'
        , '5'
        , '6'
        , '7'
        , '8'
        , '9'
        , 'A'
        , 'B'
        , 'C'
        , 'D'
        , 'E'
        , 'F'
        , 'G'
        , 'H'
        , 'I'
        , 'J'
        , 'K'
        , 'L'
        , 'M'
        , 'N'
        , 'O'
        , 'P'
        , 'Q'
        , 'R'
        , 'S'
        , 'T'
        , 'U'
        , 'V'
        , 'W'
        , 'X'
        , 'Y'
        , 'Z'
        , 'a'
        , 'b'
        , 'c'
        , 'd'
        , 'e'
        , 'f'
        , 'g'
        , 'h'
        , 'i'
        , 'j'
        , 'k'
        , 'l'
        , 'm'
        , 'n'
        , 'o'
        , 'p'
        , 'q'
        , 'r'
        , 's'
        , 't'
        , 'u'
        , 'v'
        , 'w'
        , 'x'
        , 'y'
        , 'z'
        , '_'
        , '$'
        ]


{-| Convert a Guid value to a UUID v4 compliant with RFC 4122
and ISO/IEC 9834-8:2004.
-}
toUuid : Guid -> String
toUuid (Guid halfNibble1 halfNibble2 halfNibble3 halfNibble4 halfNibble5 halfNibble6 halfNibble7 halfNibble8 halfNibble9 halfNibble10 halfNibble11 halfNibble12 halfNibble13 halfNibble14 halfNibble15 halfNibble16 halfNibble17 halfNibble18 halfNibble19 halfNibble20 halfNibble21 halfNibble22 halfNibble23 halfNibble24 halfNibble27 halfNibble28 halfNibble29 halfNibble30 halfNibble31 halfNibble32 halfNibble34 halfNibble35 halfNibble36 halfNibble37 halfNibble38 halfNibble39 halfNibble40 halfNibble41 halfNibble42 halfNibble43 halfNibble44 halfNibble45 halfNibble46 halfNibble47 halfNibble48 halfNibble49 halfNibble50 halfNibble51 halfNibble52 halfNibble53 halfNibble54 halfNibble55 halfNibble56 halfNibble57 halfNibble58 halfNibble59 halfNibble60 halfNibble61 halfNibble62 halfNibble63 halfNibble64) =
    String.fromList <|
        base16Digit halfNibble1 halfNibble2
            :: base16Digit halfNibble3 halfNibble4
            :: base16Digit halfNibble5 halfNibble6
            :: base16Digit halfNibble7 halfNibble8
            :: base16Digit halfNibble9 halfNibble10
            :: base16Digit halfNibble11 halfNibble12
            :: base16Digit halfNibble13 halfNibble14
            :: base16Digit halfNibble15 halfNibble16
            :: '-'
            :: base16Digit halfNibble17 halfNibble18
            :: base16Digit halfNibble19 halfNibble20
            :: base16Digit halfNibble21 halfNibble22
            :: base16Digit halfNibble23 halfNibble24
            :: '-'
            :: base16Digit constantHalfNibble25 constantHalfNibble26
            :: base16Digit halfNibble27 halfNibble28
            :: base16Digit halfNibble29 halfNibble30
            :: base16Digit halfNibble31 halfNibble32
            :: '-'
            :: base16Digit constantHalfNibble33 halfNibble34
            :: base16Digit halfNibble35 halfNibble36
            :: base16Digit halfNibble37 halfNibble38
            :: base16Digit halfNibble39 halfNibble40
            :: '-'
            :: base16Digit halfNibble41 halfNibble42
            :: base16Digit halfNibble43 halfNibble44
            :: base16Digit halfNibble45 halfNibble46
            :: base16Digit halfNibble47 halfNibble48
            :: base16Digit halfNibble49 halfNibble50
            :: base16Digit halfNibble51 halfNibble52
            :: base16Digit halfNibble53 halfNibble54
            :: base16Digit halfNibble55 halfNibble56
            :: base16Digit halfNibble57 halfNibble58
            :: base16Digit halfNibble59 halfNibble60
            :: base16Digit halfNibble61 halfNibble62
            :: base16Digit halfNibble63 halfNibble64
            :: []


base16Digit : HalfNibble -> HalfNibble -> Char
base16Digit (HalfNibble bit1 bit2) (HalfNibble bit3 bit4) =
    let
        number =
            binaryComponent 8 bit1
                + binaryComponent 4 bit2
                + binaryComponent 2 bit3
                + binaryComponent 1 bit4
    in
    Array.get number base16Characters
        |> Maybe.withDefault '?'


base16Characters =
    Array.fromList
        [ '0'
        , '1'
        , '2'
        , '3'
        , '4'
        , '5'
        , '6'
        , '7'
        , '8'
        , '9'
        , 'a'
        , 'b'
        , 'c'
        , 'd'
        , 'e'
        , 'f'
        ]


binaryComponent : Int -> Bool -> Int
binaryComponent multiplier bit =
    if bit then
        multiplier

    else
        0


{-| A generator for Guid values based on UUID v4.
-}
randomGuid : Generator Guid
randomGuid =
    Random.constant Guid
        -- First group (8 hex digits)
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        -- Second group (4 hex digits)
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        -- Third group (4 hex digits. The first one is always '4' and
        -- corresponds to constantHalfNibble25 and constantHalfNibble26.)
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        -- Fourth group (4 hex digits. The first one is always '8', '9', 'a' or
        -- 'b' and corresponds to constantHalfNibble33)
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        -- Fifth group (12 hex digits)
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble
        |> andMap halfNibble


halfNibble : Generator HalfNibble
halfNibble =
    Random.map2 HalfNibble
        Random.Extra.bool
        Random.Extra.bool


constantHalfNibble25 : HalfNibble
constantHalfNibble25 =
    HalfNibble False True


constantHalfNibble26 : HalfNibble
constantHalfNibble26 =
    HalfNibble False False


constantHalfNibble33 : HalfNibble
constantHalfNibble33 =
    HalfNibble True False
