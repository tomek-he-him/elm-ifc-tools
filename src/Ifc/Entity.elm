module Ifc.Entity exposing (ifcProject)

import Ifc.Guid as Guid exposing (Guid)
import Ifc.Types exposing (label, optional)
import Iso10303 as Step exposing (Attribute, Entity, list, null, referenceTo, string)


ifcProject :
    { guid : Guid
    , ownerHistory : Maybe Entity
    , name : Maybe String
    , description : Maybe String
    , objectType : Maybe String
    , longName : Maybe String
    , phase : Maybe String
    , representationContexts : Maybe (List Entity)
    , unitsInContext : Maybe Entity
    }
    -> Entity
ifcProject { guid, ownerHistory, name, description, objectType, longName, phase, representationContexts, unitsInContext } =
    Step.entity "IfcProject"
        [ string (Guid.toString guid)
        , optional referenceTo ownerHistory
        , optional label name
        , optional string description
        , optional label objectType
        , optional label longName
        , optional label phase
        , optional (list referenceTo) representationContexts
        , optional referenceTo unitsInContext
        ]
