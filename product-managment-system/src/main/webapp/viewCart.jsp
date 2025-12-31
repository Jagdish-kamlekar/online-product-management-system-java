<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>

<%
String email = (String) session.getAttribute("email");
double grandTotal = 0;
%>

<h2 align="center">🛒 My Cart</h2>

<table border="1" width="80%" align="center">
<tr>
<th>Name</th><th>Price</th><th>Qty</th><th>Total</th>
</tr>

<%
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM cart WHERE user_email=?");
ps.setString(1, email);
ResultSet rs = ps.executeQuery();

while(rs.next()){
double total = rs.getDouble("price") * rs.getInt("quantity");
grandTotal += total;
%>
<tr>
<td><%=rs.getString("pname")%></td>
<td>₹ <%=rs.getDouble("price")%></td>
<td><%=rs.getInt("quantity")%></td>
<td>₹ <%=total%></td>
</tr>
<% } %>

<tr>
<th colspan="3">Grand Total</th>
<th>₹ <%=grandTotal%></th>
</tr>
</table>

<form action="PlaceOrderServlet" method="post" align="center">
    <input type="submit" value="Place Order">
</form>
