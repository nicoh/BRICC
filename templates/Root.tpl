# Entry templates

# RTT component, rosbuild system
<% define 'Root_rtt_rosbuild', :for => Component do %>
	<% expand 'rtt/rtt1_comp::rtt_hpp' %>
	<% expand 'rtt/rtt1_comp::rtt_cpp' %>
	<% expand 'ros/rosbuild::ros_rtt_cmakelists' %>
	<% expand 'ros/rosbuild::ros_makefile' %>
	<% expand 'ros/rosbuild::ros_rtt_manifest' %>
<%end%>

# RTT component, OCL style makefile
<% define 'Root_rtt_ocl', :for => Component do %>
	<% expand 'rtt/rtt1_comp::rtt_hpp' %>
	<% expand 'rtt/rtt1_comp::rtt_cpp' %>
	<% expand 'rtt/ocl_makefile::OCL_cmake' %>
<%end%>

# ROS node, rosbuild system
<% define 'Root_ros_rosbuild', :for => Component do %>
	<% expand 'ros/rosnode::rosnode_cpp' %>
	<% expand 'ros/rosbuild::ros_node_cmakelists' %>
	<% expand 'ros/rosbuild::ros_makefile' %>
	<% expand 'ros/rosbuild::ros_node_manifest' %>
<%end%>



