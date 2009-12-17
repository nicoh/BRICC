#
# generate ros nodes
#

<% define 'rosnode_cpp', :for => Component do %>
<% file 'src/'+comp_name+'.cpp' do %>

// 
// bric (BRICS compiler) generated ros-node
// don't edit, change the input model
//
<%nl%><%nl%>

#include "ros/ros.h"
#include "std_msgs/String.h"
<%nl%>
<% expand '/common::codel_templ', :for => header_codel %>
<%nl%>

using namespace std;
<%nl%>

int main(int argc, char** argv)
{
	<%iinc%>
	ros::init(argc, argv, "<%= comp_name %>");
	ros::NodeHandle n;
	<%nl%>
	<% expand 'topic_templ', :foreach => ports %>
	<%nl%>
	// tbd: make this a parameter
	ros::Rate loop_rate(5);
	<%nl%>

	while (n.ok())
	{
		<%iinc%>
		ros::spinOnce();
		<%nl%>
		<% expand '/common::codel_templ', :for => trigger_codel %>
		<%nl%>
		loop_rate.sleep();
		<%idec%>
	}
	<%idec%>
}
<%end%>
<%end%>


<% define 'topic_templ', :for => Port do %>
   <% if dir == :in %>
      // tbd in-port <%= name %>
   <% elsif dir == :out %>
      // <%= name %>
      ros::Publisher <%= name %> = n.advertise<<%= port_type %> >("<%= name %>", <%= size or 1 %>);
   <% else %>
      // tbd inout-port  <%= name %>
   <% end %>
<%end%>
