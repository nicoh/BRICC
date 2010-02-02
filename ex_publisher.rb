
require 'rgen/model_builder'
require 'bcm-regen'

hi_and_inc = <<ENDTAG
std::stringstream ss;
std_msgs::String msg;

cout << "hello " << x << " times" << endl;
x++;
ss << "Hello there! This is message [" << x << "]";
msg.data = ss.str();
chatter.publish(msg);
ENDTAG

RGen::ModelBuilder.build(Bcm) do
        Codel( :name => 'test-headers', :lang => "c++", :code => headers = "#include <iostream>\n#include <sstream>\n" )
        Codel( :name => 'hi_and_inc', :lang => "c++", :code => hi_and_inc)
        Codel( :name => 'init', :lang => "c++", :code => 'int x = 0;')

        Type( :name => "std_msgs::String" )
        
        Component( :name => "BCM_Publisher",
                   :descr => "A dummy publisher component",
                   :valid_mode => :periodic,
                   :trigger_freq => 1,
                   :header => 'test-headers',
                   :trigger => 'hi_and_inc',
                   :init => 'init' ) do
                
                OutputPort( :name => "chatter", :typeid => "std_msgs::String", 
                            :size => 100, :descr => "publishing strings to the chatter topic" )
        end
end
