require 'rgen/model_builder'
require 'rgen/template_language'
require "RTT_mm"

tm1 = RGen::ModelBuilder.build(RTT_mm) do
        Component "TestComponent1" do
                Property :name => "Prop1", :type => "String", :init_val => "default", :desc => "A simple string property"
                Property :name => "Prop2", :type => "int", :init_val => "32", :desc => "Just a integer property"
        end
end

OUTPUT_DIR = File.dirname(__FILE__)+"/output"
TEMPLATES_DIR = File.dirname(__FILE__)+"/templates"

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(RTT_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
# testModel should hold an instance of the metamodel class expected by
# the root template the following line starts generation
tc.expand('root::Root', :for => tm1, :indent => 1)

