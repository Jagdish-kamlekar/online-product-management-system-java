<%@ page import="java.sql.*"%>
<%@ page import="com.util.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
if (session.getAttribute("email") == null || !"admin".equals(session.getAttribute("role"))) {
	response.sendRedirect("adminLogin.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Customer Management | Admin</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root{
	--primary:#667eea;
	--secondary:#764ba2;
	--danger:#ef4444;
	--glass:rgba(255,255,255,0.92);
	--text:#1e293b;
}

*{
	margin:0;
	padding:0;
	box-sizing:border-box;
	font-family:'Poppins',sans-serif;
}

/* 🌈 SAME ANIMATED BACKGROUND */
body{
	min-height:100vh;
	background:linear-gradient(270deg,#667eea,#764ba2,#43cea2);
	background-size:600% 600%;
	animation:bgMove 12s ease infinite;
	display:flex;
	justify-content:center;
	padding:60px 20px;
}

@keyframes bgMove{
	0%{background-position:0% 50%;}
	50%{background-position:100% 50%;}
	100%{background-position:0% 50%;}
}

/* 🧊 Glass Main Card */
.main-card{
	width:100%;
	max-width:1050px;
	background:var(--glass);
	backdrop-filter:blur(18px);
	border-radius:28px;
	padding:40px;
	box-shadow:0 35px 80px rgba(0,0,0,0.45);
	animation:fadeUp .8s ease;
}

/* Header */
.header-section{
	display:flex;
	justify-content:space-between;
	align-items:center;
	margin-bottom:30px;
}

h2{
	font-size:28px;
	color:#4b3f72;
	display:flex;
	align-items:center;
	gap:12px;
	text-shadow:0 2px 6px rgba(0,0,0,0.15);
}

h2 i{
	color:var(--primary);
}

/* Table Container */
.table-container{
	background:white;
	border-radius:20px;
	overflow:hidden;
	box-shadow:0 12px 35px rgba(0,0,0,0.15);
}

/* Table */
table{
	width:100%;
	border-collapse:collapse;
	min-width:650px;
}

th{
	background:linear-gradient(135deg,#667eea,#764ba2);
	color:white;
	padding:18px;
	font-size:13px;
	text-transform:uppercase;
	letter-spacing:1px;
}

td{
	padding:16px 18px;
	font-size:14px;
	color:var(--text);
	border-bottom:1px solid #eef2ff;
}

tr{
	transition:0.35s;
}

tr:hover{
	background:rgba(102,126,234,0.1);
	transform:scale(1.01);
}

/* Role Badge */
.badge{
	padding:6px 14px;
	border-radius:30px;
	font-size:12px;
	font-weight:500;
	background:rgba(102,126,234,0.15);
	color:#4338ca;
}

/* ❌ Neon Remove Button */
.remove-btn{
	background:linear-gradient(135deg,#ff416c,#ff4b2b);
	color:white;
	border:none;
	padding:9px 18px;
	border-radius:25px;
	font-size:13px;
	font-weight:600;
	cursor:pointer;
	display:flex;
	align-items:center;
	gap:6px;
	box-shadow:0 10px 25px rgba(255,75,43,0.5);
	transition:0.35s;
}

.remove-btn:hover{
	transform:translateY(-2px) scale(1.05);
	box-shadow:0 18px 45px rgba(255,75,43,0.7);
}

/* Back Link */
.back-link{
	display:inline-flex;
	align-items:center;
	gap:10px;
	margin-top:35px;
	text-decoration:none;
	font-weight:600;
	color:white;
	padding:14px 32px;
	border-radius:40px;
	background:linear-gradient(135deg,#667eea,#764ba2);
	box-shadow:0 18px 40px rgba(102,126,234,0.6);
	transition:0.35s;
}

.back-link:hover{
	transform:translateY(-2px) scale(1.05);
	box-shadow:0 26px 60px rgba(102,126,234,0.8);
}

/* Footer */
.footer{
	margin-top:35px;
	text-align:center;
	font-size:13px;
	color:#4b3f72;
	opacity:0.85;
}

/* Animation */
@keyframes fadeUp{
	from{opacity:0;transform:translateY(35px);}
	to{opacity:1;transform:translateY(0);}
}
</style>
</head>

<body>

<div class="main-card">

	<div class="header-section">
		<h2><i class="fas fa-users"></i> Customer Management</h2>
	</div>

	<%
	String msg = (String) session.getAttribute("msg");
	if (msg != null) {
	%>
	<script>alert("<%=msg%>");</script>
	<%
	session.removeAttribute("msg");
	}
	%>

	<div class="table-container">
	<table>
		<tr>
			<th>ID</th>
			<th>Customer Name</th>
			<th>Email Address</th>
			<th>Access Role</th>
			<th>Actions</th>
		</tr>

		<%
		Connection con = DBConnection.getConnection();
		PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE role='customer'");
		ResultSet rs = ps.executeQuery();

		while(rs.next()){
		%>
		<tr>
			<td style="font-weight:600;color:#64748b;">#<%=rs.getInt("id")%></td>
			<td><%=rs.getString("name")%></td>
			<td><%=rs.getString("email")%></td>
			<td><span class="badge"><%=rs.getString("role")%></span></td>
			<td>
				<form action="<%=request.getContextPath()%>/DeleteCustomerServlet" method="post"
					  onsubmit="return confirm('Permanently remove this customer?');">
					<input type="hidden" name="userId" value="<%=rs.getInt("id")%>">
					<button class="remove-btn">
						<i class="fas fa-trash-alt"></i> Remove
					</button>
				</form>
			</td>
		</tr>
		<%
		}
		rs.close();
		ps.close();
		con.close();
		%>
	</table>
	</div>

	<center>
		<a href="adminDashboard.jsp" class="back-link">
			<i class="fas fa-arrow-left"></i> Back to Dashboard
		</a>
	</center>

	<div class="footer">
		Designed By <b>Jagdish Kamlekar</b> ❤️ | Java Full Stack
	</div>

</div>

</body>
</html>
