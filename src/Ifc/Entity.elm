module Ifc.Entity exposing (UniqueEntity, ifcAxis2Placement3D, ifcBuilding, ifcCartesianPoint, ifcDirection, ifcExtrudedAreaSolid, ifcGeometricRepresentationContext, ifcProject, ifcRootEntity, ifcShapeRepresentation, ifcSiUnit, ifcUnitAssignment, ifcWall)

import Ifc.Guid as Guid exposing (Guid)
import Ifc.Types exposing (label, optional)
import Iso10303 as Step exposing (Attribute, Entity, default, enum, float, int, list, null, referenceTo, string)


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
    , representations : List Entity
    }
    -> Entity
ifcProductDefinitionShape { name, description, representations } =
    Step.entity "IfcProductDefinitionShape"
        [ optional label name
        , optional string description
        , list referenceTo representations
        ]


ifcUnitAssignment :
    { units : List Entity
    }
    -> Entity
ifcUnitAssignment { units } =
    Step.entity "IfcUnitAssignment"
        [ list referenceTo units
        ]


ifcSiUnit :
    { unitType : String
    , prefix : Maybe String
    , name : String
    }
    -> Entity
ifcSiUnit { unitType, prefix, name } =
    Step.entity "IfcSIUnit"
        [ default
        , string unitType
        , optional string prefix
        , string name
        ]


ifcShapeRepresentation :
    { contextOfItems : Entity
    , representationIdentifier : Maybe String
    , representationType : Maybe String
    , items : List Entity
    }
    -> Entity
ifcShapeRepresentation { contextOfItems, representationIdentifier, representationType, items } =
    Step.entity "IfcShapeRepresentation"
        [ referenceTo contextOfItems
        , optional label representationIdentifier
        , optional label representationType
        , list referenceTo items
        ]


ifcGeometricRepresentationContext :
    { contextIdentifier : Maybe String
    , contextType : Maybe String
    , coordinateSpaceDimension : Int
    , precision : Maybe Entity
    , worldCoordinateSystem : Entity
    , trueNorth : Maybe Entity
    }
    -> Entity
ifcGeometricRepresentationContext { contextIdentifier, contextType, coordinateSpaceDimension, precision, worldCoordinateSystem, trueNorth } =
    Step.entity "IfcGeometricRepresentationContext"
        [ optional label contextIdentifier
        , optional label contextType
        , int coordinateSpaceDimension
        , optional referenceTo precision
        , referenceTo worldCoordinateSystem
        , optional referenceTo trueNorth
        ]


ifcDirection :
    { directionRatios : List Float
    }
    -> Entity
ifcDirection { directionRatios } =
    Step.entity "IfcDirection"
        [ list float directionRatios
        ]


ifcAxis2Placement3D :
    { location : Entity
    , axis : Maybe Entity
    , refDirection : Maybe Entity
    }
    -> Entity
ifcAxis2Placement3D { location, axis, refDirection } =
    Step.entity "IfcAxis2Placement3D"
        [ referenceTo location
        , optional referenceTo axis
        , optional referenceTo refDirection
        ]


ifcCartesianPoint :
    { coordinates : List Float
    }
    -> Entity
ifcCartesianPoint { coordinates } =
    Step.entity "IfcCartesianPoint"
        [ list float coordinates
        ]


ifcExtrudedAreaSolid :
    { sweptArea : Entity
    , position : Maybe Entity
    , extrudedDirection : Entity
    , depth : Entity
    }
    -> Entity
ifcExtrudedAreaSolid { sweptArea, position, extrudedDirection, depth } =
    Step.entity "IfcExtrudedAreaSolid"
        [ referenceTo sweptArea
        , optional referenceTo position
        , referenceTo extrudedDirection
        , referenceTo depth
        ]


ifcRectangleProfileDef :
    { profileType : String
    , profileName : Maybe String
    , position : Maybe Entity
    , xDim : Float
    , yDim : Float
    }
    -> Entity
ifcRectangleProfileDef { profileType, profileName, position, xDim, yDim } =
    Step.entity "IfcRectangleProfileDef"
        [ string profileType
        , optional string profileName
        , optional referenceTo position
        , float xDim
        , float yDim
        ]


ifcRootEntity : String -> { a | ownerHistory : Maybe Entity, name : Maybe String, description : Maybe String } -> List Attribute -> Guid -> Entity
ifcRootEntity entityName { ownerHistory, name, description } attributes guid =
    Step.entity entityName <|
        string (Guid.toString guid)
            :: optional referenceTo ownerHistory
            :: optional label name
            :: optional string description
            :: attributes
