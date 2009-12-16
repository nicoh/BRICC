################################################################################
# Component hpp file
################################################################################

<% define 'rtt_hpp', :for => Component do %>
<% file 'src/'+comp_name+'.hpp' do %>

<% expand 'ifdef_header', comp_name.upcase %>
<% expand 'rtt_headers' %>
<% expand 'codel_templ', :for => header_codel %>
<% expand 'rtt_namespaces' %>

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
        public:
        <%iinc%>
                /***
                * Constructor
                * @ param the component name
                */
                <%= comp_name %>(std::string name);
                <%nl%>

                /***
                * Destructor
                */
                ~<%= comp_name %>();
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

<% expand 'ifdef_footer', comp_name.upcase %>

<%end%>
<%end%>

# codel, just insert opaque code in here
<% define 'codel_templ', :for => Codel do %>
   <%= code %>
   <%nl%>
<%end%>

# prop_templ
<% define 'prop_templ', :for => Property do %>
Property<<%= prop_type %> > <%= name %>;
<%end%>


# Ports
<% define 'port_templ', :for => Port do %>
  <% if dir == :in %>
        ReadBufferPort<<%= port_type %> > <%= name %>;
  <% elsif dir == :out %>
        WriteBufferPort<<%= port_type %> > <%= name %>;
  <% else %>
        ReadWritePort<<%= port_type %> > <%= name %>;
  <% end %>
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
<% define 'port_ctr_init', :for => Port do %>
   <% if dir == :in %>
      , <%= name %>("<%= name %>")
   <% elsif dir == :out %>
   , <%= name %>("<%= name %>", <%= size or 1 %><% if initial then %>, <%= initial %><%end%>)
   <% else %>
   , <%= name %>("<%= name %>", <%= size or 1 %><% if initial then %>, <%= initial %><%end%>)
   <% end %>
<%end%>

# assert that obj is ready


#
# Component CPP
#
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

namespace OCL
{
<%iinc%>
        // Constructor
        <%= comp_name %>::<%= comp_name %>(std::string name)
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
        <%= comp_name %>::~<%= comp_name %>()
        {
        }

        <%nl%> <%nl%>

        // configureHook
        bool <%= comp_name %>::configureHook()
        {
        <%iinc%>
                return false;
        <%idec%>
        }

        <%nl%>

        // startHook()
        bool <%= comp_name %>::startHook()
        {
        <%iinc%>
                return false;
        <%idec%>
        }

        <%nl%>

        // updateHook
        void <%= comp_name %>::updateHook()
        {
        <%iinc%>
                // tbd
        <%idec%>
        }

        <%nl%>

        // stopHook()
        void <%= comp_name %>::stopHook()
        {
        <%iinc%>
                // stop codel here
        <%idec%>
        }

        <%nl%>

        // cleanupHook
        void <%= comp_name %>::cleanupHook()
        {
        <%iinc%>
                // cleanup codel here
        <%idec%>
        }
<%idec%>
}


<%end%>
<%end%>
