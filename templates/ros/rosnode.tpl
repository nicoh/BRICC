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

#include <ros/ros.h>

<%nl%>
<% expand 'ros_codel', :for => header %>
<%nl%>

using namespace std;
<%nl%>

<% expand 'callback', :foreach => ports.select{|p| p.class == Bcm::InputPort } %>
<%nl%>

int main(int argc, char** argv)
{
<%iinc%>
	ros::init(argc, argv, "<%= name %>");
	ros::NodeHandle nh;
	<%nl%>

	<% expand 'topic_templ', :foreach => ports %> <%nl%>
	<% expand 'property', :foreach => props %> <%nl%>

	<% if trigger_freq %>
	   ros::Rate loop_rate(<%= trigger_freq %>); <%nl%>
	<% end %>

	<% if init then expand 'ros_codel', :for => init end %>

	<% if trigger_freq %>
	    <% expand 'periodic_body' %>
	<% else %>
	    <% expand 'aperiodic_body' %>
	<% end %>

	<% if final then expand 'ros_codel', :for => final end %>
<%idec%>
}
<%end%>
<%end%>

# periodic body
<% define 'periodic_body', :for => Component do %>
while (ros::ok())
{
<%iinc%>
	<% if trigger then %>
	   <% expand 'ros_codel', :for => trigger %>
	<% end %>
	<%nl%>
	<%# spinOnce could be added conditionally only if we have an InputPort with callback %>
	ros::spinOnce();
	loop_rate.sleep();
<%idec%>
}
<%end%>

# aperiodic body
# could be optimized
#    on ly call spin if callbacks exist
<% define 'aperiodic_body', :for => Component do %>
    <% if trigger then %>
       <% expand 'ros_codel', :for => trigger %>
    <% end %>
    <%nl%>
    ros::spin();
<%end%>

# callback
<% define 'callback', :for => InputPort do %>
   <% if callback then %>
   void <%= name %>_callback(const <% expand '/typemodel::type_templ', :for => typeid %>::ConstPtr& val)
   {
   <%iinc%>
     <% expand 'ros_codel', :for => callback %>
   <%idec%>
   }
   <%end%>
<%end%>

# Subscribe to topic
<% define 'topic_templ', :for => InputPort do %>
   ros::Subscriber <%= name %> = nh.subscribe("<%= name %>", <%= size or 1 %>, <%= name %>_callback);
<%end%>

# Advertise topic
<% define 'topic_templ', :for => OutputPort do %>
   ros::Publisher <%= name %> = nh.advertise< <% expand '/typemodel::type_templ', :for => typeid %> >("<%= name %>", <%= size or 1 %>);
<%end%>


# ros_codel
<% define 'ros_codel', :for => Bcm::Codel do %>
   <%= codel2ros %>
<%end%>

# property: only a variable in ROS
<% define 'property', :for => Bcm::Property do %>
  <%= typeid.name %> <%= name %>;
<%end%>

