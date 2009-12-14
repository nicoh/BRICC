# Root
<% define 'Root', :for => Component do %>
	<% expand 'rtt/component::rtt_hpp' %>
	<% expand 'rtt/component::rtt_cpp' %>
	<% expand 'ros/rosbuild::ros_cmakelists' %>
	<% expand 'ros/rosbuild::ros_makefile' %>
	<% expand 'ros/rosbuild::ros_manifest' %>
<%end%>
