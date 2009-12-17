
################################################################################
# ROS 'manifest'
################################################################################

<% define 'ros_rtt_manifest', :for => Component do %>
<% file 'manifest.xml' do %>
<package>
  <%iinc%>
  <description brief="<%= comp_name %>">

  <%= desc %>

  </description>
  <author></author>
  <license>BSD</license>
  <review status="unreviewed" notes=""/>
  <url>http://www.orocos.org/wiki/</url>
  <depend package="rtt-1.10"/>
  <depend package="ocl-1.10"/>
  <depend package="kdl-1.0"/>
  <%idec%>
</package>
<%end%>
<%end%>

<% define 'ros_node_manifest', :for => Component do %>
<% file 'manifest.xml' do %>
<package>
  <%iinc%>
  <description brief="<%= comp_name %>">

  <%= desc %>

  </description>
  <author></author>
  <license>BSD</license>
  <review status="unreviewed" notes=""/>
  <url>http://ros.org/wiki/dummy</url>

  <depend package="roscpp"/>
  <depend package="std_srvs"/>
  <depend package="std_msgs"/>
  <export>
	<%iinc%>
	<cpp cflags="-I${prefix}/srv/cpp"/>
	<%idec%>
  </export>
  <%idec%>
</package>
<%end%>
<%end%>


################################################################################
# ROS 'Makefile'
################################################################################

<% define 'ros_makefile' do %>
<% file 'Makefile' do %>
include $(shell rospack find mk)/cmake.mk
<%end%>
<%end%>


################################################################################
# ROS CMakeLists
################################################################################

<% define 'ros_node_cmakelists', :for => Component do %>
<% file 'CMakeLists.txt' do %>

cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)
#include_directories(${PROJECT_SOURCE_DIR}/srv/cpp)
<%nl%>
rosbuild_init()
rosbuild_genmsg()
rosbuild_gensrv()

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)
<%nl%>
#set the default path for built executables to the "bin" directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
#set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
<%nl%>
#common commands for building c++ executables and libraries
#rosbuild_add_library(${PROJECT_NAME} src/<%= comp_name+'.cpp' %>)
#target_link_libraries(${PROJECT_NAME} another_library)
#rosbuild_add_boost_directories()
#rosbuild_link_boost(${PROJECT_NAME} thread)
rosbuild_add_executable(${PROJECT_NAME} src/<%= comp_name+'.cpp' %>)
#target_link_libraries(example ${PROJECT_NAME})

<%end%>
<%end%>


<% define 'ros_rtt_cmakelists', :for => Component do %>
<% file 'CMakeLists.txt' do %>

cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)
<%nl%>

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)
<%nl%>
rosbuild_init()
#set the default path for built executables to the "bin" directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
<%nl%>
#uncomment if you have defined messages
#rosbuild_genmsg()
#uncomment if you have defined services
#rosbuild_gensrv()
<%nl%>
#common commands for building c++ executables and libraries
rosbuild_add_library(${PROJECT_NAME} src/<%= comp_name+'.cpp' %>)
#target_link_libraries(${PROJECT_NAME} another_library)
#rosbuild_add_boost_directories()
#rosbuild_link_boost(${PROJECT_NAME} thread)
#rosbuild_add_executable(example examples/example.cpp)
#target_link_libraries(example ${PROJECT_NAME})
<%nl%>
ADD_DEFINITIONS(-DOCL_DLL_EXPORT)
<%end%>
<%end%>
