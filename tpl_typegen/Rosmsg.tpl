# Type model entry templates

# ROS message file

<% define 'Root_rosmsg', :for => CompositeType do %>
   <% file name+'.msg' do %>
     <% expand 'Subtype', :foreach => subtypes %>
   <%end%>
<%end%>

<% define 'Subtype', :for => PrimitiveSubtype do %>
   <%= name %> <%= typeid.to_s %>
<%end%>

<% define 'Subtype', :for => CompositeSubtype do %>
   <%= name %> <%= typeid.name %>
<%end%>
