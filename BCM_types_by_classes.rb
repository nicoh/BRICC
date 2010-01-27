module BCM_mm
        extend RGen::MetamodelBuilder::ModuleExtension
        include RGen::MetamodelBuilder::DataTypes

        
        # Type system
        class AbstractType < RGen::MetamodelBuilder::MMBase
                has_attr 'id'
        end

        class Bool < AbstractType
        end
        
        class UInt8 < AbstractType
        end

        class UInt16 < AbstractType
        end

        class UInt32 < AbstractType
        end

        class UInt64 < AbstractType
        end

        class Int8 < AbstractType
        end

        class Int16 < AbstractType
        end

        class Int32 < AbstractType
        end

        class Int64 < AbstractType
        end

        class Float32 < AbstractType
        end

        class Float64 < AbstractType
        end

        class String < AbstractType
        end
        
        class CompoundType < AbstractType
        end

        CompoundType.has_many 'children', AbstractType
end
