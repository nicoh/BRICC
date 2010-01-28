
require 'rgen/instantiator/ecore_xml_instantiator'
require 'mmgen/metamodel_generator'

include MMGen::MetamodelGenerator

outfile = "bcm-regenerated.rb"
infile = "bcm.ecore"

# here we go
puts "-instantiating..."
env = RGen::Environment.new
File.open(infile) { |f|
        puts "instantiating ..."
	ECoreXMLInstantiator.new(env).instantiate(f.read)
}

rootPackage = env.find(:class => RGen::ECore::EPackage).first

puts "-generating..."
#generateMetamodel(rootPackage, out_file, modules)
generateMetamodel(rootPackage, outfile)

