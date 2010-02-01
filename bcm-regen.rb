require 'rgen/metamodel_builder'

module Bcm
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes

   OperationalModeKind = Enum.new(:name => 'OperationalModeKind', :literals =>[ :periodic, :aperiodic, :any ])
   PrimitiveTypeKind = Enum.new(:name => 'PrimitiveTypeKind', :literals =>[ :bool, :int8, :int16, :int32, :int64, :uint8, :uint16, :uint32, :uint64, :float32, :float64, :string ])
end

class Bcm::BCMObject < RGen::MetamodelBuilder::MMBase
   has_attr 'id', String 
   has_attr 'descr', String 
end

class Bcm::Component < Bcm::BCMObject
   has_attr 'valid_mode', Bcm::OperationalModeKind 
   has_attr 'trigger_freq', Integer 
end

class Bcm::Codel < Bcm::BCMObject
   has_attr 'code', String 
   has_attr 'lang', String 
end

class Bcm::Property < Bcm::BCMObject
   has_attr 'default_val', String 
end

class Bcm::Port < Bcm::BCMObject
   has_attr 'size', Integer 
end

class Bcm::Type < RGen::MetamodelBuilder::MMBase
   has_attr 'id', String 
end

class Bcm::InputPort < Bcm::Port
end

class Bcm::OutputPort < Bcm::Port
end

class Bcm::OperationType < RGen::MetamodelBuilder::MMBase
end

class Bcm::Signature < RGen::MetamodelBuilder::MMBase
end

class Bcm::Parameter < RGen::MetamodelBuilder::MMBase
   has_attr 'name', String 
end

class Bcm::Operation < Bcm::BCMObject
end

class Bcm::ProvOperation < Bcm::Operation
end

class Bcm::Interface < RGen::MetamodelBuilder::MMBase
end

class Bcm::PortConnection < RGen::MetamodelBuilder::MMBase
end

class Bcm::ReqOperation < Bcm::Operation
end

class Bcm::OperationConnection < RGen::MetamodelBuilder::MMBase
end

class Bcm::IFConnection < RGen::MetamodelBuilder::MMBase
end

class Bcm::Annotation < RGen::MetamodelBuilder::MMBase
   has_attr 'value', String 
end


Bcm::Component.has_many 'child', Bcm::Component 
Bcm::Component.has_one 'trigger', Bcm::Codel 
Bcm::Component.has_one 'header', Bcm::Codel 
Bcm::Component.has_one 'final', Bcm::Codel 
Bcm::Component.has_one 'init', Bcm::Codel 
Bcm::Component.contains_many_uni 'props', Bcm::Property 
Bcm::Component.contains_many 'ports', Bcm::Port, 'comp', :opposite_lowerBound => 1 
Bcm::Component.contains_many_uni 'ops', Bcm::Operation 
Bcm::Component.has_many 'provides', Bcm::Interface 
Bcm::Component.has_many 'requires', Bcm::Interface 
Bcm::BCMObject.has_many 'annotations', Bcm::Annotation 
Bcm::Property.has_one 'type', Bcm::Type, :lowerBound => 1 
Bcm::Port.has_one 'type', Bcm::Type, :lowerBound => 1 
Bcm::InputPort.has_one 'callback', Bcm::Codel 
Bcm::OperationType.has_one 'sig', Bcm::Signature, :lowerBound => 1 
Bcm::OperationType.many_to_one 'interface', Bcm::Interface, 'ops' 
Bcm::Signature.contains_many_uni 'params', Bcm::Parameter 
Bcm::Signature.has_one 'retval', Bcm::Type 
Bcm::Parameter.has_one 'type', Bcm::Type, :lowerBound => 1 
Bcm::ProvOperation.has_one 'implements', Bcm::OperationType, :lowerBound => 1 
Bcm::ProvOperation.has_one 'body', Bcm::Codel 
Bcm::Interface.has_one 'super_if', Bcm::Interface 
Bcm::PortConnection.has_one 'src', Bcm::OutputPort, :lowerBound => 1 
Bcm::PortConnection.has_one 'tgt', Bcm::InputPort, :lowerBound => 1 
Bcm::ReqOperation.has_one 'requires', Bcm::OperationType, :lowerBound => 1 
Bcm::OperationConnection.has_one 'tgt', Bcm::ProvOperation, :lowerBound => 1 
Bcm::OperationConnection.has_one 'src', Bcm::ReqOperation, :lowerBound => 1 
Bcm::IFConnection.has_one 'prov', Bcm::Interface, :lowerBound => 1 
Bcm::IFConnection.has_one 'req', Bcm::Interface, :lowerBound => 1 
