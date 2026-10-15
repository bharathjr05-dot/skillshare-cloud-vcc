<%@ page import="util.DBUtil, java.sql.*" %>
<%
  Integer userId = (Integer) request.getSession().getAttribute("userId");
  if (userId == null) { response.sendRedirect("login.jsp"); return; }
  String idStr = request.getParameter("id");
  if (idStr == null) { response.sendRedirect("dashboard.jsp"); return; }
  int id = Integer.parseInt(idStr);

  Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
  try {
    conn = DBUtil.getConnection();
    ps = conn.prepareStatement("SELECT user_id FROM skills WHERE id=?");
    ps.setInt(1, id);
    rs = ps.executeQuery();
    if (rs.next()) {
      if (rs.getInt("user_id") == userId) {
        rs.close(); ps.close();
        ps = conn.prepareStatement("DELETE FROM skills WHERE id=?");
        ps.setInt(1, id);
        ps.executeUpdate();
      }
    }
  } catch (Exception e) {
    out.println("<p>Error: "+e.getMessage()+"</p>");
  } finally {
    try { if (rs!=null) rs.close(); if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){}
  }
  response.sendRedirect("dashboard.jsp");
%>
