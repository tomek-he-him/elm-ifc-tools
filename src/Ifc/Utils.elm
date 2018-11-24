module Ifc.Utils exposing (withDependentEntities, withRootEntity)

import Ifc.Entity exposing (UniqueEntity)
import Ifc.Guid exposing (Guid, randomGuid)
import Iso10303 exposing (Entity)
import List.Nonempty exposing (Nonempty)
import Random exposing (Seed)


{-| Functions in this module operate on a pair of values: a non-empty list of
entities and a random seed.
-}
type alias Entities =
    ( Nonempty Entity, Seed )


{-| Start building your list of `Entities` with a single unique entity. Most
often it’ll be `ifcProject` that’s required in any IFC model.

Example:

    ( entities, newSeed ) =
        initialSeed 0
            |> withRootEntity ifcProject { … }
            …
            |> toEntitiesAndSeed

-}
withRootEntity : UniqueEntity attributes -> attributes -> Seed -> Entities
withRootEntity uniqueEntity attributes seed =
    let
        ( guid, newSeed ) =
            Random.step randomGuid seed
    in
    ( List.Nonempty.fromElement (uniqueEntity attributes guid)
    , newSeed
    )


{-| Add a bunch of unique entities that need to reference another unique entity.

The factory function takes a rendered unique entity and returns a non-empty list
of unique entities. This means that you have access to the rendered entity while
building that list of entities. This makes it easy to build IFC relationships
like `ifcRelAggregates` or `ifcRelContainedInSpatialStructure`.

See the example on how to nest this function if you need access to more than one
entity.

Example:

    let
        ( entities, newSeed ) =
            ( [], initialSeed 0 )
                |> withRootEntity ifcProject …
                |> withDependentEntities buildingInProject
                |> withDependentEntities wallsInBuilding
                …
                |> asListAndSeed

        buildingInProject renderedProject =
            List.Nonempty.Nonempty building
                [ ifcRelAggregates
                    { relatingObject = renderedProject
                    , relatedObjects = [ building ]
                    , …
                    }
                ]

        wallsInBuilding renderedBuilding =
            List.Nonempty.fromElement material
                |> withDependentEntities
                    (\renderedMaterial ->
                        wall renderedBuilding renderedMaterial { … }
                            |> List.Nonempty.append (wall renderedBuilding renderedMaterial { … })
                            |> List.Nonempty.append (wall renderedBuilding renderedMaterial { … })
                    )

        building =
            ifcBuilding { … }

        wall renderedBuilding renderedMaterial =
            List.Nonempty.Nonempty

-}
withDependentEntities : ( Guid -> Entity, Guid -> Entity ) -> (( Entity, Entity ) -> Guid -> Entity) -> ( List Entity, Seed ) -> ( List Entity, Seed )
withDependentEntities ( entityWithGuid1, entityWithGuid2 ) entityWithRelations ( entities, currentSeed ) =
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
