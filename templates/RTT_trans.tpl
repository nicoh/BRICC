# Root
<% define 'Root', :foreach => Component do %>
<% file "Bla.hpp" do %>

<% expand 'IfdefHeader', "XYZComp" %>
<% expand 'rtt_headers' %>
<%nl%>
<% expand 'rtt_namespaces' %>
<%nl%>

namespace OCL
{<% iinc %>
        class <%= name %> : public TaskContext
        {
            protected:
            <% iinc %>
            // Properties
            <% expand 'prop_templ', :foreach => props %>
            <%nl%>
            // Ports
            <% expand 'port_templ', :foreach => ports %>
            <% idec %>
        };<% idec %>
}
<% expand 'IfdefFooter', "HUALA" %>
    <% end %>
<% end %>

# prop_templ
<% define 'prop_templ', :for => Property do %>
Property<<%= prop_type %>> <%= name %>;
<% end %>

# Ports
<% define 'port_templ', :for => Port do %>
InputPort<<%= port_type %>> <%= name %>;
<% end %>

# ifdef header
<% define 'IfdefHeader', :for => Object do |name| %>
   #ifndef __<%= name.upcase %>__
   #define __<%= name.upcase %>__
        <%nl%>
<% end %>

# ifdef footer
<% define 'IfdefFooter', :for => Object do |name| %>
   <%nl%>
   #endif // __<%= name.upcase %>__
   <%nl%>
<% end %>

# rtt namespaces
<% define 'rtt_namespaces' do %>
using namespace std;
using namespace RTT;
using namespace Orocos;
<% end %>

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
<% end %>
