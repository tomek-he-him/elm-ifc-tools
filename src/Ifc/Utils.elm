module Ifc.Utils exposing (renderedWithSeed, withConnection, withInitialSeed, withUniqueEntities, withUniqueEntity)

import Ifc.Entity exposing (UniqueEntity)
import Ifc.Guid exposing (Guid, randomGuid)
import Iso10303 exposing (Entity)
import List.Nonempty exposing (Nonempty)
import Random exposing (Seed)


{-| Example:

    let
        ( entities, newSeed ) =
            connections
                |> withInitialSeed seed
                |> withUniqueEntity project
                |> withUniqueEntity building
                |> withUniqueEntities walls
                |> renderedWithSeed

        connections : Entity -> Entity -> List Entity -> Seed -> ( List Entity, Seed )
        connections renderedProject renderedBuilding renderedWalls seed =
            ( renderedProject
                :: renderedBuilding
                :: material
                ++ renderedWalls
            , seed
            )
            |> withConnection ifcRelAggregates
                { relatingObject = renderedProject
                , relatedObjects = [ renderedBuilding ]
                , …
                }
            |> withConnection ifcRelContainedInSpatialStructure
                { relatingStructure = renderedBuilding
                , relatedElements = renderedWalls
                , …
                }
            |> withConnection ifcRelAssociatesMaterial
                { relatingMaterial = material
                , relatedObjects = renderedWalls
                , …
                }

        project =
            ifcProject …

        building =
            ifcBuilding …

        walls =
            [ ifcWall …
            , ifcWall …
            , …
            ]

        material =
            ifcMaterial …

-}
withInitialSeed : Seed -> a -> ( a, Seed )
withInitialSeed seed connections =
    ( connections, seed )


withUniqueEntity : UniqueEntity -> ( Entity -> a, Seed ) -> ( a, Seed )
withUniqueEntity uniqueEntity ( connections, seed ) =
    let
        ( guid, newSeed ) =
            Random.step randomGuid seed
    in
    ( connections (uniqueEntity guid)
    , newSeed
    )


withUniqueEntities : List UniqueEntity -> ( List Entity -> a, Seed ) -> ( a, Seed )
withUniqueEntities uniqueEntities ( connections, seed ) =
    let
        ( entities, newSeed ) =
            List.foldl renderUniqueEntity ( [], seed ) uniqueEntities

        renderUniqueEntity uniqueEntity ( currentEntities, currentSeed ) =
            let
                ( guid, nextSeed ) =
                    Random.step randomGuid currentSeed
            in
            ( uniqueEntity guid :: currentEntities, nextSeed )
    in
    ( connections entities
    , newSeed
    )


renderedWithSeed : ( Seed -> a, Seed ) -> a
renderedWithSeed ( connections, seed ) =
    connections seed


withConnection : (attributes -> UniqueEntity) -> attributes -> ( List Entity, Seed ) -> ( List Entity, Seed )
withConnection entityFactory attributes ( entities, seed ) =
    let
        ( guid, newSeed ) =
            Random.step randomGuid seed
    in
    ( entityFactory attributes guid :: entities
    , newSeed
    )
