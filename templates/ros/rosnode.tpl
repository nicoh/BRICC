#
# generate ros nodes
#

# cpp file entry
<% define 'rosnode_cpp', :for => Component do %>
<% file 'src/'+name+'.cpp' do %>

// 
// bricc (BRICS component compiler) generated ros-node
// don't edit, change the input model
//
<%nl%><%nl%>

#include "ros/ros.h"
#include "std_msgs/String.h"
<%nl%>
<% expand '/common::codel_templ', :for => header %>
<%nl%>

using namespace std;
<%nl%>

int main(int argc, char** argv)
{
	<%iinc%>
	ros::init(argc, argv, "<%= name %>");
	ros::NodeHandle n;
	<%nl%>
	<% expand 'topic_templ', :foreach => ports %>
	<%nl%>
	// tbd: make this a parameter
	ros::Rate loop_rate(<%= trigger_freq %>);
	<%nl%>

	while (n.ok())
	{
		<%iinc%>
		ros::spinOnce();
		<%nl%>
		<% expand '/common::codel_templ', :for => trigger %>
		<%nl%>
		loop_rate.sleep();
		<%idec%>
	}
	<%idec%>
}
<%end%>
<%end%>

# Subscribe to topic
<% define 'topic_templ', :for => InputPort do %>
   ros::Subscriber <%= name %> = n.subscribe("<%= name %>", <%= size or 1 %>, <%= name %>_callback);
<%end%>

# Advertise topic
<% define 'topic_templ', :for => OutputPort do %>
   ros::Publisher <%= name %> = n.advertise< <% expand '/typemodel::type_templ', :for => typeid %> >("<%= name %>", <%= size or 1 %>);
<%end%>
