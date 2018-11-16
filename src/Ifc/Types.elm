module Ifc.Types exposing (label, optional)

import Iso10303 as Step exposing (Attribute, null)
import String.Extra exposing (ellipsisWith)


optional : (a -> Attribute) -> Maybe a -> Attribute
optional toAttribute maybeValue =
    maybeValue
        |> Maybe.map toAttribute
        |> Maybe.withDefault null


label : String -> Attribute
label value =
    value
        |> ellipsisWith 255 "…"
        |> Step.string
