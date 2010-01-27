module BCM_type_mm

        extend RGen::MetamodelBuilder::ModuleExtension
        include RGen::MetamodelBuilder::DataTypes

        PrimitiveTypeKind = Enum.new(:literals => 
                                     [ :bool, :string, :float32, :float64,
                                       :uint8, :uint16, :uint32, :uint64,
                                       :int8, :int16, :int32, :int64 ])
        

        # Base Type
        class Type < RGen::MetamodelBuilder::MMBase
                has_attr 'id', String
        end
        
        class PrimitveType < Type
                has_attr 'type', PrimitiveTypeKind
        end

        class CompoundType < Type
        end

        CompoundType.has_many 'members', Type
end
