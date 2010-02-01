#!/usr/bin/ruby
require 'rgen/environment'
require 'rgen/array_extensions'
require 'bcm-regen.rb'

require 'rgen/template_language'


if ARGV.length < 1 then
        puts "bcc: no input files"
        puts "usage: bric <model_file> <output_dir>"
        exit 1
end

model_file = ARGV[0]
target_dir = ARGV[1] or "output"

Templates_dir = "templates/"

# crude way to get a model from a file
# we load the file in a closed environment and return the binding
# we can then extract the "model" variable from there

def get_model_from_file(name, model_file)
        def file_eval_binding(file)
                load(file, true)
                binding
        end
        b = file_eval_binding(model_file)
        modelEnv = eval name, b
        return modelEnv
end

modelEnv = get_model_from_file("model", model_file)

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(BCM_mm, target_dir)
tc.load(Templates_dir)
tc.indentString="\t"
#tc.expand('Root::Root', :foreach => model1, :indent => 0)

# tc.expand('Root::Root_rtt_rosbuild', :foreach => model1.select { |o| o.class == BCM_mm::Component }, :indent => 0)
tc.expand('Root::Root_ros_rosbuild', :foreach => modelEnv.select { |o| o.class == BCM_mm::Component }, :indent => 0)



