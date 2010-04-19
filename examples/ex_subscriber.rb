
require 'rgen/model_builder'
require 'bcm-regen'

chatter_handler = <<END
cout << "received " << val->data << endl;
END

hdrs =<<END
#include <iostream>
#include <sstream>
#include <std_msgs/String.h>
#include <std_msgs/Int32.h>
END



RGen::ModelBuilder.build(Bcm) do
        Codel( :name => 'test-headers', :lang => "c++", :code => headers = hdrs )
        Codel( :name => 'init', :lang => "c++", :code => "// init code comes here\n")
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
