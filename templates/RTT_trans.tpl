# Root
<% define 'Root', :for => Component do %>
	<% expand 'RTT_hpp' %>
	<% expand 'RTT_cpp' %>
	<% expand 'ROS_cmake' %>
	<% expand 'ROS_makefile' %>
	<% expand 'ROS_manifest' %>
<%end%>


################################################################################
# ROS STUFF
################################################################################

#
# Ros manifest
#
<% define 'ROS_manifest', :for => Component do %>
<% file 'manifest.xml' do %>
<package>
  <%iinc%>
  <description brief="<%= comp_name %>">
  add something meaningful here
  </description>
  <author></author>
  <license>BSD</license>
  <review status="unreviewed" notes=""/>
  <url>http://ros.org/wiki/dummy</url>
  <depend package="rtt-1.10"/>

  <%idec%>
</package>
<%end%>
<%end%>

#
# Ros Makefile
#
<% define 'ROS_makefile' do %>
<% file 'Makefile' do %>
include $(shell rospack find mk)/cmake.mk
<%end%>
<%end%>

#
# CMakeLists.txt (ROS style)
#
<% define 'ROS_cmake', :for => Component do %>
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
rospack(<%= comp_name %>)
<%nl%>

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

<%end%>
<%end%>

################################################################################
# RTT STUFF
################################################################################

#
# CMakeLists.txt (OCL style)
#
<% define 'RTT_cmake', :for => Component do %>
<% file 'CMakeLists.txt' do %>

DEPENDENT_OPTION( BUILD_<%= comp_name.upcase %> "Build <%= comp_name %> component" ON "BUILD TASKBROWSER" OFF)

<%nl%>

IF ( BUILD_<%= comp_name.upcase %> )
<%iinc%>
	FILE( GLOB SRCS [^.]*.cpp )
	FILE( GLOB HPPS [^.]*.hpp )
	ADD_EXECUTABLE( <%= comp_name %> ${SRCS} )
	GLOBAL_ADD_COMPONENT( orocos-<%= comp_name %> ${SRCS} )
	TARGET_LINK_LIBRARIES( <%= comp_name %> ${OROCOS_RTT_LIBS} )
	PROGRAM_ADD_DEPS( <%= comp_name %> orocos-taskbrowser )
<%idec%>
ENDIF ( BUILD_<%= comp_name.upcase %> )
<%end%>
<%end%>

#
# Component cpp file
#
<% define 'RTT_cpp', :for => Component do %>
<% file 'src/'+comp_name+'.cpp' do %>

#include "<%= comp_name+'.hpp' %>"
#include <ocl/ComponentLoader.hpp>

<%nl%>
ORO_CREATE_COMPONENT( OCL::<%= comp_name %> )
<%nl%>

using namespace std;
using namespace Orocos;
using namespace RTT;
<%nl%>

// Constructor
<%= comp_name %>::<%= comp_name %>(std::string name)
<%iinc%>
	: TaskContext(name)
	// tbd: orocos object initializations here
<%idec%>
{
<%iinc%>
	// tbd add stuff to interface here
<%idec%>
}

<%nl%> <%nl%>

// Destructor
<%= comp_name %>::~<%= comp_name %>()
{
}

<%nl%> <%nl%>

bool <% comp_name %>::configureHook()
{
<%iinc%>
	// <configure_hook_codel>
	return false;
	// </configure_hook_codel>
<%idec%>
}

<%end%>
<%end%>

#
# Component hpp file
#
<% define 'RTT_hpp', :for => Component do %>
<% file 'src/'+comp_name+'.hpp' do %>

<% expand 'ifdef_header', comp_name.upcase %>
<% expand 'rtt_headers' %> <%nl%>
<% expand 'rtt_namespaces' %> <%nl%>

namespace OCL
{
<%iinc%>
	class <%= comp_name %> : public TaskContext
        {
	protected:
	<%iinc%>
		// Properties
		<% expand 'prop_templ', :foreach => props %> <%nl%>
		// Ports
		<% expand 'port_templ', :foreach => ports %>
        <%idec%>
	};
<%idec%>
}

<% expand 'ifdef_footer', comp_name.upcase %>

<%end%>
<%end%>

# prop_templ
<% define 'prop_templ', :for => Property do %>
Property<<%= prop_type %>> <%= name %>;
<%end%>

# Ports
<% define 'port_templ', :for => Port do %>
InputPort<<%= port_type %>> <%= name %>;
<%end%>

# ifdef header
<% define 'ifdef_header', :for => Object do |name| %>
#ifndef __<%= name.upcase %>__
#define __<%= name.upcase %>__
<%nl%>
<%end%>

# ifdef footer
<% define 'ifdef_footer', :for => Object do |name| %>
<%nl%>
#endif // __<%= name.upcase %>__
<%nl%>
<%end%>

# rtt namespaces
<% define 'rtt_namespaces' do %>
using namespace std;
using namespace RTT;
using namespace Orocos;
<%end%>

# rtt namespace
<% define 'rtt_headers' do %>
#include <rtt/TaskContext.hpp>
#include <rtt/Logger.hpp>
#include <rtt/Property.hpp>
#include <rtt/Attribute.hpp>
#include <rtt/Method.hpp>
#include <rtt/Command.hpp>
#include <rtt/Event.hpp>
#include <rtt/Ports.hpp>
<%nl%>
#include <ocl/OCL.hpp>
<%nl%>
<%end%>

