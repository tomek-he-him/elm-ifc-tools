module Ifc.Entity exposing (UniqueEntity, ifcBuilding, ifcProject, ifcRootEntity, ifcWall)

import Ifc.Guid as Guid exposing (Guid)
import Ifc.Types exposing (label, optional)
import Iso10303 as Step exposing (Attribute, Entity, enum, float, list, null, referenceTo, string)


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
    ifcRootEntity "IfcProject"
        attributes
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
    ifcRootEntity "IfcBuilding"
        attributes
        [ optional label attributes.objectType
        , optional referenceTo attributes.objectPlacement
        , optional referenceTo attributes.representation
        , optional label attributes.longName
        , optional referenceTo attributes.compositionType
        , optional float attributes.elevationOfRefHeight
        , optional float attributes.elevationOfTerrain
        , optional referenceTo attributes.buildingAddress
        ]


ifcWall :
    UniqueEntity
        { ownerHistory : Maybe Entity
        , name : Maybe String
        , description : Maybe String
        , objectType : Maybe String
        , objectPlacement : Maybe Entity
        , representation : Maybe Entity
        , tag : Maybe String
        , predefinedType : Maybe String
        }
ifcWall attributes =
    ifcRootEntity "IfcWall"
        attributes
        [ optional label attributes.objectType
        , optional referenceTo attributes.objectPlacement
        , optional referenceTo attributes.representation
        , optional label attributes.tag
        , optional enum attributes.predefinedType
        ]


ifcProductDefinitionShape :
    { name : Maybe String
    , description : Maybe String
    , representations : Maybe (List Entity)
    }
    -> Entity
ifcProductDefinitionShape { name, describe, representations } =
    Step.entity "IfcProductDefinitionShape"
        [ optional label name
        , optional string description
        , optional referenceTo representations
        ]


ifcRootEntity : String -> { a | ownerHistory : Maybe Entity, name : Maybe String, description : Maybe String } -> List Attribute -> Guid -> Entity
ifcRootEntity entityName { ownerHistory, name, description } attributes guid =
    Step.entity entityName <|
        string (Guid.toString guid)
            :: optional referenceTo ownerHistory
            :: optional label name
            :: optional string description
            :: attributes
