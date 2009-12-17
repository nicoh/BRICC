
#
# CMakeLists.txt (OCL style)
#
<% define 'OCL_cmake', :for => Component do %>
<% file 'CMakeLists.txt' do %>

DEPENDENT_OPTION( BUILD_<%= comp_name.upcase %> "Build <%= comp_name %> component" ON "BUILD TASKBROWSER" OFF)

<%nl%>

IF ( BUILD_<%= comp_name.upcase %> )
<%iinc%>
	FILE( GLOB SRCS [^.]*.cpp )
	FILE( GLOB HPPS [^.]*.hpp )
	ADD_EXECUTABLE( <%= comp_name %> ${SRCS} )
	GLOBAL_ADD_COMPONENT( orocos-<%= comp_name %> ${SRCS} )
	TARGET_LINK_LIBRARIES( <%= comp_name %> ${OROCOS_RTT_LIBS} )
	PROGRAM_ADD_DEPS( <%= comp_name %> orocos-taskbrowser )
<%idec%>
ENDIF ( BUILD_<%= comp_name.upcase %> )
<%end%>
<%end%>
