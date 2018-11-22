module Ifc.Utils exposing (withUniqueEntity)

import Ifc.Entity exposing (UniqueEntity)
import Ifc.Guid exposing (Guid, randomGuid)
import Iso10303 exposing (Entity)
import Random exposing (Seed)


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
withUniqueEntity : UniqueEntity attributes -> attributes -> ( List Entity, Seed ) -> ( List Entity, Seed )
withUniqueEntity uniqueEntity attributes ( entities, currentSeed ) =
    let
        ( guid, newSeed ) =
            Random.step randomGuid currentSeed
    in
    ( uniqueEntity attributes guid :: entities
    , newSeed
    )
