<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>SkillShare Cloud</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
  <header>
    <div class="logo">SkillShare Cloud</div>
    <nav>
      <a href="index.jsp">Home</a>
      <a href="register.jsp">Register</a>
      <a href="login.jsp">Login</a>
    </nav>
  </header>

  <h2>Welcome to SkillShare Cloud</h2>
  <p class="small">A simple community platform to list skills, request sessions, and connect.</p>

  <div style="display:flex; gap:20px; margin-top:20px;">
    <div style="flex:1">
      <h3>Featured Skills</h3>
      <%@ page import="java.sql.*, util.DBUtil" %>
      <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
          conn = DBUtil.getConnection();
          ps = conn.prepareStatement("SELECT s.id, s.title, s.description, s.location, u.full_name FROM skills s JOIN users u ON s.user_id=u.id ORDER BY s.created_at DESC LIMIT 5");
          rs = ps.executeQuery();
      %>
      <table class="table">
        <tr><th>Title</th><th>Owner</th><th>Location</th></tr>
        <%
          while (rs.next()) {
        %>
          <tr>
            <td><a href="viewSkill.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("title") %></a></td>
            <td><%= rs.getString("full_name") %></td>
            <td><%= rs.getString("location") %></td>
          </tr>
        <%
          }
        %>
      </table>
      <%
        } catch (Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); }
        finally { try { if (rs!=null) rs.close(); if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){} }
      %>
    </div>

    <div style="flex:1">
      <h3>Get Started</h3>
      <p>Register and list your first skill or explore skills and request a session.</p>
      <p><a href="register.jsp"><button>Register</button></a> <a href="login.jsp"><button>Login</button></a></p>
    </div>
  </div>
</div>
</body>
</html>
