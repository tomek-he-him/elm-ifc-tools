module Ifc.Entity exposing (UniqueEntity, ifcBuilding, ifcProject, ifcRootEntity)

import Ifc.Guid as Guid exposing (Guid)
import Ifc.Types exposing (label, optional)
import Iso10303 as Step exposing (Attribute, Entity, float, list, null, referenceTo, string)


type alias UniqueEntity attributes =
    attributes -> Guid -> Entity


ifcProject :
    UniqueEntity
        { ownerHistory : Maybe Entity
        , name : Maybe String
        , description : Maybe String
        , objectType : Maybe String
        , longName : Maybe String
        , phase : Maybe String
        , representationContexts : Maybe (List Entity)
        , unitsInContext : Maybe Entity
        }
ifcProject attributes =
    ifcRootEntity attributes
        "IfcProject"
        [ optional label attributes.objectType
        , optional label attributes.longName
        , optional label attributes.phase
        , optional (list referenceTo) attributes.representationContexts
        , optional referenceTo attributes.unitsInContext
        ]


ifcBuilding :
    UniqueEntity
        { ownerHistory : Maybe Entity
        , name : Maybe String
        , description : Maybe String
        , objectType : Maybe String
        , objectPlacement : Maybe Entity
        , representation : Maybe Entity
        , longName : Maybe String
        , compositionType : Maybe Entity
        , elevationOfRefHeight : Maybe Float
        , elevationOfTerrain : Maybe Float
        , buildingAddress : Maybe Entity
        }
ifcBuilding attributes =
    ifcRootEntity attributes
        "IfcBuilding"
        [ optional label attributes.objectType
        , optional referenceTo attributes.objectPlacement
        , optional referenceTo attributes.representation
        , optional label attributes.longName
        , optional referenceTo attributes.compositionType
        , optional float attributes.elevationOfRefHeight
        , optional float attributes.elevationOfTerrain
        , optional referenceTo attributes.buildingAddress
        ]


ifcRootEntity : { a | ownerHistory : Maybe Entity, name : Maybe String, description : Maybe String } -> String -> List Attribute -> Guid -> Entity
ifcRootEntity { ownerHistory, name, description } entityName attributes guid =
    Step.entity entityName <|
        string (Guid.toString guid)
            :: optional referenceTo ownerHistory
            :: optional label name
            :: optional string description
            :: attributes
