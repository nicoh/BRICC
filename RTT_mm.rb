require 'rgen/metamodel_builder'
require 'rgen/serializer/xmi20_serializer'

def assert(*msg)
        raise "Assertion failed! #{msg}" unless yield if $DEBUG
end

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

pack = RTT_mm.ecore
assert pack.is_a?(RGen::ECore::EPackage)

File.open("RTT_mm.ecore","w") do |f|
        ser = RGen::Serializer::XMI20Serializer.new(f)
        ser.serialize(RTT_mm.ecore)
end
