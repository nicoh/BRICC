################################################################################
# Component Makefile
################################################################################

<% define 'rtc_makefile', :for => Component do %>
<% file 'src/Makefile.'+name do %>

CXXFLAGS = `rtm-config --cflags` -I.
LDFLAGS = `rtm-config --libs`
SHFLAGS = -shared

OBJS = <%= name %>.o

.SUFFIXES : .so

all: <%= name %>.so <%= name %>Comp

.cpp.o:
<%iinc%>
    rm -f $@
    $(CXX) $(CXXFLAGS) -c -o $@ $<
<%idec%>

.o.so:
<%iinc%>
    rm -f $@
    $(CXX) $(SHFLAGS) -o $@ $(OBJS) $(LDFLAGS)
<%idec%>

<%= name %>Comp: <%= name %>Comp.o $(OBJS)
<%iinc%>
    $(CXX) -o $@ $(OBJS) <%= name %>Comp.o $(LDFLAGS)
<%idec%>

clean: clean_objs
<%iinc%>
    rm -f *~
<%idec%>

clean_objs:
<%iinc%>
    rm -f $(OBJS) <%= name %>Comp.o <%= name %>.so <%= name %>Comp
<%idec%>

<%= name %>.so: $(OBJS)
<%= name %>.o: <%= name %>.h
<%= name %>Comp.o: <%= name %>Comp.cpp <%= name %>.cpp <%= name %>.h

<%end%>
<%end%>

