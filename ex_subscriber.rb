
require 'rgen/model_builder'
require 'bcm-regen'

chatter_handler = <<ENDTAG
cout << "received " << val->data << endl;
ENDTAG

RGen::ModelBuilder.build(Bcm) do
        Codel( :name => 'test-headers', :lang => "c++", :code => headers = "#include <iostream>\n#include <sstream>\n" )
        Codel( :name => 'init', :lang => "c++", :code => '// init code comes here')
        Codel( :name => 'chatter_handler', :lang => "c++", :code => chatter_handler)

        Type( :name => "std_msgs::String" )
        
        Component( :name => "BCM_Subscriber",
                   :descr => "A dummy subscriber component",
                   :valid_mode => :periodic,
                   :header => 'test-headers',
                   :init => 'init' ) do
                
                InputPort( :name => "chatter", :descr => "input for chattering",
                           :typeid => "std_msgs::String", :callback => 'chatter_handler')
        end
end
