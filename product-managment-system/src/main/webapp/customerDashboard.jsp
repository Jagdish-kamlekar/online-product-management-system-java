<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
/* 🔐 Session Security */
if (session.getAttribute("email") == null || !"customer".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Customer Dashboard | Product Management System</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

/* 🌌 Animated Background */
body{
    font-family:'Segoe UI',sans-serif;
    min-height:100vh;
    background:linear-gradient(-45deg,#0f2027,#203a43,#2c5364,#1b1f3b);
    background-size:400% 400%;
    animation:bgMove 15s ease infinite;
    color:#fff;
}
@keyframes bgMove{
    0%{background-position:0% 50%;}
    50%{background-position:100% 50%;}
    100%{background-position:0% 50%;}
}

/* 🧊 Glass Header */
.header{
    text-align:center;
    padding:40px 20px;
    background:rgba(255,255,255,0.15);
    backdrop-filter:blur(14px);
    box-shadow:0 15px 40px rgba(0,0,0,.6);
}
.header h2{
    font-size:30px;
    letter-spacing:1px;
    text-shadow:0 0 15px #00ffe0;
}
.header p{
    opacity:.85;
}

/* Layout */
.dashboard{
    max-width:1150px;
    margin:60px auto;
    padding:20px;
}

/* 👋 Welcome Card */
.welcome{
    background:rgba(255,255,255,0.18);
    backdrop-filter:blur(16px);
    border-radius:22px;
    padding:30px;
    margin-bottom:50px;
    border:1px solid rgba(255,255,255,0.35);
    box-shadow:0 25px 60px rgba(0,255,224,.35);
    animation:floatIn .8s ease;
}
@keyframes floatIn{
    from{opacity:0; transform:translateY(-40px);}
    to{opacity:1; transform:translateY(0);}
}
.welcome h3{
    color:#00ffe0;
}

/* 🧩 Cards Grid */
.cards{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
    gap:35px;
}

/* 🟣 Neon Glass Card */
.card{
    position:relative;
    padding:30px;
    text-align:center;
    border-radius:26px;
    background:rgba(255,255,255,0.14);
    backdrop-filter:blur(16px);
    box-shadow:
        inset 0 0 15px rgba(255,255,255,.15),
        0 25px 60px rgba(0,0,0,.6);
    transition:.5s;
    overflow:hidden;
}

/* 🌈 Chrome Neon Border */
.card::before{
    content:"";
    position:absolute;
    inset:-2px;
    border-radius:26px;
    background:linear-gradient(135deg,#00ffe0,#8f00ff,#ff00c8);
    z-index:-1;
    filter:blur(10px);
    opacity:.8;
}

/* 🧠 3D Hover */
.card:hover{
    transform:translateY(-18px) rotateX(6deg);
    box-shadow:0 40px 90px rgba(0,255,224,.7);
}

.card h4{
    font-size:20px;
    margin-bottom:8px;
    color:#00ffe0;
    text-shadow:0 0 10px rgba(0,255,224,.8);
}
.card p{
    font-size:14px;
    opacity:.85;
}

/* 🚀 Button */
.card a{
    display:inline-block;
    margin-top:18px;
    padding:12px 28px;
    border-radius:40px;
    background:linear-gradient(135deg,#00ffe0,#8f00ff);
    color:white;
    font-weight:600;
    text-decoration:none;
    box-shadow:0 12px 35px rgba(0,255,224,.6);
    transition:.4s;
}
.card a:hover{
    transform:scale(1.08);
    box-shadow:0 20px 50px rgba(143,0,255,.8);
}

/* 🚪 Logout */
.logout{
    text-align:center;
    margin-top:60px;
}
.logout a{
    display:inline-block;
    padding:15px 45px;
    border-radius:50px;
    background:linear-gradient(135deg,#ff0844,#ffb199);
    color:white;
    text-decoration:none;
    font-weight:bold;
    box-shadow:0 20px 45px rgba(255,8,68,.6);
    transition:.4s;
}
.logout a:hover{
    transform:scale(1.1);
}

/* 🔔 Toast */
#toast{
    visibility:hidden;
    min-width:260px;
    background:rgba(0,0,0,.75);
    backdrop-filter:blur(12px);
    color:white;
    text-align:center;
    border-radius:20px;
    padding:14px;
    position:fixed;
    left:50%;
    bottom:30px;
    transform:translateX(-50%);
    z-index:999;
}
#toast.show{
    visibility:visible;
    animation:fadein .5s, fadeout .5s 2.5s;
}
@keyframes fadein{
    from{opacity:0; bottom:0;}
    to{opacity:1; bottom:30px;}
}
@keyframes fadeout{
    from{opacity:1;}
    to{opacity:0;}
}
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

<div class="header">
    <h2>🛒 Product Management System</h2>
    <p>Customer Dashboard</p>
</div>

<div class="dashboard">

    <div class="welcome">
        <h3>👋 Welcome, <%=session.getAttribute("name")%></h3>
        <p>Browse products, manage orders, and control your profile easily.</p>
    </div>

    <div class="cards">

        <div class="card">
            <h4>📦 View Products</h4>
            <p>Explore all available items</p>
            <a href="customerViewProducts.jsp">Open</a>
        </div>

        <div class="card">
            <h4>🛍 My Orders</h4>
            <p>Track and manage your orders</p>
            <a href="myOrders.jsp">Open</a>
        </div>

        <div class="card">
            <h4>👤 My Profile</h4>
            <p>View or update your details</p>
            <a href="profile.jsp">Open</a>
        </div>

        <div class="card">
            <h4>🛒 My Cart</h4>
            <p>Check items before checkout</p>
            <a href="cart.jsp">Open</a>
        </div>

    </div>

    <div class="logout">
        <a href="LogoutServlet">🚪 Logout</a>
    </div>
</div>

<div id="toast"></div>

<%
String toast = (String) session.getAttribute("toast");
if (toast != null) {
%>
<script>showToast("<%=toast%>");</script>
<%
session.removeAttribute("toast");
}
%>

</body>
</html>
