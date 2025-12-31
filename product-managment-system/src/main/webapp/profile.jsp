<%@ page import="java.sql.*"%>
<%@ page import="com.util.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
if (session.getAttribute("email") == null || !"customer".equals(session.getAttribute("role"))) {
	response.sendRedirect("index.jsp");
	return;
}

String email = (String) session.getAttribute("email");
String oldName = "", oldPhone = "", oldAddress = "", toastMsg = "";

try {
	Connection con = DBConnection.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?");
	ps.setString(1, email);
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		oldName = rs.getString("name");
		oldPhone = rs.getString("phone");
		oldAddress = rs.getString("address");
	}
	con.close();
} catch (Exception e) {
	toastMsg = "Error loading profile!";
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>

<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',sans-serif; }

/* 🌌 Animated Parallax Background */
body {
	min-height:100vh;
	display:flex;
	align-items:center;
	justify-content:center;
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

/* Glass Card Container */
.container{
	width:430px;
	background:rgba(255,255,255,0.12);
	backdrop-filter:blur(22px);
	border-radius:28px;
	padding:34px;
	border:1px solid rgba(255,255,255,0.35);
	box-shadow:0 40px 80px rgba(0,0,0,0.5), inset 0 2px 0 rgba(255,255,255,0.25);
	animation:fadeUp .8s ease;
}
@keyframes fadeUp{
	from{opacity:0; transform:translateY(45px);}
	to{opacity:1; transform:translateY(0);}
}

/* Header */
.profile-header{
	text-align:center;
	margin-bottom:28px;
}
.profile-header span{
	font-size:46px;
	display:block;
	filter:drop-shadow(0 5px 12px rgba(0,255,224,0.6));
	animation:neonGlow 2s ease-in-out infinite alternate;
}
.profile-header h2{
	color:#00ffe0;
	font-size:26px;
	letter-spacing:.5px;
	text-shadow:0 0 8px #00ffe0,0 0 20px #8f00ff;
	animation:typewriter 2s steps(30) 1;
	overflow:hidden;
	white-space:nowrap;
	border-right:3px solid #00ffe0;
}
/* @keyframes typewriter{
	from{width:0;}
	to{width:100%;}
} */
@keyframes neonGlow{
	from{text-shadow:0 0 8px #00ffe0,0 0 20px #8f00ff;}
	to{text-shadow:0 0 15px #00ffe0,0 0 35px #8f00ff;}
}

/* Labels and Inputs */
label{
	display:block;
	margin:14px 0 6px;
	font-weight:600;
	color:#00ffe0;
	text-shadow:0 0 4px rgba(0,255,224,0.6);
}
input,textarea{
	width:100%;
	padding:14px 16px;
	border-radius:16px;
	border:1px solid rgba(255,255,255,0.25);
	font-size:14px;
	background:rgba(255,255,255,0.1);
	color:#fff;
	transition:.35s;
	backdrop-filter:blur(8px);
}
input:focus,textarea:focus{
	border-color:#00ffe0;
	background:rgba(255,255,255,0.18);
	box-shadow:0 0 15px #00ffe0;
	outline:none;
	transform:scale(1.02);
}
input[readonly]{cursor:not-allowed; background:rgba(255,255,255,0.05);}

/* Button Neon Glow */
button{
	width:100%;
	margin-top:26px;
	padding:16px;
	font-size:16px;
	font-weight:bold;
	border:none;
	border-radius:40px;
	color:white;
	cursor:pointer;
	background:linear-gradient(135deg,#00f0ff,#8f00ff);
	box-shadow:0 0 18px #00f0ff,0 0 30px #8f00ff;
	transition:.35s;
}
button:hover{
	transform:translateY(-2px) scale(1.03);
	box-shadow:0 0 28px #00f0ff,0 0 45px #8f00ff;
	filter:brightness(1.1);
}

/* Back link */
.back{
	text-align:center;
	margin-top:20px;
}
.back a{
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

	<div class="profile-header">
		<span>👤</span>
		<h2>My Profile</h2>
	</div>

	<form action="UpdateProfileServlet" method="post">
		<label>Name</label>
		<input type="text" name="name" value="<%=oldName%>" required>
		
		<label>Email</label>
		<input type="email" value="<%=email%>" readonly>
		
		<label>Phone</label>
		<input type="text" name="phone" value="<%=oldPhone%>">
		
		<label>Address</label>
		<textarea name="address" rows="3"><%=oldAddress%></textarea>
		
		<button type="submit">💾 Update Profile</button>
	</form>

	<div class="back">
		<a href="customerDashboard.jsp">⬅ Back to Dashboard</a>
	</div>

</div>

<div id="toast"></div>

<%
String toast = (String) session.getAttribute("toast");
if(toast != null){ %>
<script>showToast("<%=toast%>");</script>
<% session.removeAttribute("toast");
} else if(!toastMsg.isEmpty()){ %>
<script>showToast("<%=toastMsg%>");</script>
<% } %>

</body>
</html>
