module BCM_types
        extend RGen::MetamodelBuilder::ModuleExtension
        include RGen::MetamodelBuilder::DataTypes

        # Abstract Base Type
        class AbstractType < RGen::MetamodelBuilder::MMBase
                has_attr 'id'
        end

        # Primitive Types
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

        # NamedType
        class NamedType
                has_attr 'name', String
        end
        
        # Compound Type
        class Type < AbstractType
        end

        NamedType.has_one 'type' AbstractType, :lowerBound => 1
        Type.contains_many 'members', AbstractType
end
