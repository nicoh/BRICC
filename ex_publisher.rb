require 'rgen/model_builder'
require 'bcm-regen'

headers = <<END
// custom headers
#include <std_msgs/String.h>
#include <std_msgs/Int32.h>
#include <iostream>
#include <sstream>
END

hi_and_inc = <<END
std::stringstream ss;
std_msgs::String msg;

int x = bcm_prop_get(counter).data;
cout << "hello " << x << " times" << endl;
ss << "Hello there! This is message [" << x << "]";
x++;

// bcm_prop_set(counter.data, x);
counter.data = x;

msg.data = ss.str();
bcm_port_write(chatter, msg);
END

RGen::ModelBuilder.build(Bcm) do
	Codel( :name => 'test-headers', :lang => "c++", :code => headers )
	Codel( :name => 'hi_and_inc', :lang => "c++", :code => hi_and_inc)
	Codel( :name => 'init', :lang => "c++", :code => "int x = 0;\n")

	Type( :name => "std_msgs::String" )
	Type( :name => "std_msgs::Int32" )

	Component( :name => "BCM_Publisher",
		   :descr => "A dummy publisher component",
		   :valid_mode => :periodic,
		   :trigger_freq => 1,
		   :header => 'test-headers',
		   :trigger => 'hi_and_inc',
		   :init => 'init' ) do

                Property( :name => "counter", :descr => "this is a counter",
                          :typeid => "std_msgs::Int32", :default_val => "99" )

		OutputPort( :name => "chatter",  :descr => "publishing strings to the chatter port",
                            :typeid => "std_msgs::String", :size => 100 )
	end
end
