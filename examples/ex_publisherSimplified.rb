require 'rgen/model_builder'
require 'bcm-regen'

headers = <<END
// custom headers
END

initState = <<END
//initialization state
END

serviceFunctionBody1 = <<END
//service Function body
//Your code comes here
END

serviceFunctionBody2 = <<END
//service Function body
//Your code comes here
END

operationCodelBody = <<END
\\operation body
END

RGen::ModelBuilder.build(Bcm) do
	Type( :name => "bool" )
	Type( :name => "std_msgs::String" )
	Type( :name => "std_msgs::Int32" )
  Type( :name => "testAzamatPkg::services::Request")
  Type( :name => "testAzamatPkg::services::Response")

	Codel( :name => 'test-headers', :lang => "c++", :code => headers )
	Codel( :name => 'init', :lang => "c++", :code => initState)
	Codel( :name => 'serviceFunction1', :lang => "c++", :code => serviceFunctionBody1)
	Codel( :name => 'serviceFunction2', :lang => "c++", :code => serviceFunctionBody2)
	Codel( :name => 'operationCodel', :lang => "c++", :code => operationCodelBody)

# How does interface relates to OperationType, 
# why not directly use it for the purpose of grouping operations
# the other issues will all these details concerning signature 
# and params will be exposed to a user, if so then how should be 
# made user-friendly
 
  Interface(:name => 'serviceAdder')
  Signature(:name =>'operationSign1', :retval => "bool") do
    Parameter( :typeid => "testAzamatPkg::services::Response", :name => "&res" )    
    Parameter( :typeid => "testAzamatPkg::services::Request", :name => "&req" )    
  end
  Signature(:name =>'operationSign2', :retval => "bool") do
    Parameter( :typeid => "std_msgs::String", :name => "&res" )    
    Parameter( :typeid => "std_msgs::Int32", :name => "&req" )    
  end
# why the hell we need operation type, don't get it
  OperationType(:name => 'operType_Command1', :sig => 'operationSign1')
  OperationType(:name => 'operType_Command2', :sig => 'operationSign2')


#Component definition
	Component( :name => "BCM_Publisher",
		   :descr => "A dummy publisher component",
		   :valid_mode => :periodic,
		   :trigger_freq => 1,
		   :header => 'test-headers',
		   :init => 'init', 
       :provides => "serviceAdder") do
    
    InputPort( :name => "fakeServicePortIn1", :typeid => "std_msgs::String", :size => 100, :callback => 'serviceFunction1' )
    InputPort( :name => "fakeServicePortIn2", :typeid => "std_msgs::String", :size => 100, :callback => 'serviceFunction2' )
    OutputPort( :name => "fakeServicePortOut3",  :typeid => "std_msgs::String", :size => 100 )

    ProvOperation( :name => "fakeServiceOperOut4",:body => 'operationCodel')

	end
end
