#!/usr/bin/ruby

require 'rgen/model_builder'
require 'rgen/template_language'
require "BCM_mm"

TEMPLATES_DIR = "templates/"
OUTPUT_DIR="output/"

headers = <<ENDTAG
#include <kdl/frames.hpp>
#include <iostream>
#include <sstream>
ENDTAG

model1 = RGen::ModelBuilder.build(BCM_mm) do

        Codel :id => 'kdl-headers', :language => "c++", :code => headers
        Codel :id => 'sayhello', :language => "c++", :code => 'cout << "hello" << endl;'

        PrimitiveType :id => "brics.vector.x", :type => :uint32
        PrimitiveType :id => "brics.vector.y", :type => :uint32
        PrimitiveType :id => "brics.vector.z", :type => :uint32
        
        CompoundType :id => '3d_vector', :children => [ 'brics.vector.x',
                                                        'brics.vector.y',
                                                        'brics.vector.z' ]
                                                        
        
        Component( :id => "TestComponent1",
                   :descr => "Just a dummy test component",
                   :valid_mode => :periodic,
                   :header_codel => 'kdl-headers',
                   :trigger_codel => 'sayhello' ) do


                Property :id => "Prop1", :prop_type => "std::string", :value => '"default"', :descr => "A simple string property"
                Property :id => "Prop2", :prop_type => "int", :value => "32", :descr => "Just a integer property"

                InputPort :id => "CurPos", type => "KDL::Frame", :descr => "Current Position"
                Port :id => "DesVel", :dir => :out, :port_type => "std::vector<double>", :descr => "Desired Velocity"
                Port :id => "MaxVel", :dir => :out, :port_type => "double", :initial => "2.34", :descr => "Maximal Velocity"
                #Port :id => "Test", :dir => :inout, :port_type => "std::vector<double>"
        end
end

# this is how simple verification can look like
def verify_model(m)
        m.select { |c|
                if c.instance_of?(BCM_mm::Port)
                        return true
                else return false
                end }.ports.collect{ |p|
                if p.dir == :inout then
                        puts "WARN: port dir :inout not supported in RTT-2.0"
                        return false
                end
        }
        # m.header_codel.id, m.header_codel.language
end

## replace the abstract functions:
##      - send(portstr, value)
##	- recv(portstr, %ret)
def codel_to_rtt(c)
end

def codel_to_ros(c)
end

verify_model(model1)

#param = { :output_dir => "bla", :target => 'rtt1' }

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(BCM_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
tc.indentString="\t"
#tc.expand('Root::Root', :foreach => model1, :indent => 0)

# tc.expand('Root::Root_rtt_rosbuild', :foreach => model1.select { |o| o.class == BCM_mm::Component }, :indent => 0)
tc.expand('Root::Root_ros_rosbuild', :foreach => model1.select { |o| o.class == BCM_mm::Component }, :indent => 0)
