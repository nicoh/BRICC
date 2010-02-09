require 'treetop'
require 'polyglot'
require 'tt/codel'

module Bcm::Codel::ClassModule
        def split_codel
                codelp = CodelParser.new
                codelp.parse(code)
        end
end
