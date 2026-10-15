<%@ page import="util.DBUtil, java.sql.*" %>
<%
  Integer fromUser = (Integer) request.getSession().getAttribute("userId");
  if (fromUser == null) { response.sendRedirect("login.jsp"); return; }
  String skillIdStr = request.getParameter("skill_id");
  String toUserStr = request.getParameter("to_user_id");
  String message = request.getParameter("message");
  if (skillIdStr == null || toUserStr == null) { response.sendRedirect("dashboard.jsp"); return; }
  int skillId = Integer.parseInt(skillIdStr);
  int toUser = Integer.parseInt(toUserStr);

  Connection conn = null; PreparedStatement ps = null;
  try {
    conn = DBUtil.getConnection();
    ps = conn.prepareStatement("INSERT INTO requests(skill_id, from_user_id, to_user_id, message) VALUES(?,?,?,?)");
    ps.setInt(1, skillId);
    ps.setInt(2, fromUser);
    ps.setInt(3, toUser);
    ps.setString(4, message);
    ps.executeUpdate();
  } catch (Exception e) {
    out.println("<p>Error: "+e.getMessage()+"</p>");
  } finally {
    try { if (ps!=null) ps.close(); if (conn!=null) conn.close(); } catch(Exception e){}
  }
  response.sendRedirect("requests.jsp");
%>
