################################################################################
# Component hpp file
################################################################################

<% define 'rtc_h', :for => Component do %>
<% file 'src/'+name+'.h' do %>

<% expand 'ifdef_header', name.upcase %>

#include <rtm/Manager.h>
#include <rtm/DataFlowComponentBase.h>
#include <rtm/CorbaPort.h>
#include <rtm/DataInPort.h>
#include <rtm/DataOutPort.h>
#include <rtm/idl/BasicDataTypeSkel.h>

<% expand 'rtc_codel', :for => header %><%nl%>

using namespace RTC;

class <%= name %> : public DataFlowComponentBase
{
<%iinc%>
    public:
    <%iinc%>
        <%= name %>(RTC::Manager *manager);
        ~<%= name %>();
        <%nl%><%nl%>
        virtual RTC::ReturnCode_t onInitialize();
        virtual RTC::ReturnCode_t onActivated(RTC::UniqueId ec_id);
        virtual RTC::ReturnCode_t onDeactivated(RTC::UniqueId ec_id);
        virtual RTC::ReturnCode_t onExecute(RTC::UniqueId ec_id);
        <%nl%><%nl%>
    <%idec%>
    protected:
    <%iinc%>
        <% expand 'cp_var', :foreach => props %>
        <%nl%><%nl%>
        <% expand 'port_dec', :foreach => ports %>
    <%idec%>
<%idec%>
};

extern "C"
{
<%iinc%>
    DLL_EXPORT void <%= name %>Init(RTC::Manager *manager);
<%idec%>
};

<% expand 'ifdef_footer', name.upcase %>

<%end%>
<%end%>

# Configuration parameters
<% define 'cp_var', :for => Property do %>
<% expand '/typemodel::type_templ', :for => typeid %><%nl%><%= name %>;
<%end%>

# Input port declaration
<% define 'port_dec', :for => InputPort do %>
<% expand '/typemodel::type_templ', :for => typeid %><%nl%><%= name %>;
InPort<<% expand '/typemodel::type_templ', :for => typeid %>><%nl%><%= name %>In;
<%end%>

# Output port declaration
<% define 'port_dec', :for => OutputPort do %>
<% expand '/typemodel::type_templ', :for => typeid %><%nl%><%= name %>;
OutPort<<% expand '/typemodel::type_templ', :for => typeid %>><%nl%><%= name %>Out;
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

################################################################################
# Component cpp file
################################################################################

<% define 'rtc_cpp', :for => Component do %>
<% file 'src/'+name+'.cpp' do %>

#include "<%= name %>.h"

static const char *comp_spec[] =
{
<%iinc%>
    "implementation_id", "<%= name %>",
    "type_name", "<%= name %>",
    "description", "bricc generated component",
    "version", "1.0",
    "category", "bricc",
    "activity_type", "PERIODIC",
    "kind", "DataFlowComponent",
    "max_instance", "1",
    "language", "C++",
    "lang_type", "compile",
    "exec_cxt.periodic.rate", "1.0",
    <% expand 'cp_default_spec', :foreach => props %>
    ""
<%idec%>
};

<%= name %>::<%= name %>(RTC::Manager *manager)
<%iinc%>
    : RTC::DataFlowComponentBase(manager)
<% expand 'port_init', :foreach => ports %>
<%idec%>
{
}

<%= name %>::~<%= name %>()
{
}

RTC::ReturnCode_t <%= name %>::onInitialize()
{
<%iinc%>
    <% expand 'port_register', :foreach => ports %>

    <% expand 'cp_register', :foreach => props %>

    return RTC::RTC_OK;
<%idec%>
}
<%nl%><%nl%>
RTC::ReturnCode_t <%= name %>::onActivated(RTC::UniqueId ec_id)
{
<%iinc%>
    <% expand 'rtc_codel', :for => init %>
    return RTC::RTC_OK;
<%idec%>
}
<%nl%><%nl%>
RTC::ReturnCode_t <%= name %>::onDeactivated(RTC::UniqueId ec_id)
{
<%iinc%>
    <% if final then expand 'rtc_codel', :for => final end %>
    return RTC::RTC_OK;
<%idec%>
}
<%nl%><%nl%>
RTC::ReturnCode_t <%= name %>::onExecute(RTC::UniqueId ec_id)
{
<%iinc%>
    <% if trigger then expand 'rtc_codel', :for => trigger end %>
    <% expand 'port_handler', :foreach => ports.select { |p| p.class == Bcm::InputPort && p.callback } %>
    return RTC::RTC_OK;
<%idec%>
}
<%nl%><%nl%>
extern "C"
{
<%iinc%>
    void <%= name %>Init(RTC::Manager *manager)
    {
        coil::Properties profile(comp_spec);
        manager->registerFactory(profile, RTC::Create<<%= name %>>,
                                 RTC::Delete<<%= name %>>);
    }
<%idec%>
};

<%end%>
<%end%>

<% define 'cp_default_spec', :for => Property do %>
    "conf.default.<%= name %>", "<%= default_val %>",
<%end%>

<% define 'cp_register', :for => Property do %>
    bindParameter("<%= name %>", <%= name %>, "<%= default_val %>");
<%end%>

<% define 'port_init', :for => InputPort do %>
    ,<%= name %>In("<%= name %>", <%= name %>)
<%end%>

<% define 'port_init', :for => OutputPort do %>
    ,<%= name %>Out("<%= name %>", <%= name %>)
<%end%>

<% define 'port_register', :for => InputPort do %>
    registerInPort("<%= name %>", <%= name %>In);
<%end%>

<% define 'port_register', :for => OutputPort do %>
    registerOutPort("<%= name %>", <%= name %>Out);
<%end%>

<% define 'rtc_codel', :for => Bcm::Codel do %>
    <%= codel2rtc %>
<%end%>

<% define 'port_handler', :for => Bcm::InputPort do %>
    if (<%= name %>In.isNew())
    {
    <%iinc%>
        <%= name %>In.read();
        <% expand 'rtc_codel', :for => callback %>
    <%idec%>
    }
<%end%>

################################################################################
# Component stand-alone file
################################################################################

<% define 'rtc_standalone', :for => Component do %>
<% file 'src/'+name+'Comp.cpp' do %>

#include <rtm/Manager.h>
#include <iostream>
#include <string>
#include <stdlib.h>
#include "<%= name %>.h"

void ModuleInit(RTC::Manager *manager)
{
<%iinc%>
    <%= name %>Init(manager);
    RTC::RtcBase *comp;

    comp = manager->createComponent("<%= name %>");

    if (comp == NULL)
    {
    <%iinc%>
        std::cerr << "Component creation failed." << std::endl;
        abort();
    <%idec%>
    }
    return;
<%idec%>
}

int main (int argc, char **argv)
{
<%iinc%>
    RTC::Manager *manager;
    manager = RTC::Manager::init(argc, argv);
    manager->init(argc, argv);
    manager->setModuleInitProc(ModuleInit);
    manager->activateManager();
    manager->runManager();
    return 0;
<%idec%>
}

<%end%>
<%end%>

