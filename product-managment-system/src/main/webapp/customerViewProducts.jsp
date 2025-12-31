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
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shop Products</title>

<style>
*{
	margin:0;
	padding:0;
	box-sizing:border-box;
	font-family:'Segoe UI',sans-serif;
}

/* 🌌 Animated Neon Background */
body{
	min-height:100vh;
	background:linear-gradient(-45deg,#0f2027,#203a43,#2c5364,#1a1a40);
	background-size:400% 400%;
	animation:bgMove 14s ease infinite;
}
@keyframes bgMove{
	0%{background-position:0% 50%;}
	50%{background-position:100% 50%;}
	100%{background-position:0% 50%;}
}

/* 🧊 Glass Wrapper */
.wrapper{
	width:95%;
	max-width:1250px;
	margin:60px auto;
	background:rgba(255,255,255,0.14);
	backdrop-filter:blur(22px);
	border-radius:30px;
	padding:35px;
	border:1px solid rgba(255,255,255,.35);
	box-shadow:0 40px 80px rgba(0,0,0,.6);
	animation:fadeUp .7s ease;
}
@keyframes fadeUp{
	from{opacity:0; transform:translateY(40px);}
	to{opacity:1; transform:translateY(0);}
}

/* 🧬 Glitch Heading */
.glitch{
	position:relative;
	color:#fff;
	font-size:30px;
	letter-spacing:2px;
	text-shadow:0 0 18px #00ffe0;
}
.glitch::before,
.glitch::after{
	content:attr(data-text);
	position:absolute;
	left:0;
	top:0;
	width:100%;
}
.glitch::before{
	color:#ff00c8;
	animation:glitchTop 2s infinite linear;
}
.glitch::after{
	color:#00ffe0;
	animation:glitchBottom 1.5s infinite linear;
}
@keyframes glitchTop{
	0%{clip-path:inset(0 0 90% 0);}
	50%{clip-path:inset(0 0 40% 0);}
	100%{clip-path:inset(0 0 90% 0);}
}
@keyframes glitchBottom{
	0%{clip-path:inset(90% 0 0 0);}
	50%{clip-path:inset(40% 0 0 0);}
	100%{clip-path:inset(90% 0 0 0);}
}

/* Header */
.header{
	display:flex;
	justify-content:space-between;
	align-items:center;
	margin-bottom:30px;
}

/* 🛒 Neon Cart Button */
.cart-btn{
	text-decoration:none;
	padding:14px 32px;
	border-radius:40px;
	color:white;
	font-weight:bold;
	background:linear-gradient(135deg,#ff00c8,#00ffe0);
	box-shadow:0 0 25px rgba(0,255,224,.9);
	transition:.35s;
}
.cart-btn:hover{
	transform:translateY(-4px) scale(1.08);
	box-shadow:0 0 45px rgba(255,0,200,1);
}

/* 📊 Table */
table{
	width:100%;
	border-collapse:collapse;
	border-radius:22px;
	overflow:hidden;
	box-shadow:0 30px 60px rgba(0,0,0,.4);
}
th{
	background:linear-gradient(135deg,#00ffe0,#8f00ff);
	color:#fff;
	padding:16px;
	font-size:15px;
}
td{
	padding:14px;
	text-align:center;
	color:#eee;
	font-size:14px;
	border-bottom:1px solid rgba(255,255,255,.15);
}

/* 🌀 Hover Parallax Rows */
tr{
	transition:.35s;
}
tr:hover{
	background:rgba(255,255,255,.12);
	transform:scale(1.02) translateZ(10px);
	box-shadow:inset 0 0 15px rgba(0,255,224,.4);
}

/* 🌊 Liquid Morph Button */
button{
	position:relative;
	background:linear-gradient(135deg,#667eea,#764ba2);
	color:white;
	border:none;
	padding:10px 26px;
	border-radius:35px;
	cursor:pointer;
	font-weight:bold;
	overflow:hidden;
	box-shadow:0 0 22px rgba(102,126,234,.9);
	transition:.35s;
}
button::before{
	content:"";
	position:absolute;
	width:140%;
	height:140%;
	background:radial-gradient(circle,#00ffe0,transparent 60%);
	top:-70%;
	left:-70%;
	transition:.6s;
}
button:hover::before{
	top:-20%;
	left:-20%;
}
button:hover{
	transform:translateY(-3px) scale(1.1);
	box-shadow:0 0 40px rgba(118,75,162,1);
}

/* Back */
.back{
	text-align:center;
	margin-top:30px;
}
.back a{
	color:#00ffe0;
	font-weight:bold;
	text-decoration:none;
}
.back a:hover{
	text-decoration:underline;
}
</style>

</head>
<body>

<div class="wrapper">

	<div class="header">
		<h2 class="glitch" data-text="🛍 Shop Products">🛍 Shop Products</h2>
		<a href="cart.jsp" class="cart-btn">🛒 View Cart</a>
	</div>

	<table>
	<tr>
		<th>ID</th>
		<th>Product</th>
		<th>Price</th>
		<th>Stock</th>
		<th>Category</th>
		<th>Action</th>
	</tr>

	<%
	Connection con = DBConnection.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT * FROM product");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
	%>
	<tr>
		<td><%=rs.getInt("id")%></td>
		<td><%=rs.getString("name")%></td>
		<td>₹ <%=rs.getDouble("price")%></td>
		<td><%=rs.getInt("quantity")%></td>
		<td><%=rs.getString("category")%></td>
		<td>
			<form action="AddToCartServlet" method="post">
				<input type="hidden" name="pid" value="<%=rs.getInt("id")%>">
				<input type="hidden" name="pname" value="<%=rs.getString("name")%>">
				<input type="hidden" name="price" value="<%=rs.getDouble("price")%>">
				<input type="hidden" name="qty" value="1">
				<button>Add 🛒</button>
			</form>
		</td>
	</tr>
	<% } con.close(); %>
	</table>

	<div class="back">
		<a href="customerDashboard.jsp">⬅ Back to Dashboard</a>
	</div>

</div>

</body>
</html>
