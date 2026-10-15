<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DBUtil, java.sql.*" %>
<%
  Integer userId = (Integer) request.getSession().getAttribute("userId");
  if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
  }
  String msg = "";
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String location = request.getParameter("location");
    if (title == null || title.trim().isEmpty()) {
      msg = "Title is required.";
    } else {
      Connection conn = null; PreparedStatement ps = null;
      try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement("INSERT INTO skills(user_id,title,description,location) VALUES(?,?,?,?)");
        ps.setInt(1, userId);
        ps.setString(2, title);
        ps.setString(3, description);
        ps.setString(4, location);
        ps.executeUpdate();
        response.sendRedirect("dashboard.jsp");
        return;
      } catch (Exception e) {
        msg = "Error: " + e.getMessage();
      } finally {
        try { if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){}
      }
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Add Skill - SkillShare Cloud</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
  <header>
    <div class="logo">SkillShare Cloud</div>
    <nav><a href="dashboard.jsp">Dashboard</a> <a href="logout.jsp">Logout</a></nav>
  </header>

  <h2>Add Skill</h2>
  <% if (!msg.isEmpty()) { %><div class="flash"><%= msg %></div><% } %>

  <form method="post" action="addSkill.jsp">
    <label>Title</label>
    <input type="text" name="title" required />
    <label>Description</label>
    <textarea name="description" rows="6"></textarea>
    <label>Location</label>
    <input type="text" name="location" />
    <button type="submit">Add Skill</button>
  </form>
</div>
</body>
</html>
