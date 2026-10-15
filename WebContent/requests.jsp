<%@ page import="util.DBUtil, java.sql.*" %>
<%
  Integer userId = (Integer) request.getSession().getAttribute("userId");
  if (userId == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Requests - SkillShare Cloud</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
  <header>
    <div class="logo">SkillShare Cloud</div>
    <nav>
      <a href="dashboard.jsp">Dashboard</a>
      <a href="addSkill.jsp">Add Skill</a>
      <a href="logout.jsp">Logout</a>
    </nav>
  </header>

  <h2>Incoming Requests (To you)</h2>
  <%
    Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
    try {
      conn = DBUtil.getConnection();
      String sql = "SELECT r.id, r.message, r.status, r.created_at, u.full_name as from_name, s.title FROM requests r JOIN users u ON r.from_user_id=u.id JOIN skills s ON r.skill_id=s.id WHERE r.to_user_id = ? ORDER BY r.created_at DESC";
      ps = conn.prepareStatement(sql);
      ps.setInt(1, userId);
      rs = ps.executeQuery();
  %>
    <table class="table">
      <tr><th>From</th><th>Skill</th><th>Message</th><th>Status</th><th>Action</th></tr>
      <%
        while (rs.next()) {
      %>
        <tr>
          <td><%= rs.getString("from_name") %></td>
          <td><%= rs.getString("title") %></td>
          <td><%= rs.getString("message") %></td>
          <td><%= rs.getString("status") %></td>
          <td>
            <a href="requests.jsp?action=accept&id=<%= rs.getInt("id") %>">Accept</a> |
            <a href="requests.jsp?action=reject&id=<%= rs.getInt("id") %>">Reject</a>
          </td>
        </tr>
      <%
        }
      %>
    </table>
  <% } catch(Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); } finally { try { if (rs!=null) rs.close(); if (ps!=null) ps.close(); } catch(Exception e){} } %>

  <h2 style="margin-top:20px;">Sent Requests (By you)</h2>
  <%
    PreparedStatement p2 = null; ResultSet r2 = null;
    try {
      String sql2 = "SELECT r.id, r.message, r.status, r.created_at, u.full_name as to_name, s.title FROM requests r JOIN users u ON r.to_user_id=u.id JOIN skills s ON r.skill_id=s.id WHERE r.from_user_id = ? ORDER BY r.created_at DESC";
      p2 = conn.prepareStatement(sql2);
      p2.setInt(1, userId);
      r2 = p2.executeQuery();
  %>
    <table class="table">
      <tr><th>To</th><th>Skill</th><th>Message</th><th>Status</th></tr>
      <%
        while (r2.next()) {
      %>
        <tr>
          <td><%= r2.getString("to_name") %></td>
          <td><%= r2.getString("title") %></td>
          <td><%= r2.getString("message") %></td>
          <td><%= r2.getString("status") %></td>
        </tr>
      <%
        }
      %>
    </table>
  <%
    } catch(Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); }
    finally { try { if (r2!=null) r2.close(); if (p2!=null) p2.close(); if (conn!=null) conn.close(); } catch(Exception e){} }
  %>

<%
  // Accept / Reject actions handled below to keep page reload simple
  String action = request.getParameter("action");
  String rid = request.getParameter("id");
  if (action != null && rid != null) {
    try {
      Connection c3 = DBUtil.getConnection();
      PreparedStatement u = c3.prepareStatement("UPDATE requests SET status=? WHERE id=? AND to_user_id=?");
      if ("accept".equalsIgnoreCase(action)) u.setString(1, "ACCEPTED"); else u.setString(1, "REJECTED");
      u.setInt(2, Integer.parseInt(rid));
      u.setInt(3, userId);
      u.executeUpdate();
      u.close();
      c3.close();
      response.sendRedirect("requests.jsp");
      return;
    } catch(Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); }
  }
%>

</div>
</body>
</html>
