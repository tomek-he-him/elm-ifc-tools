module Ifc.Entity exposing (UniqueEntity, ifcBuilding, ifcProject, ifcRootEntity, ifcWall, withUniqueEntity)

import Ifc.Guid as Guid exposing (Guid, randomGuid)
import Ifc.Types exposing (label, optional)
import Iso10303 as Step exposing (Attribute, Entity, enum, float, list, null, referenceTo, string)
import Random exposing (Seed)


type alias UniqueEntity ifcClass attributes =
    attributes -> Guid -> IfcEntity ifcClass


{-| A utility that helps build a list of IFC entities with random GUIDs.

Example:

    ( entities, newSeed ) =
        ( [], initialSeed 0 )
            |> withUniqueEntity ifcProject
                { ownerHistory = Nothing
                , name = Nothing
                , description = Nothing
                , objectType = Nothing
                , longName = Nothing
                , phase = Nothing
                , representationContexts = Nothing
                , unitsInContext = Nothing
                }
            |> withUniqueEntity ifcBuilding
                { ownerHistory = Nothing
                , name = Nothing
                , description = Nothing
                , objectType = Nothing
                , objectPlacement = Nothing
                , representation = Nothing
                , longName = Nothing
                , compositionType = Nothing
                , elevationOfRefHeight = Nothing
                , elevationOfTerrain = Nothing
                , buildingAddress = Nothing
                }

-}
withUniqueEntity : UniqueEntity ifcClass attributes -> attributes -> ( List Entity, Seed ) -> ( List Entity, Seed )
withUniqueEntity uniqueEntity attributes ( entities, currentSeed ) =
    let
        ( guid, newSeed ) =
            Random.step randomGuid currentSeed
    in
    case uniqueEntity attributes guid of
        Tagged entity ->
            ( entity :: entities
            , newSeed
            )


{-| A Step.Entity tagged with a phantom type – a layer of type safety directly on top of low level Iso10303 tools
-}
type IfcEntity ifcClass
    = Tagged Entity


type IfcProject
    = IfcProject


type IfcOwnerHistory
    = IfcOwnerHistory


type IfcRepresentationContext
    = IfcRepresentationContext


ifcProject :
    UniqueEntity IfcProject
        { ownerHistory : Maybe (IfcEntity IfcOwnerHistory)
        , name : Maybe String
        , description : Maybe String
        , objectType : Maybe String
        , longName : Maybe String
        , phase : Maybe String
        , representationContexts : Maybe (List (IfcEntity IfcRepresentationContext))
        , unitsInContext : Maybe (IfcEntity IfcUnitAssignment)
        }
ifcProject attributes =
    ifcRootEntity "IfcProject"
        attributes
        [ optional label attributes.objectType
        , optional label attributes.longName
        , optional label attributes.phase
        , optional (list ifcEntity) attributes.representationContexts
        , optional ifcEntity attributes.unitsInContext
        ]


type IfcBuilding
    = IfcBuilding


type IfcObjectPlacement
    = IfcObjectPlacement


type IfcRepresentation
    = IfcRepresentation


type IfcCompositionType
    = IfcCompositionType


type IfcBuildingAddress
    = IfcBuildingAddress


ifcBuilding :
    UniqueEntity IfcBuilding
        { ownerHistory : Maybe (IfcEntity IfcOwnerHistory)
        , name : Maybe String
        , description : Maybe String
        , objectType : Maybe String
        , objectPlacement : Maybe (IfcEntity IfcObjectPlacement)
        , representation : Maybe (IfcEntity IfcRepresentation)
        , longName : Maybe String
        , compositionType : Maybe (IfcEntity IfcCompositionType)
        , elevationOfRefHeight : Maybe Float
        , elevationOfTerrain : Maybe Float
        , buildingAddress : Maybe (IfcEntity IfcBuildingAddress)
        }
ifcBuilding attributes =
    ifcRootEntity "IfcBuilding"
        attributes
        [ optional label attributes.objectType
        , optional ifcEntity attributes.objectPlacement
        , optional ifcEntity attributes.representation
        , optional label attributes.longName
        , optional ifcEntity attributes.compositionType
        , optional float attributes.elevationOfRefHeight
        , optional float attributes.elevationOfTerrain
        , optional ifcEntity attributes.buildingAddress
        ]


type IfcWall
    = IfcWall


ifcWall :
    UniqueEntity IfcWall
        { ownerHistory : Maybe (IfcEntity IfcOwnerHistory)
        , name : Maybe String
        , description : Maybe String
        , objectType : Maybe String
        , objectPlacement : Maybe (IfcEntity IfcObjectPlacement)
        , representation : Maybe (IfcEntity IfcRepresentation)
        , tag : Maybe String
        , predefinedType : Maybe String
        }
ifcWall attributes =
    ifcRootEntity "IfcWall"
        attributes
        [ optional label attributes.objectType
        , optional ifcEntity attributes.objectPlacement
        , optional ifcEntity attributes.representation
        , optional label attributes.tag
        , optional enum attributes.predefinedType
        ]


ifcProductDefinitionShape :
    { name : Maybe String
    , description : Maybe String
    , representations : List (IfcEntity IfcRepresentation)
    }
    -> Entity
ifcProductDefinitionShape { name, description, representations } =
    Step.entity "IfcProductDefinitionShape"
        [ optional label name
        , optional string description
        , list ifcEntity representations
        ]


type IfcUnitAssignment
    = IfcUnitAssignment


ifcUnitAssignment :
    { units : List (IfcEntity IfcUnit)
    }
    -> IfcEntity IfcUnitAssignment
ifcUnitAssignment { units } =
    Step.entity "IfcUnitAssignment"
        [ list ifcEntity units
        ]



-- INTERNALS --


ifcRootEntity : String -> { attributes | ownerHistory : Maybe (IfcEntity IfcOwnerHistory), name : Maybe String, description : Maybe String } -> List Attribute -> Guid -> IfcEntity ifcClass
ifcRootEntity entityName { ownerHistory, name, description } attributes guid =
    Tagged
        (Step.entity entityName <|
            string (Guid.toString guid)
                :: optional ifcEntity ownerHistory
                :: optional label name
                :: optional string description
                :: attributes
        )


ifcEntity : IfcEntity ifcClass -> Attribute
ifcEntity (Tagged entity) =
    referenceTo entity
