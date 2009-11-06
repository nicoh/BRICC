require 'rgen/metamodel_builder'

module RTT_mm
        extend RGen::MetamodelBuilder::ModuleExtension

        # basic ModelElement
        class ModelElement < RGen::MetamodelBuilder::MMBase
                has_attr 'name', String
        end

        # Component
        class Component < ModelElement
        end

        # Property
        class Property < ModelElement
                has_attr 'type', String
                has_attr 'init_val', String
                has_attr 'desc', String
        end

        Component.contains_many 'prop', Property, 'comp'
end
