# Root
<% define 'Root', :for => Component do %>
	<% expand 'rtt/rtt1_comp::rtt_hpp' %>
	<% expand 'rtt/rtt1_comp::rtt_cpp' %>
	<% expand 'ros/rosbuild::ros_cmakelists' %>
	<% expand 'ros/rosbuild::ros_makefile' %>
	<% expand 'ros/rosbuild::ros_manifest' %>
<%end%>
