<%@ page import="util.DBUtil, java.sql.*" %>
<%
  String idStr = request.getParameter("id");
  if (idStr == null) { response.sendRedirect("dashboard.jsp"); return; }
  int id = Integer.parseInt(idStr);
  Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
  try {
    conn = DBUtil.getConnection();
    ps = conn.prepareStatement("SELECT s.id, s.title, s.description, s.location, u.full_name, u.id as owner_id FROM skills s JOIN users u ON s.user_id=u.id WHERE s.id=?");
    ps.setInt(1, id);
    rs = ps.executeQuery();
    if (!rs.next()) { out.println("<p>Skill not found</p>"); return; }
    int ownerId = rs.getInt("owner_id");
    String ownerName = rs.getString("full_name");
    String title = rs.getString("title");
    String description = rs.getString("description");
    String location = rs.getString("location");
%>
<!DOCTYPE html>
<html>
<head>
  <title><%= title %> - SkillShare Cloud</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="container">
  <header>
    <div class="logo">SkillShare Cloud</div>
    <nav>
      <a href="dashboard.jsp">Dashboard</a>
      <a href="logout.jsp">Logout</a>
    </nav>
  </header>

  <h2><%= title %></h2>
  <p><strong>Owner:</strong> <%= ownerName %></p>
  <p><strong>Location:</strong> <%= location %></p>
  <p><strong>Description:</strong></p>
  <p><%= description %></p>

  <% Integer currentUser = (Integer) request.getSession().getAttribute("userId"); 
     if (currentUser != null && currentUser != ownerId) { %>
    <h3>Request a session</h3>
    <form method="post" action="sendRequest.jsp">
      <input type="hidden" name="skill_id" value="<%= id %>" />
      <input type="hidden" name="to_user_id" value="<%= ownerId %>" />
      <label>Message (optional)</label>
      <textarea name="message" rows="4">Hi, I am interested in learning "<%= title %>". Please let me know your available slots.</textarea>
      <button type="submit">Send Request</button>
    </form>
  <% } else if (currentUser == null) { %>
    <p class="small">Login to request a session.</p>
  <% } else { %>
    <p class="small">This is your skill listing.</p>
  <% } %>

</div>
</body>
</html>
<%
  } catch (Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); }
  finally { try { if (rs!=null) rs.close(); if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){} }
%>
