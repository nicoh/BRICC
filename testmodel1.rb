#!/usr/bin/ruby

require 'rgen/template_language'
require 'rgen/model_builder'
require 'rgen/template_language'
require "RTT_mm"

TEMPLATES_DIR = "templates/"
OUTPUT_DIR="output/"

model1 = RGen::ModelBuilder.build(RTT_mm) do
        Component :comp_name => "TestComponent1" do
                Property :name => "Prop1", :prop_type => "std::string", :initial => "default", :desc => "A simple string property"
                Property :name => "Prop2", :prop_type => "int", :initial => "32", :desc => "Just a integer property"
                InputPort :name => "CurPos", :port_type => "kdl::frame"
                OutputPort :name => "DesVel", :port_type => "std::vector<double>"
        end
end

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(RTT_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
tc.indentString="\t"

tc.expand('Root::Root', :foreach => model1, :indent => 0)
