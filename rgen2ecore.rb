#!/usr/bin/ruby

require 'rgen/model_builder'
require 'rgen/template_language'


# convert the RGEN meta model to ecore

def check_args(argv)
        def ops_and_die()
                puts __FILE__ + " <rgen_mm.rb> <outfile>"
                exit(1)
        end

        if argv.length < 1 then ops_and_die() end

        if not ( FileTest.file?(infile) and
                 FileTest.readable?(infile) ) then
                ops_and_die()
                puts("ERR: argument not a file or unreadable")
        end

        if not outfile then
                outfile = File.basename(infile, ".rb") + "-export.ecore"
        end

        return infile, outfile
end

infile, outfile = check_args(ARGV)

## tbd: how require the file and figure out the module name?

#pack = Rtfsm_mm.ecore
# assert pack.is_a?(RGen::ECore::EPackage)

# File.open("Rtfsm_mm.ecore","w") do |f|
#         ser = RGen::Serializer::XMI20Serializer.new(f)
#         ser.serialize(Rtfsm_mm.ecore)
# end
