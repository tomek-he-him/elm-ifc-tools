module Ifc.Entity exposing (ifcProject)

import Ifc.Guid as Guid exposing (Guid)
import Iso10303 as Step exposing (Attribute, Entity)


ifcProject : Guid -> List Attribute -> Entity
ifcProject guid attributes =
    Step.entity "IfcProject"
        (Step.string (Guid.toString guid) :: attributes)
