#!/usr/bin/ruby

require 'rgen/model_builder'
require 'rgen/template_language'
require 'BCM_type_mm'

TEMPLATES_DIR="tpl_typegen"
OUTPUT_DIR="out_types/"

model1 = RGen::ModelBuilder.build(BCM_type_mm) do
        
        CompositeType( :name => 'Vector' ) do
                PrimitiveSubtype :name => 'x', :typeid => :uint32
                PrimitiveSubtype :name => 'y', :typeid => :uint32
                PrimitiveSubtype :name => 'z', :typeid => :uint32
        end

        CompositeType( :name => 'Rotation' ) do
                CompositeSubtype :name => 'X', :typeid => 'Vector'
                CompositeSubtype :name => 'Y', :typeid => 'Vector'
                CompositeSubtype :name => 'Z', :typeid => 'Vector'
        end

        CompositeType( :name => 'Frame' ) do
                CompositeSubtype :name => 'P', :typeid => 'Vector'
                CompositeSubtype :name => 'M', :typeid => 'Rotation'
        end
end

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(BCM_type_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
tc.indentString="\t"
tc.expand('Rosmsg::Root_rosmsg', :foreach => model1.select { |o| o.class == BCM_type_mm::CompositeType }, :indent => 0)
