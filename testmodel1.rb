#!/usr/bin/ruby

require 'rgen/template_language'
require 'rgen/model_builder'
require 'rgen/template_language'
require "RTT_mm"

TEMPLATES_DIR = "templates/"
OUTPUT_DIR="output/"

model1 = RGen::ModelBuilder.build(RTT_mm) do
	Component :comp_name => "TestComponent1", :desc => "Just a dummy test component" do
		Property :name => "Prop1", :prop_type => "std::string", :value => '"default"', :desc => "A simple string property"
		Property :name => "Prop2", :prop_type => "int", :value => "32", :desc => "Just a integer property"
		Port :name => "CurPos", :port_type => "KDL::Frame", :dir =>:in, :desc => "Current Position"
		Port :name => "DesVel", :port_type => "std::vector<double>", :dir =>:out, :desc => "Desired Velocity"
		Port :name => "DesVel", :port_type => "double", :dir =>:out, :initial => "2.34", :desc => "Desired Velocity"
		# Port :name => "Test", :port_type => "std::vector<double>", :dir => :inout
		Codel :name => 'kdl-headers', :language => "C++", :code => "#include <kdl/frames.hpp>"
	end
end

# this is how simple verification can look like
def verify_model(m)
	m.ports.collect{ |p|
		if p.dir == :inout then
			puts "ERROR: port dir :inout not supported"
			return false
		end
	}
        # m.header_codel.name, m.header_codel.language
end

verify_model(model1)

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(RTT_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
tc.indentString="\t"

tc.expand('Root::Root', :foreach => model1, :indent => 0)
