# Root
<% define 'Root', :for => Component do %>
	<% expand 'RTT_hpp' %>
	<% expand 'RTT_cpp' %>
	<% expand 'RTT_cmake' %>
<%end%>

#
# CMakeLists.txt
#
<% define 'RTT_cmake', :for => Component do %>
<% file 'CMakeLists.txt' do %>

DEPENDENT_OPTION( BUILD_<%= comp_name.upcase %> "Build <%= comp_name %> component" ON "BUILD TASKBROWSER" OFF)

IF ( BUILD_<%= comp_name %> )
<%iinc%>
	FILE( GLOB SRCS [^.]*.cpp )
	FILE( GLOB HPPS [^.]*.hpp )

	ADD_EXECUTABLE( <%= comp_name %> ${SRCS} )
	GLOBAL_ADD_COMPONENT( orocos-<%= comp_name %> ${SRCS} )
	TARGET_LINK_LIBRARIES( <%= comp_name %> ${OROCOS_RTT_LIBS} )
	PROGRAM_ADD_DEPS( <%= comp_name %> orocos-taskbrowser )
<%idec%>
ENDIF ( BUILD<%= comp_name %> )
<%end%>
<%end%>

#
# Component cpp file
#
<% define 'RTT_cpp', :for => Component do %>
<% file comp_name+'.cpp' do %>

#include <%= comp_name+'.hpp' %>

<%nl%>
ORO_CREATE_COMPONENT( OCL::<%= comp_name %> )
<%nl%>

<%end%>
<%end%>

#
# Component hpp file
#
<% define 'RTT_hpp', :for => Component do %>
<% file comp_name+'.hpp' do %>

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
	};<%idec%>
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

