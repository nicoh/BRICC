
require 'rgen/model_builder'
require 'bcm-regen'


headers = <<ENDTAG
#include <iostream>
#include <sstream>
ENDTAG

RGen::ModelBuilder.build(Bcm) do
        Codel :name => 'test-headers', :lang => "c++", :code => headers
        Codel :name => 'sayhello', :lang => "c++", :code => 'cout << "hello" << endl;'
        Codel :name => 'pos_update', :lang => "c++", :code => 'cout << "received pos: " << val << endl;'

        Type( :name => "int" )
        Type( :name => "std::string" )
        
        Component( :name => "TestComponent1",
                   :descr => "Just a dummy test component",
                   :valid_mode => :periodic,
                   :trigger_freq => 1,
                   :header => 'test-headers',
                   :trigger => 'sayhello' ) do
                
                Property :name => "Prop1", :typeid => "std::string", :default_val => "default", :descr => "A simple string property"
                Property :name => "Prop2", :typeid => "int", :default_val => "32", :descr => "Just a integer property"

                InputPort :name => "CurPos", :typeid => "int", :descr => "Current Position", :callback => 'pos_update'
                OutputPort :name => "MaxVel", :typeid => "std::string", :descr => "Maximal Velocity"
        end
end
