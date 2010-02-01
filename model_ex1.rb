
require 'rgen/model_builder'
require 'bcm-regen'


headers = <<ENDTAG
#include <iostream>
#include <sstream>
ENDTAG

RGen::ModelBuilder.build(Bcm) do
        Codel :name => 'test-headers', :lang => "c++", :code => headers
        Codel :name => 'sayhello', :lang => "c++", :code => 'cout << "hello" << endl;'

        #PrimitiveType :name => "brics.vector.x", :type => :uint32
        #PrimitiveType :name => "brics.vector.y", :type => :uint32
        #PrimitiveType :name => "brics.vector.z", :type => :uint32
        
        #CompoundType :name => '3d_vector', :children => [ 'brics.vector.x',
        #                                                'brics.vector.y',
        #                                                'brics.vector.z' ]
                                            
        Type( :name => "int32" )
        Type( :name => "string" )
        
        Component( :name => "TestComponent1",
                   :descr => "Just a dummy test component",
                   :valid_mode => :periodic,
                   :trigger_freq => 1,
                   :header => 'test-headers',
                   :trigger => 'sayhello' ) do
                
                Property :name => "Prop1", :type => "string", :default_val => "default", :descr => "A simple string property"
                Property :name => "Prop2", :type => "int32", :default_val => "32", :descr => "Just a integer property"

                InputPort :name => "CurPos", :type => "int32", :descr => "Current Position"
                OutputPort :name => "MaxVel", :type => "string", :descr => "Maximal Velocity"
        end
end
