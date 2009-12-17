require 'rgen/metamodel_builder'

module Type_mm
	extend RGen::MetamodelBuilder::ModuleExtension
        include RGen::MetamodelBuilder::DataTypes

	# basic ModelElement
	class AbstractType < RGen::MetamodelBuilder::MMBase
	end

        Enum.new "PrimitiveTypeKind", :literal => 
                [ :bool,
                  :int8, :uint8,
                  :int16, :uint16,
                  :int32, :uint32,
                  :int64, :uint64,
                  :float32, :float64,
                  :string, :time, :duration ]

        class PrimitiveType < AbstractType
                has_attr type, "PrimitiveTypeKind"
        end

        class CompositeType < AbstractType
                has_attr name
        end

	CompositeType.contains_many_uni 'children', AbstractType
end
