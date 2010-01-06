require 'rgen/metamodel_builder'
require 'BCM_type_mm'

module BCM_mm
        extend RGen::MetamodelBuilder::ModuleExtension
        include RGen::MetamodelBuilder::DataTypes

        # basic ModelElement
        class ModelElement < RGen::MetamodelBuilder::MMBase
                has_attr 'id'
                has_attr 'descr'
        end

        # OperationalModeKind
        OperationalModeKind = Enum.new(:literals => [ :periodic, :aperiodic, :any ])

        # Component
        class Component < ModelElement
                has_attr 'valid_mode', BCM_mm::OperationalModeKind, :defaultValueLiteral => :any
        end

        # Ports
        class Port < ModelElement
                has_attr 'size', Integer
        end

        class InputPort < Port
        end

        class OutputPort < Port
        end

        # Property
        class Property < ModelElement
                has_attr 'default_val'
        end

        # Operation
        class Parameter < ModelElement
        end

        class Signature < ModelElement
        end

        class OperationType < ModelElement
        end

        class Operation < ModelElement
        end

        # Command?

        # Interface
        class Interface < ModelElement
        end

        # Code, opaque code inserted somewhere
        class Codel < ModelElement
                has_attr 'language'
                has_attr 'code'
        end


        Component.contains_many 'props', Property, 'comp'
        Component.contains_many 'ports', Port, 'comp'
        Component.contains_many 'ops', Operation, 'comp'
        Component.many_to_many 'provides', Interface, 'implemeters'
        Component.many_to_many 'requires', Interface, 'requirerers'
        Component.has_one 'valid_mode', OperationalModeKind
        Component.has_one 'header_codel', Codel
        Component.has_one 'initial_codel', Codel
        Component.has_one 'trigger_codel', Codel
        Component.has_one 'final_codel', Codel

        Interface.has_many 'optypes', OperationType
        Port.has_one 'type', AbstractType, :lowerBound => 1
        InputPort.has_one 'callback', Codel

        Property.has_one 'type', AbstractType, :lowerBound => 1

        Parameter.has_one 'type', AbstractType, :lowerBound => 1
        Signature.contains_many 'parameters', Parameter, 'sig'
        Signature.has_one 'retval', AbstractType
        OperationType.has_one 'sig', Signature, :lowerBound => 1
        Operation.one_to_many 'op_type', OperationType, 'op_inst', :lowerBound => 1
        Operation.has_one 'body', Codel
end
