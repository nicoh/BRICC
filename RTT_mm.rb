require 'rgen/metamodel_builder'

module RTT_mm
	extend RGen::MetamodelBuilder::ModuleExtension

	# basic ModelElement
	class ModelElement < RGen::MetamodelBuilder::MMBase
	end

	# Component
	class Component < ModelElement
		has_attr 'descr'
		has_attr 'comp_name'
	end

	# Method
	class Method < ModelElement
		has_attr 'name'
		has_attr 'retval'
	end

	# Port
	class Port < ModelElement
		has_attr 'name'
		has_attr 'port_type'
	end

	class InputPort < Port
	end

	class OutputPort < Port
	end

	# Property
	class Property < ModelElement
		has_attr 'name'
		has_attr 'prop_type'
		has_attr 'initial'
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
end
