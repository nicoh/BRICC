#!/usr/bin/ruby

require 'rgen/template_language'
require 'rgen/model_builder'
require 'rgen/template_language'
require "RTT_mm"

TEMPLATES_DIR = "templates/"
OUTPUT_DIR="output/"

headers = <<ENDTAG
#include <kdl/frames.hpp>
#include <iostream>
#include <sstream>
ENDTAG

model1 = RGen::ModelBuilder.build(RTT_mm) do

        Codel :name => 'kdl-headers', :language => "C++", :code => headers
        Codel :name => 'sayhello', :language => "C++", :code => 'cout << "hello" << endl;'

        Component( :comp_name => "TestComponent1",
                   :desc => "Just a dummy test component",
                   :header_codel => 'kdl-headers',
                   :trigger_codel => 'sayhello' ) do

                Property :name => "Prop1", :prop_type => "std::string", :value => '"default"', :desc => "A simple string property"
                Property :name => "Prop2", :prop_type => "int", :value => "32", :desc => "Just a integer property"

                Port :name => "CurPos", :dir => :in, :port_type => "KDL::Frame", :desc => "Current Position"
                Port :name => "DesVel", :dir => :out, :port_type => "std::vector<double>", :desc => "Desired Velocity"
                Port :name => "MaxVel", :dir => :out, :port_type => "double", :initial => "2.34", :desc => "Maximal Velocity"
                #Port :name => "Test", :dir => :inout, :port_type => "std::vector<double>"
        end
end

# this is how simple verification can look like
def verify_model(m)
        m.select { |c|
                if c.instance_of?(RTT_mm::Port)
                        return true
                else return false
                end }.ports.collect{ |p|
                if p.dir == :inout then
                        puts "WARN: port dir :inout not supported in RTT-2.0"
                        return false
                end
        }
        # m.header_codel.name, m.header_codel.language
end

## replace the abstract functions:
##      - send(portstr, value)
##	- recv(portstr, %ret)
def codel_to_rtt(c)
end

def codel_to_ros(c)
end

verify_model(model1)

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(RTT_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
tc.indentString="\t"
#tc.expand('Root::Root', :foreach => model1, :indent => 0)

# tc.expand('Root::Root_rtt_rosbuild', :foreach => model1.select { |o| o.class == RTT_mm::Component }, :indent => 0)
tc.expand('Root::Root_ros_rosbuild', :foreach => model1.select { |o| o.class == RTT_mm::Component }, :indent => 0)
