################################################################################
# Component hpp file
################################################################################

<% define 'rtt_hpp', :for => Component do %>
<% file 'src/'+name+'.hpp' do %>

<% expand 'ifdef_header', name.upcase %>
<% expand 'rtt_headers' %>
<% expand '/common::codel_templ', :for => header %> <%nl%>
<% expand 'rtt_namespaces' %>

namespace OCL
{
<%iinc%>
        class <%= name %> : public TaskContext
        {
        protected:
        <%iinc%>
                // Properties
                <% expand 'prop_templ', :foreach => props %> <%nl%>
                // Ports
                <% expand 'port_templ', :foreach => ports %>
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
                bool startHook();
                void updateHook();
                void stopHook();
                void cleanupHook();
        <%idec%>
        };
<%idec%>
}

<% expand 'ifdef_footer', name.upcase %>

<%end%>
<%end%>

# prop_templ
<% define 'prop_templ', :for => Property do %>
Property<<% expand '/typemodel::type_templ', :for => typeid %>> <%= name %>;
<%end%>

# Ports
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

# Property contstructor initalizer
<% define 'prop_ctr_init', :for => Property do %>
   , <%= name %>("<%= name %>", "<%= desc %>", <%= value %>)
<%end%>

# Port constructor initializer
<% define 'port_ctr_init', :for => InputPort do %>
   , <%= name %>("<%= name %>")
<%end%>

# tbd: initial value (annotation?)
<% define 'port_ctr_init', :for => OutputPort do %>
   , <%= name %>("<%= name %>", <%= size or 1 %>)
<%end%>

# assert that obj is ready


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
                <% expand 'prop_ctr_init', :foreach => props %>
                <% expand 'port_ctr_init', :foreach => ports %>
        <%idec%>
        {
        <%iinc%>
                // tbd add stuff to interface here
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
		   <% expand '/common::codel_templ', :for => init %>
		<% else %>
		   return true;
		<% end %>
        <%idec%>
        }

        <%nl%>

        // startHook()
        bool <%= name %>::startHook()
        {
        <%iinc%>
                return false;
        <%idec%>
        }

        <%nl%>

        // updateHook
        void <%= name %>::updateHook()
        {
        <%iinc%>
		<% expand '/common::codel_templ', :for => trigger %>
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
		<% if final then expand '/common::codel_templ', :for => final end %>
        <%idec%>
        }
<%idec%>
}


<%end%>
<%end%>
