require 'rgen/metamodel_builder'

module BCM_type_mm
        extend RGen::MetamodelBuilder::ModuleExtension
        include RGen::MetamodelBuilder::DataTypes

        PrimitiveTypeKind = Enum.new(:literals => 
                                     [ :bool, :string, :float32, :float64,
                                       :uint8, :uint16, :uint32, :uint64,
                                       :int8, :int16, :int32, :int64 ])

        class AbstractType < RGen::MetamodelBuilder::MMBase
        end

        # Composite Type
        class CompositeType < AbstractType
                has_attr 'name'
        end

        # Abstract Subtype
        class AbstractSubtype < AbstractType
                has_attr 'name'
                has_attr 'array_size'
        end

        # PrimitiveSubtype
        class PrimitiveSubtype < AbstractSubtype
                has_attr 'typeid', PrimitiveTypeKind
        end

        # CompositeSubtype
        class CompositeSubtype < AbstractSubtype
        end
        
        CompositeType.contains_many_uni 'subtypes', AbstractSubtype
        CompositeSubtype.has_one 'typeid', CompositeType

end
