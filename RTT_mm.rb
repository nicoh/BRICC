require 'rgen/metamodel_builder'

module RTT_mm
        extend RGen::MetamodelBuilder::ModuleExtension
        include RGen::MetamodelBuilder::DataTypes

        # basic ModelElement
        class ModelElement < RGen::MetamodelBuilder::MMBase
        end

        # Component
        class Component < ModelElement
                has_attr 'desc'
                has_attr 'comp_name'
        end

        # Method
        class Method < ModelElement
                has_attr 'name'
                has_attr 'retval'
        end

        # PortDirKind
        PortDirKind = Enum.new(:literals => [ :in, :out, :inout ])

        # Port
        class Port < ModelElement
                has_attr 'name'
                has_attr 'port_type'
                has_attr 'desc'
                has_attr 'initial'
                has_attr 'size'
                has_attr 'dir', PortDirKind
        end

        # Property
        class Property < ModelElement
                has_attr 'name'
                has_attr 'prop_type'
                has_attr 'value'
                has_attr 'desc'
        end

        # Code, opaque code inserted somewhere
        class Codel < ModelElement
                has_attr 'name'
                has_attr 'language'
                has_attr 'is_stateless', Boolean
                has_attr 'code'
        end

        Component.contains_many 'props', Property, 'comp'
        Component.contains_many 'ports', Port, 'comp'
        Component.has_one 'header_codel', Codel
        Component.has_one 'initial_codel', Codel
        Component.has_one 'trigger_codel', Codel
        Component.has_one 'final_codel', Codel
end
