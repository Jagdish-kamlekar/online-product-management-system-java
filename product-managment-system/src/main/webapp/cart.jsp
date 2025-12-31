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
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM cart WHERE user_email=?");
ps.setString(1, email);
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Cart</title>

<style>
* { box-sizing: border-box; margin:0; padding:0; font-family:'Segoe UI',sans-serif; }

/* 🌌 Animated Parallax Background */
body {
	min-height:100vh;
	display:flex;
	justify-content:center;
	align-items:flex-start;
	padding:60px 0;
	background: linear-gradient(-45deg,#0f0c29,#302b63,#24243e,#1a1a40);
	background-size:400% 400%;
	animation:bgMove 12s ease infinite;
	color:white;
}
@keyframes bgMove{
	0%{background-position:0% 50%;}
	50%{background-position:100% 50%;}
	100%{background-position:0% 50%;}
}

/* Neon floating orbs */
.bg-circle{
	position:fixed;
	width:180px;
	height:180px;
	border-radius:50%;
	filter:blur(45px);
	opacity:.55;
	animation:float 9s infinite ease-in-out;
	z-index:-1;
}
.bg1{top:15%; left:5%; background:radial-gradient(circle,#00f0ff,#8f00ff);}
.bg2{bottom:12%; right:8%; background:radial-gradient(circle,#ff1a75,#ff616f); animation-delay:3s;}
@keyframes float{
	0%,100%{transform:translateY(0);}
	50%{transform:translateY(-35px);}
}

/* Glass Container */
.container {
	width:92%;
	max-width:1050px;
	background:rgba(255,255,255,0.12);
	backdrop-filter:blur(22px);
	border-radius:26px;
	padding:34px;
	border:1px solid rgba(255,255,255,0.35);
	box-shadow:0 40px 80px rgba(0,0,0,0.5), inset 0 2px 0 rgba(255,255,255,0.25);
	animation:fadeUp .7s ease;
}
@keyframes fadeUp{from{opacity:0;transform:translateY(45px);} to{opacity:1; transform:translateY(0);}}

/* Heading with neon glow */
h2 {
	text-align:center;
	margin-bottom:30px;
	font-size:28px;
	color:#00ffe0;
	text-shadow:0 0 8px #00ffe0,0 0 20px #8f00ff;
	animation:neonGlow 2s ease-in-out infinite alternate;
}
@keyframes neonGlow{
	from{text-shadow:0 0 8px #00ffe0,0 0 20px #8f00ff;}
	to{text-shadow:0 0 15px #00ffe0,0 0 35px #8f00ff;}
}

/* Table */
table {
	width:100%;
	border-collapse:collapse;
	overflow:hidden;
	border-radius:18px;
	box-shadow:0 20px 40px rgba(0,0,0,0.25);
}

th {
	background:linear-gradient(135deg,#00f0ff,#8f00ff);
	color:white;
	padding:16px;
	font-size:15px;
}

td {
	padding:15px;
	text-align:center;
	border-bottom:1px solid rgba(255,255,255,0.2);
	color:white;
}

tr:hover td{
	background:rgba(0,255,224,0.1);
	transform:scale(1.01);
	transition:.25s;
}

/* Quantity Buttons Neon Glow */
.qty-btn {
	background:linear-gradient(135deg,#00f0ff,#8f00ff);
	color:white;
	border:none;
	width:36px;
	height:36px;
	border-radius:50%;
	font-size:18px;
	cursor:pointer;
	margin:0 4px;
	box-shadow:0 10px 20px rgba(0,255,224,0.45);
	transition:.3s;
}
.qty-btn:hover {
	transform:translateY(-2px) scale(1.08);
	box-shadow:0 16px 35px rgba(0,255,224,0.7);
}

/* Total Row */
.total-row th {
	font-size:18px;
	background:rgba(0,255,224,0.15);
	color:#00ffe0;
}

/* Checkout Button Neon */
.checkout {
	margin-top:30px;
	text-align:center;
}
.checkout button {
	background:linear-gradient(135deg,#ff1a75,#ff616f);
	border:none;
	color:white;
	font-size:18px;
	padding:16px 48px;
	border-radius:40px;
	font-weight:bold;
	cursor:pointer;
	box-shadow:0 22px 45px rgba(255,94,98,0.55);
	transition:.35s;
}
.checkout button:hover {
	transform:translateY(-3px) scale(1.04);
	box-shadow:0 32px 65px rgba(255,94,98,0.75);
	filter:brightness(1.1);
}

/* Back Link */
.back {
	text-align:center;
	margin-top:26px;
}
.back a {
	color:#00ffe0;
	font-weight:600;
	text-decoration:none;
	transition:.3s;
}
.back a:hover{
	text-decoration:underline;
	text-shadow:0 0 12px #00ffe0,0 0 25px #8f00ff;
}

/* Toast */
#toast{
	visibility:hidden;
	min-width:260px;
	background:rgba(0,0,0,0.85);
	color:white;
	text-align:center;
	border-radius:18px;
	padding:14px 22px;
	position:fixed;
	left:50%;
	bottom:30px;
	transform:translateX(-50%);
	z-index:999;
	box-shadow:0 0 25px rgba(0,255,224,0.6);
}
#toast.show{
	visibility:visible;
	animation:fadein .5s,fadeout .5s 2.5s;
}
@keyframes fadein{from{opacity:0;bottom:0;} to{opacity:1;bottom:30px;}}
@keyframes fadeout{from{opacity:1;} to{opacity:0;}}
</style>

<script>
function showToast(msg){
	let t=document.getElementById("toast");
	t.innerHTML=msg;
	t.className="show";
	setTimeout(()=>t.className="",3000);
}
</script>

</head>
<body>

<div class="bg-circle bg1"></div>
<div class="bg-circle bg2"></div>

<div class="container">

	<h2>🛒 My Cart</h2>

	<%
	String error = (String) session.getAttribute("error");
	if(error!=null){ %>
	<script>showToast("<%=error%>");</script>
	<% session.removeAttribute("error"); }
	%>

	<table>
		<tr>
			<th>Product</th>
			<th>Price</th>
			<th>Qty</th>
			<th>Total</th>
			<th>Action</th>
		</tr>

		<%
		double grandTotal=0;
		boolean isCartEmpty=true;

		while(rs.next()){
			isCartEmpty=false;
			int pid=rs.getInt("product_id");
			String pname=rs.getString("pname");
			double price=rs.getDouble("price");
			int qty=rs.getInt("quantity");
			double total=price*qty;
			grandTotal+=total;
		%>

		<tr>
			<td><%=pname%></td>
			<td>₹ <%=price%></td>
			<td><%=qty%></td>
			<td>₹ <%=total%></td>
			<td>
				<form action="UpdateCartServlet" method="post" style="display:inline;">
					<input type="hidden" name="pid" value="<%=pid%>">
					<input type="hidden" name="action" value="add">
					<button class="qty-btn">+</button>
				</form>

				<form action="UpdateCartServlet" method="post" style="display:inline;">
					<input type="hidden" name="pid" value="<%=pid%>">
					<input type="hidden" name="action" value="remove">
					<button class="qty-btn">−</button>
				</form>
			</td>
		</tr>

		<% } %>

		<tr class="total-row">
			<th colspan="3">Grand Total</th>
			<th colspan="2">₹ <%=grandTotal%></th>
		</tr>
	</table>

	<div class="checkout">
		<form action="PlaceOrderServlet" method="post">
			<input type="hidden" name="total" value="<%=grandTotal%>">
			<input type="hidden" name="isCartEmpty" value="<%=isCartEmpty%>">
			<button type="submit">🛍 Place Order</button>
		</form>
	</div>

	<div class="back">
		<a href="customerViewProducts.jsp">⬅ Continue Shopping</a>
	</div>

</div>

<div id="toast"></div>

</body>
</html>

<%
con.close();
%>
