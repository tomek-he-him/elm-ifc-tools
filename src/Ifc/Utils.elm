module Ifc.Utils exposing (withUniqueEntity)

import Ifc.Entity exposing (UniqueEntity)
import Ifc.Guid exposing (Guid, randomGuid)
import Iso10303 exposing (Entity)
import Random exposing (Seed)


{-| A utility that helps build a list of IFC entities with random GUIDs.

Example:

    ( entities, ( _, newSeed ) ) =
        ( []
        , Random.step Ifc.Guid.randomGuid (initialSeed 0)
        )
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
withUniqueEntity : UniqueEntity attributes -> attributes -> ( List Entity, ( Guid, Seed ) ) -> ( List Entity, ( Guid, Seed ) )
withUniqueEntity uniqueEntity attributes ( entities, ( guid, currentSeed ) ) =
    ( uniqueEntity attributes guid :: entities
    , Random.step randomGuid currentSeed
    )
