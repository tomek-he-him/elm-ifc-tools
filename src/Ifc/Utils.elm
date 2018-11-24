module Ifc.Utils exposing (withRelatedUniqueEntities, withUniqueEntity)

import Ifc.Entity exposing (UniqueEntity)
import Ifc.Guid exposing (Guid, randomGuid)
import Iso10303 exposing (Entity)
import Random exposing (Seed)


{-| Add a `UniqueEntity` with a randomly generated GUID to a list of IFC entities.

Example:

    ( entities, newSeed ) =
        ( [], initialSeed 0 )
            |> withUniqueEntity ifcProject { … }
            |> withUniqueEntity ifcBuilding { … }
            …

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


{-| Add a pair of unique entities with randomly generated GUIDs that need to reference each other.

Example:

    ( entities, newSeed ) =
        ( [], initialSeed 0 )
            |> withUniqueEntity ifcProject …
            |> withRelatedUniqueEntities ( ifcBuilding { … }, ifcWall { … } )
                (\(buildingEntity, wallEntity) ->
                    ifcRelContainedInSpatialStructure
                        { …
                        , relatedElements = [ wallEntity ]
                        , relatingStructure = buildingEntity
                        }
                )
            …

-}
withRelatedUniqueEntities : ( Guid -> Entity, Guid -> Entity ) -> (( Entity, Entity ) -> Guid -> Entity) -> ( List Entity, Seed ) -> ( List Entity, Seed )
withRelatedUniqueEntities ( entityWithGuid1, entityWithGuid2 ) entityWithRelations ( entities, currentSeed ) =
    let
        ( guid1, newSeed1 ) =
            Random.step randomGuid currentSeed

        ( guid2, newSeed2 ) =
            Random.step randomGuid newSeed1

        ( guid3, newSeed3 ) =
            Random.step randomGuid newSeed2

        entity1 =
            entityWithGuid1 guid1

        entity2 =
            entityWithGuid2 guid2
    in
    ( entity1
        :: entity2
        :: entityWithRelations ( entity1, entity2 ) guid3
        :: entities
    , newSeed3
    )
