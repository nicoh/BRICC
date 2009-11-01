<% define 'Root' , :for => Component do %>
    <%file name+'.hpp' do %>
#include <rtt/TaskContext.hpp>
#include <rtt/Logger.hpp>
#include <rtt/Property.hpp>
#include <rtt/Attribute.hpp>
#include <rtt/Method.hpp>
#include <rtt/Command.hpp>
#include <rtt/Event.hpp>
#include <rtt/Ports.hpp>

#include <ocl/OCL.hpp>
        
using namespace std;
using namespace RTT;
using namespace Orocos;

namespace OCL 
{<%iinc%>
	class name : public TaskContext 
        {
	protected: <%iinc%>
             <% expand 'prop_templ', for => type, init_val, desc %>
        };
}
    <% end %>
<% end %>

<% define 'prop_templ' : for => Property do %>
   Property<%<type> name%>
<% end %>
