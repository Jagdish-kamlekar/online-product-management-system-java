<%@ page import="java.sql.*"%>
<%@ page import="com.util.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
if (session.getAttribute("email") == null || !"admin".equals(session.getAttribute("role"))) {
	response.sendRedirect("index.jsp");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Orders | PMS</title>

<style>
*{
	margin:0;
	padding:0;
	box-sizing:border-box;
	font-family:'Segoe UI', Arial, sans-serif;
}

/* 🌈 Animated Gradient Background */
body{
	min-height:100vh;
	background:linear-gradient(270deg,#667eea,#764ba2,#43cea2);
	background-size:600% 600%;
	animation:bgMove 12s ease infinite;
	padding:60px 20px;
}

@keyframes bgMove{
	0%{background-position:0% 50%;}
	50%{background-position:100% 50%;}
	100%{background-position:0% 50%;}
}

/* Container */
.container{
	width:92%;
	max-width:1100px;
	margin:auto;
}

/* Title */
h2{
	text-align:center;
	color:#fff;
	font-size:28px;
	margin-bottom:25px;
	text-shadow:0 3px 12px rgba(0,0,0,0.4);
}

/* 🔙 Back Button (Chrome + Neon) */
.back-btn{
	display:inline-block;
	margin-bottom:25px;
	padding:12px 26px;
	border-radius:30px;
	font-weight:bold;
	color:#000;
	background:linear-gradient(135deg,#ffd36e,#ffc107,#ffb300);
	text-decoration:none;
	box-shadow:0 10px 30px rgba(255,193,7,0.6);
	transition:.35s;
}

.back-btn:hover{
	transform:translateY(-2px) scale(1.05);
	box-shadow:0 18px 45px rgba(255,193,7,0.85);
}

/* 🧊 Glass Order Card */
.order-card{
	background:rgba(255,255,255,0.92);
	backdrop-filter:blur(18px);
	padding:25px;
	border-radius:26px;
	margin-bottom:30px;
	box-shadow:0 35px 70px rgba(0,0,0,0.4);
	animation:fadeUp .7s ease;
}

/* Order Header */
.order-card b{
	color:#4b3f72;
}

/* Actions */
.order-actions{
	margin-top:15px;
}

/* 3D Neon Buttons */
.order-actions button{
	padding:10px 22px;
	border:none;
	border-radius:30px;
	font-weight:bold;
	cursor:pointer;
	color:white;
	margin-right:12px;
	transition:.35s;
	box-shadow:0 12px 28px rgba(0,0,0,0.3);
}

.approve{
	background:linear-gradient(135deg,#43e97b,#38f9d7);
}

.cancel{
	background:linear-gradient(135deg,#ff416c,#ff4b2b);
}

.order-actions button:hover{
	transform:translateY(-3px) scale(1.06);
	box-shadow:0 22px 45px rgba(0,0,0,0.45);
}

/* 📊 Table */
.order-table{
	width:100%;
	border-collapse:collapse;
	margin-top:18px;
	border-radius:18px;
	overflow:hidden;
}

.order-table th,
.order-table td{
	padding:14px;
	text-align:center;
	border-bottom:1px solid rgba(0,0,0,0.06);
}

.order-table th{
	background:linear-gradient(135deg,#667eea,#764ba2);
	color:white;
	font-size:15px;
}

.order-table tr{
	transition:.3s;
}

.order-table tr:hover{
	background:rgba(102,126,234,0.1);
	transform:scale(1.01);
}

/* Animation */
@keyframes fadeUp{
	from{
		opacity:0;
		transform:translateY(35px);
	}
	to{
		opacity:1;
		transform:translateY(0);
	}
}
</style>
</head>

<body>

<div class="container">

	<h2>📦 Admin Order Management</h2>

	<a href="<%=request.getContextPath()%>/adminDashboard.jsp" class="back-btn">
		⬅ Back to Dashboard
	</a>

	<!-- Message -->
	<%
	String msg = (String) session.getAttribute("msg");
	if (msg != null) {
	%>
	<script>alert("<%=msg%>");</script>
	<%
	session.removeAttribute("msg");
	}
	%>

	<%
	Connection con = DBConnection.getConnection();
	PreparedStatement ps = con.prepareStatement(
		"SELECT * FROM orders ORDER BY order_id DESC");
	ResultSet rs = ps.executeQuery();

	while(rs.next()){
		int oid = rs.getInt("order_id");
		String status = rs.getString("status");
	%>

	<div class="order-card">

		<b>Order ID:</b> <%=oid%> |
		<b>User:</b> <%=rs.getString("user_email")%> |
		<b>Total:</b> ₹<%=rs.getDouble("total_amount")%> |
		<b>Status:</b> <%=status%>

		<% if("PLACED".equals(status)){ %>
		<div class="order-actions">

			<form action="<%=request.getContextPath()%>/AdminOrderActionServlet"
				method="post" style="display:inline;">
				<input type="hidden" name="orderId" value="<%=oid%>">
				<button name="action" value="APPROVED" class="approve">
					✔ Approve
				</button>
			</form>

			<form action="<%=request.getContextPath()%>/AdminOrderActionServlet"
				method="post" style="display:inline;">
				<input type="hidden" name="orderId" value="<%=oid%>">
				<button name="action" value="CANCELLED" class="cancel">
					❌ Cancel
				</button>
			</form>

		</div>
		<% } %>

		<table class="order-table">
			<tr>
				<th>Product</th>
				<th>Price</th>
				<th>Qty</th>
				<th>Total</th>
			</tr>

			<%
			PreparedStatement psItems = con.prepareStatement(
				"SELECT * FROM order_items WHERE order_id=?");
			psItems.setInt(1, oid);
			ResultSet rsItems = psItems.executeQuery();

			while(rsItems.next()){
			%>
			<tr>
				<td><%=rsItems.getString("pname")%></td>
				<td>₹ <%=rsItems.getDouble("price")%></td>
				<td><%=rsItems.getInt("quantity")%></td>
				<td>₹ <%=rsItems.getDouble("price") * rsItems.getInt("quantity")%></td>
			</tr>
			<%
			}
			rsItems.close();
			psItems.close();
			%>
		</table>

	</div>

	<%
	}
	rs.close();
	ps.close();
	con.close();
	%>

</div>

</body>
</html>
