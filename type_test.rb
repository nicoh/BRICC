#!/usr/bin/ruby

require 'rgen/model_builder'
require 'rgen/template_language'
require "BCM_type_mm"

TEMPLATES_DIR = "templates/"
OUTPUT_DIR="out_types/"

model1 = RGen::ModelBuilder.build(BCM_type_mm) do

        
        Type ( :id => 'Vector' ) do
                NamedType :id => "x", :type => UInt32
                NamedType :id => "y", :type => UInt32
                NamedType :id => "z", :type => UInt32
        end

        Type ( :id => 'Rotation' ) do
                NamedType :id => 'X', :type => 'Vector'
                NamedType :id => 'Y', :type => 'Vector'
                NamedType :id => 'Z', :type => 'Vector'
        end

        Type ( :id => 'Frame' ) do
                NamedType :id => 'P', :type => 'Vector'
                NamedType :id => 'M', :type => 'Rotation'
        end

end

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(BCM_type_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
tc.indentString="\t"
tc.expand('types/Root_rosmsg', :foreach => model1.select { |o| o.class == BCM_type_mm::Type }, :indent => 0)
