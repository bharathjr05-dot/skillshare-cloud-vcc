<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DBUtil, java.sql.*" %>
<%
  String msg = "";
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String fullname = request.getParameter("fullname");
    String email = request.getParameter("email");

    if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
      msg = "Username and password are required.";
    } else if (password.length() < 8) {
      msg = "Use a password with at least 8 characters.";
    } else {
      Connection conn = null;
      PreparedStatement ps = null;
      try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement("INSERT INTO users(username,password,full_name,email) VALUES(?,?,?,?)");
        ps.setString(1, username);
        ps.setString(2, util.PasswordUtil.hash(password));
        ps.setString(3, fullname);
        ps.setString(4, email);
        ps.executeUpdate();
        response.sendRedirect("login.jsp?registered=1");
        return;
      } catch (SQLException e) {
        if (e.getSQLState() != null && e.getSQLState().startsWith("23")) msg = "Username already exists.";
        else msg = "Error: " + e.getMessage();
      } finally {
        try { if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){}
      }
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Register - SkillShare Cloud</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
  <header>
    <div class="logo">SkillShare Cloud</div>
    <nav>
      <a href="index.jsp">Home</a>
      <a href="login.jsp">Login</a>
    </nav>
  </header>

  <h2>Register</h2>
  <% if (!msg.isEmpty()) { %>
    <div class="flash"><%= msg %></div>
  <% } %>

  <form method="post" action="register.jsp">
    <label>Username</label>
    <input type="text" name="username" required />

    <label>Password</label>
    <input type="password" name="password" minlength="8" required />

    <label>Full name</label>
    <input type="text" name="fullname" />

    <label>Email</label>
    <input type="email" name="email" />

    <button type="submit">Register</button>
  </form>
</div>
</body>
</html>
