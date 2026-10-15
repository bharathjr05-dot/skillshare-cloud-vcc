<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DBUtil, java.sql.*" %>
<%
  Integer userId = (Integer) request.getSession().getAttribute("userId");
  if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
  }
  String userName = (String) request.getSession().getAttribute("userName");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard - SkillShare Cloud</title>
  <link rel="stylesheet" href="css/style.css" />
  <script src="js/main.js"></script>
</head>
<body>
<div class="container">
  <header>
    <div>
      <div class="logo">SkillShare Cloud</div>
      <div class="small">Hello, <strong><%= userName %></strong></div>
    </div>
    <nav>
      <a href="dashboard.jsp">Dashboard</a>
      <a href="addSkill.jsp">Add Skill</a>
      <a href="requests.jsp">Requests</a>
      <a href="logout.jsp">Logout</a>
    </nav>
  </header>

  <h2>Your Skills</h2>
  <% String msg = (String) request.getAttribute("msg"); if (msg != null) { %>
    <div class="flash"><%= msg %></div>
  <% } %>

  <% 
    Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
    try {
      conn = DBUtil.getConnection();
      ps = conn.prepareStatement("SELECT id, title, description, location, created_at FROM skills WHERE user_id = ? ORDER BY created_at DESC");
      ps.setInt(1, userId);
      rs = ps.executeQuery();
  %>
    <table class="table">
      <tr><th>Title</th><th>Description</th><th>Location</th><th>Actions</th></tr>
      <%
        boolean any=false;
        while (rs.next()) { any=true;
      %>
      <tr>
        <td><a href="viewSkill.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("title") %></a></td>
        <td><%= rs.getString("description")!=null && rs.getString("description").length()>120 ? rs.getString("description").substring(0,120)+"..." : rs.getString("description") %></td>
        <td><%= rs.getString("location") %></td>
        <td class="actions">
          <a href="editSkill.jsp?id=<%= rs.getInt("id") %>">Edit</a>
          <a href="deleteSkill.jsp?id=<%= rs.getInt("id") %>" onclick="return confirmDelete();">Delete</a>
        </td>
      </tr>
      <% } if (!any) { %>
        <tr><td colspan="4" class="center">You have not added any skills yet. <a href="addSkill.jsp">Add one</a>.</td></tr>
      <% } %>
    </table>
  <% } catch (Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); }
     finally { try { if (rs!=null) rs.close(); if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){} }
  %>

  <h2>All Skills (Community)</h2>
  <% 
    Connection c2 = null; PreparedStatement p2 = null; ResultSet r2 = null;
    try {
      c2 = DBUtil.getConnection();
      p2 = c2.prepareStatement("SELECT s.id,s.title,s.description,s.location,u.full_name FROM skills s JOIN users u ON s.user_id=u.id ORDER BY s.created_at DESC");
      r2 = p2.executeQuery();
  %>
    <table class="table">
      <tr><th>Title</th><th>Owner</th><th>Location</th><th>Action</th></tr>
      <%
        while (r2.next()) {
      %>
        <tr>
          <td><a href="viewSkill.jsp?id=<%= r2.getInt("id") %>"><%= r2.getString("title") %></a></td>
          <td><%= r2.getString("full_name") %></td>
          <td><%= r2.getString("location") %></td>
          <td><a href="viewSkill.jsp?id=<%= r2.getInt("id") %>">View</a></td>
        </tr>
      <%
        }
      %>
    </table>
  <% } catch(Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); } finally { try { if (r2!=null) r2.close(); if (p2!=null) p2.close(); if (c2!=null) c2.close(); } catch(Exception e){} } %>

</div>
</body>
</html>
