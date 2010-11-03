# template ros nodes with service ports
#
#

# cpp file entry
<% define 'rosnode_cpp', :for => Component do %>
<% file 'src/'+name+'.cpp' do %>

//
// bricc (BRICS component compiler) generated ros-node
// don't edit, change the input model
//
<%nl%>
<%nl%>
//standard headers
#include <ros/ros.h>

//For header state of the lifecycle statemachine
<%nl%>
<%if header then%>
		 <% expand 'ros_codel', :for => header %>
<%end%>
<%nl%>

//For trigger state of the lifecycle statemachine
<%nl%>
<%if trigger then%>
		 <% expand 'ros_codel', :for => trigger %>
<%end%>
<%nl%>
<%nl%>

//standard namespaces
using namespace std;

<%nl%>
<%nl%>
//-------------------------------------------------------------------------------------------//
//Input data port callbacks
<% expand 'inputdataport_def', :foreach => ports.select{|p| p.class == Bcm::InputPort} %>
<%nl%>
<%nl%>
//------------------------------------------------------------------------------------------//
//Service port callbacks
<% expand 'operations_def', :foreach => ops.select{|oper| oper.class == Bcm::ProvOperation}%>
<%nl%>
<%nl%>

int main(int argc, char** argv)
{
<%iinc%>
	<% expand 'initialization' %>
	<%nl%>
	<%nl%>
	<% expand 'outputdataport_dec', :foreach => ports.select{|p| p.class == Bcm::OutputPort} %>
	<%nl%>
	<% expand 'inputdataport_dec', :foreach => ports.select{|p| p.class == Bcm::InputPort} %>
	<%nl%>
	<% expand 'operations_dec', :foreach => ops.select{|oper| oper.class == Bcm::ProvOperation}%>
	<%nl%>
	<%nl%>
	<% expand 'container_mode' %>
	<%nl%>


<%idec%>
}
<%end%>
<%end%>


// Specific model instances initialized in input file ex_publisher.rb

# Environment initialization
<% define 'initialization', :for => Component do %>
    <% if init then %>
       <% expand 'ros_codel', :for => init %>
    <% end %>
	ros::init(argc, argv, "<%= name %>");
	ros::NodeHandle nh;
    <%nl%>
	<%if (valid_mode == :periodic) && trigger_freq then%>
	 ros::Rate loop_rate(<%= trigger_freq %>); 
	 <%nl%>
	 <%end%>
<%end%>

# Callback definition for input data port
<% define 'inputdataport_def', :for => InputPort do %>
 <%nl%>
 void <%= callback.name %> (const <% expand '/typemodel::type_templ', :for => typeid %>::ConstPtr &msg)
 {			
 //this is input data port callback function definition

 <%nl%>
 }
<%end%>

# Publisher function signature
<% define 'outputdataport_dec', :for => OutputPort do %>
//this is output data port for publishing
	ros::Publisher <%=name%> = nh.advertise<<% expand '/typemodel::type_templ', :for => typeid %>>("<%=descr%>", <%=size%>);
<%end%>

# Subscriber function signature
<% define 'inputdataport_dec', :for => InputPort do %>
//this is input data port for subscriptions
	ros::Subscriber <%=name%> = nh.subscribe("<%=descr%>", <%=size%>, <%=callback.name%>);
<%end%>

# Service server function signature
<% define 'operations_dec', :for => ProvOperation do %>
 //this is service port for client-server
 ros::ServiceServer <%= name %> = nh.advertiseService("<%=descr%>", <%=implements.sig.name%>);
<%end%>

# Callback definition for provided service port
<% define 'operations_def', :for => ProvOperation do %>
 <%nl%>
 <%=implements.sig.retval.name%> <%=implements.sig.name%>(<% expand 'paramList', :foreach => implements.sig.params, :separator => ', '%>)
 {
 //this is service port callback function definition

 <%nl%>
 }
<%end%>

<% define 'paramList', :for => Parameter do %>
<%=typeid.name%> <%=name%><%nonl%>
<% end %>

//This is also an instance, but since it is always going to be empty and be filled
//by a user it can refer to generic model version of the codel.
# ros_codel
<% define 'ros_codel', :for => Bcm::Codel do %>
   <%= codel2ros %>
<%end%>


#Node container mode: aperiodic or periodic
<% define 'container_mode', :for => Component do %>
 <%if valid_mode == :aperiodic then%>
	ros::spin();
 <%end%>

 <%if valid_mode == :periodic then%>
 while (ros::ok())
 {
  <%iinc%>
 	<% if trigger then %>
	   <% expand 'ros_codel', :for => trigger %>
	<% end %>
	<%nl%>
	ros::spinOnce();
	loop_rate.sleep();
	<%idec%>
	}				

 <%end%>
<%end%>

