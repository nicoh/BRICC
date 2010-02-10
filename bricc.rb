#!/usr/bin/ruby

Base_dir = File.expand_path(File.dirname(__FILE__))
puts Base_dir
$:.unshift Base_dir

require 'optparse'
require 'pp'

require 'rgen/environment'
require 'rgen/array_extensions'
require 'rgen/template_language'

require 'bcm-regen'
require 'bcm-codel-ext'
require 'bcm-codel-rtt'
require 'bcm-codel-ros'

Version = "0.1"
Templates_dir = Base_dir+"/templates/"

# option parsing
options = {}

optparse = OptionParser.new do|opts|
	opts.banner = "Usage: #{__FILE__} [options] file"

	opts.on( '-h', '--help', 'Displays this information' ) do
		puts opts
		exit
	end

	opts.on( '-V', '--version', "Print version" ) do
		puts "bricc #{Version} (BRICS Component Compiler)"
                exit
	end

	opts.on( '-t', '--target TARGET', [:rtt, :ros], "Transformation target [rtt|ros]" ) do |t|
		options[:target] = t
	end

	opts.on( '-v', '--verbose', "More verbose output" ) do
		options[:verbose] = true
	end

	options[:outdir] = "output"
	opts.on( '-o', '--outdir DIR', "Output directory" ) do |dir|
		options[:outdir] = dir
	end

        options[:params] = []
	opts.on( '-p', '--params a,b=x,c', Array, "List of target specific parameters" ) do |l|
		options[:params] = l
	end
end

optparse.parse!

if ARGV.length < 1 then
	puts "#{__FILE__}: no input files"
	exit 1
end

if not options[:target] then
	puts "no target given"
	exit 1
end

model_file = ARGV[0]

# load model file
model_env = eval(File.new(model_file).read())

# tbd: assert model_env is a modelbuilder env

tc = RGen::TemplateLanguage::DirectoryTemplateContainer.new(Bcm, options[:outdir])
tc.load(Templates_dir)
tc.indentString="\t"

if options[:verbose] then puts "compiling #{model_file} to directory '#{options[:outdir]}' for target '#{options[:target]}' " end

if options[:target] == :rtt then
        tc.expand('Root::Root_rtt_rosbuild', :foreach => model_env.select { |o| o.class == Bcm::Component }, :indent => 0)
elsif options[:target] == :ros then
        tc.expand('Root::Root_ros_rosbuild', :foreach => model_env.select { |o| o.class == Bcm::Component }, :indent => 0)
end
