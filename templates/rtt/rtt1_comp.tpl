################################################################################
# Component hpp file
################################################################################

<% define 'rtt_hpp', :for => Component do %>
<% file 'src/'+name+'.hpp' do %>

<% expand 'ifdef_header', name.upcase %>
<% expand 'rtt_headers' %>
<% expand 'rtt_codel', :for => header %> <%nl%>
<% expand 'rtt_namespaces' %>

namespace OCL
{
<%iinc%>
	class <%= name %> : public TaskContext
	{
	protected:
	<%iinc%>
		// Properties
		<%# expand 'prop_templ', :foreach => props %>
		<% expand 'prop_vars', :foreach => props %>
		 <%nl%>
		// Ports
		<% expand 'port_templ', :foreach => ports %>
		<%nl%>
		// Event handles
		<% expand 'input_port_event_handle', :foreach => ports.select { |p| p.class == Bcm::InputPort } %>
	<%idec%>
	public:
	<%iinc%>
		/***
		* Constructor
		* @ param the component name
		*/
		<%= name %>(std::string name);
		<%nl%>

		/***
		* Destructor
		*/
		~<%= name %>();
		<%nl%>

		// Standard RTT hooks
		bool configureHook();
		// bool startHook();
		void updateHook();
		void stopHook();
		void cleanupHook();
		<%nl%>
		// Port Event handlers
		<% expand 'input_port_evh_decl', :foreach => ports.select { |p| p.class == Bcm::InputPort } %>
	<%idec%>
	};
<%idec%>
}

<% expand 'ifdef_footer', name.upcase %>

<%end%>
<%end%>

# InputPort Event Handle
<% define 'input_port_event_handle', :for => Bcm::InputPort do %>
   <% if callback then %>
      Handle <%= name %>_evh;
   <%end%>
<%end%>

<% define 'input_port_evh_decl', :for => Bcm::InputPort do %>
   void <%= name %>_handler(PortInterface*);
<%end%>

# Property definition
<% define 'prop_templ', :for => Property do %>
Property<<% expand '/typemodel::type_templ', :for => typeid %>> <%= name %>;
<%end%>

# alternative: Properties as variables
<% define 'prop_vars', :for => Property do %>
   <%= typeid.name %> <%= name %>;
<%end%>

# Port definition
<% define 'port_templ', :for => InputPort do %>
   ReadBufferPort<<% expand '/typemodel::type_templ', :for => typeid %>> <%= name %>;
<%end%>

<% define 'port_templ', :for => OutputPort do %>
   WriteBufferPort<<% expand '/typemodel::type_templ', :for => typeid %>> <%= name %>;
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
<%nl%>
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

# Property contstructor initalizer: default val: set in ctr?
<% define 'prop_ctr_init', :for => Property do %>
   , <%= name %>("<%= name %>", "<%= descr %>")
<%end%>

# Port constructor initializer
<% define 'port_ctr_init', :for => InputPort do %>
   , <%= name %>("<%= name %>")
<%end%>

# tbd: initial value (annotation?)
<% define 'port_ctr_init', :for => OutputPort do %>
   , <%= name %>("<%= name %>", <%= size or 1 %>)
<%end%>

# Add Properties to TC Interface
<% define 'props_if_add', :for => Property do %>
   this->properties()->addProperty( &<%= name %> );
<%end%>

# Add Ports to TC Interface
<% define 'ports_if_add', :for => Port do %>
   this->ports()->addPort( &<%= name %>, "<%= descr %>" );
<%end%>

# assert that obj is ready
<% define 'assert_ready' do %>
   <% ports.each do |p| %> assert(<%= p.name %>.ready() ); <%end%>
<%end%>

# RTT1 Codel
<% define 'rtt_codel', :for => Bcm::Codel do %>
   <%= codel2rtt %>
<%end%>

# InputPort event handler setup in Ctr
<% define 'input_port_setup_evh', :for => Bcm::InputPort do %>
   PortInterface::NewDataOnPortEvent* <%= name %>_event = <%= name %>.getNewDataOnPortEvent();
   <%= name %>_evh = <%= name %>_event->connect(boost::bind(&<%=comp.name %>::<%=name%>_handler,this,_1),this->engine()->events());
<%end%>

# InputPort member function
<% define 'input_port_handler', :for => Bcm::InputPort do %>
   void <%= comp.name %>::<%= name %>_handler(PortInterface* portif)
   {
   <%iinc%>
	assert(portif == &<%= name %>);
	<%= typeid.name %> *val = new <%= typeid.name %>();
	<%= name %>.Pop(*val);
	<% expand 'rtt_codel', :for => callback %>
   <%idec%>
   }
<%end%>

#
# Component CPP
#
<% define 'rtt_cpp', :for => Component do %>
<% file 'src/'+name+'.cpp' do %>

#include "<%= name+'.hpp' %>"
#include <ocl/ComponentLoader.hpp>

<%nl%>
ORO_CREATE_COMPONENT( OCL::<%= name %> )
<%nl%>

using namespace std;
using namespace Orocos;
using namespace RTT;
<%nl%>

namespace OCL
{
<%iinc%>
	// Constructor
	<%= name %>::<%= name %>(std::string name)
	<%iinc%>
		: TaskContext(name)
		<%# expand 'prop_ctr_init', :foreach => props %>
		<% expand 'port_ctr_init', :foreach => ports %>
	<%idec%>
	{
	<%iinc%>
		// assert everything is OK
		<%# expand 'assert_ready' %> <%nl%>

		// add RTT stuff to interface here
		<%# expand 'props_if_add', :foreach => props %>
		<% expand 'ports_if_add', :foreach => ports %> <%nl%>

		// setup InportEvent handlers
		<% expand 'input_port_setup_evh', :foreach => ports.select { |p| p.class == Bcm::InputPort } %>
	<%idec%>
	}

	<%nl%> <%nl%>

	// Destructor
	<%= name %>::~<%= name %>()
	{
	}

	<%nl%> <%nl%>

	// configureHook
	bool <%= name %>::configureHook()
	{
	<%iinc%>
		<% if init then %>
		   <% expand 'rtt_codel', :for => init %>
		<% else %>
		   return true;
		<% end %>
	<%idec%>
	}

	<%nl%>

	// startHook()
	// bool <%= name %>::startHook()
	// {
	// <%iinc%>
	//        return false;
	// <%idec%>
	// }

	<%nl%>

	// updateHook
	void <%= name %>::updateHook()
	{
	<%iinc%>
		<% if trigger then expand 'rtt_codel', :for => trigger end %>
	<%idec%>
	}

	<%nl%>

	// stopHook()
	void <%= name %>::stopHook()
	{
	<%iinc%>
		// stop codel here
	<%idec%>
	}

	<%nl%>

	// cleanupHook
	void <%= name %>::cleanupHook()
	{
	<%iinc%>
		<% if final then expand 'rtt_codel', :for => final end %>
	<%idec%>
	}
	<%nl%>
	<% expand 'input_port_handler', :foreach => ports.select { |p| p.class == Bcm::InputPort && p.callback } %>
<%idec%>
}
<%end%>
<%end%>
