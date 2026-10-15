<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DBUtil, java.sql.*" %>
<%
  String msg = "";
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username == null || password == null || username.trim().isEmpty()) {
      msg = "Enter credentials.";
    } else {
      Connection conn = null;
      PreparedStatement ps = null;
      ResultSet rs = null;
      try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement("SELECT id, full_name, password FROM users WHERE username=?");
        ps.setString(1, username);
        rs = ps.executeQuery();
        if (rs.next() && (util.PasswordUtil.isHashed(rs.getString("password"))
                ? util.PasswordUtil.verify(password, rs.getString("password"))
                : password.equals(rs.getString("password")))) {
          if (!util.PasswordUtil.isHashed(rs.getString("password"))) {
            try (PreparedStatement upgrade = conn.prepareStatement("UPDATE users SET password=? WHERE id=? AND password=?")) {
              upgrade.setString(1, util.PasswordUtil.hash(password));
              upgrade.setInt(2, rs.getInt("id"));
              upgrade.setString(3, rs.getString("password"));
              upgrade.executeUpdate();
            }
          }
          request.getSession().setAttribute("userId", rs.getInt("id"));
          request.getSession().setAttribute("userName", rs.getString("full_name") != null ? rs.getString("full_name") : username);
          response.sendRedirect("dashboard.jsp");
          return;
        } else {
          msg = "Invalid username/password.";
        }
      } catch (Exception e) {
        msg = "Error: " + e.getMessage();
      } finally {
        try { if (rs!=null) rs.close(); if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){}
      }
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Login - SkillShare Cloud</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
  <header>
    <div class="logo">SkillShare Cloud</div>
    <nav>
      <a href="index.jsp">Home</a>
      <a href="register.jsp">Register</a>
    </nav>
  </header>

  <h2>Login</h2>
  <% if ("1".equals(request.getParameter("registered"))) { %>
    <div class="flash">Registration successful! Please login.</div>
  <% } %>
  <% if (!msg.isEmpty()) { %>
    <div class="flash"><%= msg %></div>
  <% } %>

  <form method="post" action="login.jsp">
    <label>Username</label>
    <input type="text" name="username" required />
    <label>Password</label>
    <input type="password" name="password" required />
    <button type="submit">Login</button>
  </form>
</div>
</body>
</html>
