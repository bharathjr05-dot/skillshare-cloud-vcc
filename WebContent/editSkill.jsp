<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DBUtil, java.sql.*" %>
<%
  Integer userId = (Integer) request.getSession().getAttribute("userId");
  if (userId == null) { response.sendRedirect("login.jsp"); return; }

  String idStr = request.getParameter("id");
  if (idStr == null) { response.sendRedirect("dashboard.jsp"); return; }
  int id = Integer.parseInt(idStr);

  String msg = "";
  Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
  try {
    conn = DBUtil.getConnection();
    ps = conn.prepareStatement("SELECT user_id, title, description, location FROM skills WHERE id=?");
    ps.setInt(1, id);
    rs = ps.executeQuery();
    if (!rs.next()) { response.sendRedirect("dashboard.jsp"); return; }
    if (rs.getInt("user_id") != userId) { out.println("<p>Unauthorized</p>"); return; }
    String title = rs.getString("title");
    String description = rs.getString("description");
    String location = rs.getString("location");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
      String ntitle = request.getParameter("title");
      String ndesc = request.getParameter("description");
      String nloc = request.getParameter("location");
      PreparedStatement u = conn.prepareStatement("UPDATE skills SET title=?, description=?, location=? WHERE id=?");
      u.setString(1, ntitle);
      u.setString(2, ndesc);
      u.setString(3, nloc);
      u.setInt(4, id);
      u.executeUpdate();
      u.close();
      response.sendRedirect("dashboard.jsp");
      return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Skill</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
  <header><div class="logo">SkillShare Cloud</div><nav><a href="dashboard.jsp">Dashboard</a></nav></header>

  <h2>Edit Skill</h2>
  <% if (!msg.isEmpty()) { %><div class="flash"><%= msg %></div><% } %>
  <form method="post" action="editSkill.jsp?id=<%= id %>">
    <label>Title</label>
    <input type="text" name="title" value="<%= title %>" required />
    <label>Description</label>
    <textarea name="description" rows="6"><%= description %></textarea>
    <label>Location</label>
    <input type="text" name="location" value="<%= location %>" />
    <button type="submit">Update Skill</button>
  </form>
</div>
</body>
</html>
<%
  } catch (Exception e) {
    out.println("<p>Error: "+e.getMessage()+"</p>");
  } finally {
    try { if (rs!=null) rs.close(); if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){}
  }
%>
