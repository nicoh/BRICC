#!/usr/bin/ruby
require 'test/unit'

require 'rgen/environment'
require 'rgen/array_extensions'
require 'rgen/template_language'

require 'bcm-regen.rb'

if ARGV.length < 1 then
        puts "bcc: no input files"
        puts "usage: bric <model_file> <output_dir>"
        exit 1
end

model_file = ARGV[0]
target_dir = ARGV[1] or "output"

Templates_dir = "templates/"

# load model file
model_env = eval(File.new(model_file).read())

# assert model_env is a modelbuilder env

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(Bcm, target_dir)
tc.load(Templates_dir)
tc.indentString="\t"

tc.expand('Root::Root_ros_rosbuild', :foreach => model_env.select { |o| o.class == Bcm::Component }, :indent => 0)



