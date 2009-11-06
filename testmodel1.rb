require 'rgen/environment'
require 'rgen/array_extensions'
require 'metamodels/uml13_metamodel'
require 'rgen/instantiator/xmi11_instantiator'
require 'rgen/serializer/xmi20_serializer'

require 'rgen/template_language'
require 'rgen/model_builder'
require 'rgen/template_language'
require "RTT_mm"

TEMPLATES_DIR = "templates/"
OUTPUT_DIR="output/"

env = RGen::Environment.new

model1 = RGen::ModelBuilder.build(RTT_mm) do
        Component "TestComponent1" do
                Property :name => "Prop1", :type => "String", :init_val => "default", :desc => "A simple string property"
                Property :name => "Prop2", :type => "int", :init_val => "32", :desc => "Just a integer property"
        end
end

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(RTT_mm, OUTPUT_DIR)
tc.load(TEMPLATES_DIR)
tc.indentString="\t"

# testModel should hold an instance of the metamodel class expected by
# the root template the following line starts generation

# tc.expand('RTT_trans::Root', :for => env.find(:class => RTT_mm::Component, :indent => 1))
tc.expand('RTT_trans::Root', :for => model1, :indent => 0)


# generate code                                                                                                                                                         # tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(StatemachineMetamodel, targetDir)
# templatedir = File.dirname(__FILE__)+"/templates"
# tc.load(templatedir)
# tc.expand('Root::Root', :foreach => envSM.find(:class => StatemachineMetamodel::Statemachine))
