require 'rgen/metamodel_builder'

module Typemodel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes

   PrimitiveTypeKind = Enum.new(:name => 'PrimitiveTypeKind', :literals =>[ :bool, :float64, :int8, :int16, :int32, :int64, :uint8, :uint16, :uint32, :uint64, :string, :float32 ])
end

class Typemodel::Type < RGen::MetamodelBuilder::MMBase
   has_attr 'name',  
end

class Typemodel::CompositeType < Typemodel::Type
end

class Typemodel::Subtype < RGen::MetamodelBuilder::MMBase
   has_attr 'field',  
   has_attr 'array_size', , :defaultValueLiteral => "1" 
end

class Typemodel::PrimitiveSubtype < RGen::MetamodelBuilder::MMMultiple(Typemodel::Subtype, Typemodel::Type)
   has_attr 'type', Typemodel::PrimitiveTypeKind 
end

class Typemodel::CompositeSubtype < Typemodel::Subtype
end


Typemodel::CompositeType.has_many 'subtypes', Typemodel::Subtype 
Typemodel::CompositeSubtype.has_one 'type', Typemodel::CompositeType, :lowerBound => 1 
