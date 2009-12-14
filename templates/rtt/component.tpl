
################################################################################
# Component hpp file
################################################################################

<% define 'rtt_hpp', :for => Component do %>
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


################################################################################
# Component cpp file
################################################################################

<% define 'rtt_cpp', :for => Component do %>
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

