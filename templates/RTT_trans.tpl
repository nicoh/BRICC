<% define 'Root' do %>
<% file 'testout.hpp' do %>

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
using namespace std;
using namespace RTT;
using namespace Orocos;
<%nl%>
namespace OCL
{<% iinc %>
	class <%= name %> : public TaskContext
	{
	protected: <% iinc %>
	     <% expand 'prop_templ', :foreach => prop %> <% idec %>
	};<% idec %>
}
    <% end %>
<% end %>

<% define 'prop_templ', :for => Property do %>
Property <<%= valtype %>> <%= name %>;
<% end %>
