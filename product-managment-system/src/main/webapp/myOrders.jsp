<%@ page import="java.sql.*"%>
<%@ page import="com.util.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
/* 🔐 CUSTOMER SESSION CHECK */
if (session.getAttribute("email") == null || !"customer".equals(session.getAttribute("role"))) {
	response.sendRedirect("index.jsp");
	return;
}
String email = (String) session.getAttribute("email");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Orders</title>

<style>
*{
	margin:0;
	padding:0;
	box-sizing:border-box;
	font-family:'Segoe UI',sans-serif;
}

/* 🌌 Animated Parallax Background */
body{
	min-height:100vh;
	background: linear-gradient(-45deg,#0f0c29,#302b63,#24243e,#1a1a40);
	background-size:400% 400%;
	animation:bgMove 15s ease infinite;
	color:#fff;
}
@keyframes bgMove{
	0%{background-position:0% 50%;}
	50%{background-position:100% 50%;}
	100%{background-position:0% 50%;}
}

/* Neon floating blobs */
.bg-circle{
	position:fixed;
	width:220px;
	height:220px;
	border-radius:50%;
	filter:blur(55px);
	opacity:.55;
	animation:float 10s infinite ease-in-out;
	z-index:-1;
}
.bg1{top:10%; left:5%; background:radial-gradient(circle,#00f0ff,#8f00ff);}
.bg2{bottom:12%; right:8%; background:radial-gradient(circle,#ff1a75,#ff616f); animation-delay:3s;}
@keyframes float{
	0%,100%{transform:translateY(0);}
	50%{transform:translateY(-40px);}
}

/* Container Glassmorphism */
.container{
	width:95%;
	max-width:1150px;
	margin:60px auto;
	background:rgba(255,255,255,0.12);
	backdrop-filter:blur(18px);
	padding:35px;
	border-radius:28px;
	border:1px solid rgba(255,255,255,0.25);
	box-shadow:0 35px 80px rgba(0,0,0,0.6);
	animation:fadeUp .8s ease;
}
@keyframes fadeUp{
	from{opacity:0; transform:translateY(40px);}
	to{opacity:1; transform:translateY(0);}
}

/* Header / Title */
h2{
	text-align:center;
	font-size:32px;
	margin-bottom:40px;
	background:linear-gradient(90deg,#00ffe0,#8f00ff,#ff00c8);
	-webkit-background-clip:text;
	-webkit-text-fill-color:transparent;
	text-shadow:0 0 2px rgba(0,255,224,0.6);
	animation:typewriter 2s steps(30) 1;
	overflow:hidden;
	white-space:nowrap;
	
}


/* Order Card Glass + Neon */
.order{
	background:rgba(255,255,255,0.18);
	border-radius:22px;
	padding:25px;
	margin-bottom:30px;
	box-shadow:0 25px 60px rgba(0,0,0,0.35);
	border:1px solid rgba(0,255,255,0.3);
	transition:.4s;
}
.order:hover{
	transform:translateY(-4px) scale(1.01);
	box-shadow:0 35px 80px rgba(0,255,255,0.35);
}

/* Order Header */
.order-header{
	display:flex;
	justify-content:space-between;
	align-items:center;
	flex-wrap:wrap;
	gap:15px;
	margin-bottom:18px;
}
.order-header b{
	color:#00ffe0;
	text-shadow:0 0 8px #00ffe0;
}

/* Cancel Button Neon */
.cancel-btn{
	background:linear-gradient(135deg,#ff1a75,#ff616f);
	color:white;
	border:none;
	padding:10px 22px;
	border-radius:30px;
	font-weight:bold;
	cursor:pointer;
	box-shadow:0 0 18px #ff1a75;
	transition:.3s;
}
.cancel-btn:hover{
	transform:translateY(-2px) scale(1.05);
	box-shadow:0 0 28px #ff1a75;
	filter:brightness(1.1);
}

/* Table Glass + Neon */
table{
	width:100%;
	border-collapse:collapse;
	border-radius:16px;
	overflow:hidden;
	margin-top:10px;
	backdrop-filter:blur(6px);
	background:rgba(255,255,255,0.06);
}
th{
	background:linear-gradient(135deg,#00f0ff,#8f00ff);
	color:white;
	padding:14px;
	font-size:15px;
	text-shadow:0 0 5px #fff;
}
td{
	padding:12px;
	text-align:center;
	color:#fff;
	font-size:14px;
}
tr:hover{
	background:rgba(0,255,224,0.08);
	transform:scale(1.01);
	box-shadow:inset 0 0 10px rgba(0,255,224,0.15);
}

/* Status colors */
.status-approved{color:#0f0; font-weight:bold; text-shadow:0 0 5px #0f0;}
.status-rejected{color:#f00; font-weight:bold; text-shadow:0 0 5px #f00;}
.status-cancelled{color:#ff0; font-weight:bold; text-shadow:0 0 5px #ff0;}
.status-placed{color:#ffa500; font-weight:bold; text-shadow:0 0 5px #ffa500;}

/* Back Button */
.back{
	text-align:center;
	margin:40px 0;
}
.back a{
	text-decoration:none;
	background:rgba(0,255,255,0.15);
	color:#00ffe0;
	padding:14px 32px;
	border-radius:35px;
	font-weight:bold;
	transition:.3s;
	box-shadow:0 0 12px #00ffe0;
}
.back a:hover{
	background:rgba(0,255,255,0.25);
	box-shadow:0 0 20px #00ffe0;
	text-decoration:none;
}
</style>

</head>
<body>

<div class="bg-circle bg1"></div>
<div class="bg-circle bg2"></div>

<div class="container">

	<h2>📦 My Orders</h2>

	<%
	String success = (String) session.getAttribute("success");
	if(success!=null){
	%>
	<script>alert("<%=success%>");</script>
	<%
	session.removeAttribute("success");
	}
	%>

	<%
	Connection con = DBConnection.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT * FROM orders WHERE user_email=? ORDER BY order_id DESC");
	ps.setString(1,email);
	ResultSet rs = ps.executeQuery();

	while(rs.next()){
		int oid = rs.getInt("order_id");
		String status = rs.getString("status");
	%>

	<div class="order">

		<div class="order-header">
			<div>
				<b>Order ID:</b> <%=oid%><br>
				<b>Date:</b> <%=rs.getTimestamp("order_date")%><br>
				<b>Total:</b> ₹ <%=rs.getDouble("total_amount")%><br>
				<b>Status:</b> 
				<span class="status-<%=
					"APPROVED".equals(status)?"approved":
					"REJECTED".equals(status)?"rejected":
					"CANCELLED".equals(status)?"cancelled":"placed"
				%>"><%=status%></span>
			</div>

			<% if("PLACED".equals(status)){ %>
			<form action="CancelOrderServlet" method="post" onsubmit="return confirm('Cancel this order?');">
				<input type="hidden" name="orderId" value="<%=oid%>">
				<button type="submit" class="cancel-btn">❌ Cancel Order</button>
			</form>
			<% } %>
		</div>

		<table>
			<tr>
				<th>Product</th>
				<th>Price</th>
				<th>Qty</th>
				<th>Total</th>
			</tr>
			<%
			PreparedStatement ps2 = con.prepareStatement("SELECT * FROM order_items WHERE order_id=?");
			ps2.setInt(1,oid);
			ResultSet rs2 = ps2.executeQuery();
			while(rs2.next()){ %>
			<tr>
				<td><%=rs2.getString("pname")%></td>
				<td>₹ <%=rs2.getDouble("price")%></td>
				<td><%=rs2.getInt("quantity")%></td>
				<td>₹ <%=rs2.getDouble("price")*rs2.getInt("quantity")%></td>
			</tr>
			<% } rs2.close(); ps2.close(); %>
		</table>

	</div>

	<% } rs.close(); ps.close(); con.close(); %>

	<div class="back">
		<a href="customerDashboard.jsp">⬅ Back to Dashboard</a>
	</div>

</div>

</body>
</html>
