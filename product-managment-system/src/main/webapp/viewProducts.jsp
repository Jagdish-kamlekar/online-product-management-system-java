<%@ page import="java.sql.*"%>
<%@ page import="com.util.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
/* 🔐 Admin Session Security */
if (session.getAttribute("email") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect("adminLogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Products | Admin</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',Arial,sans-serif;
}

/* 🌌 Animated Background */
body{
    min-height:100vh;
    background:linear-gradient(-45deg,#0f0c29,#302b63,#24243e,#1a1a40);
    background-size:400% 400%;
    animation:bgMove 15s ease infinite;
    padding:40px 20px;
    display:flex;
    justify-content:center;
}
@keyframes bgMove{
    0%{background-position:0% 50%;}
    50%{background-position:100% 50%;}
    100%{background-position:0% 50%;}
}

/* 🌈 Floating Neon Orbs */
.bg-circle{
    position:fixed;
    width:260px;
    height:260px;
    border-radius:50%;
    filter:blur(60px);
    opacity:.65;
    animation:float 10s infinite ease-in-out;
    z-index:-1;
}
.bg1{
    top:8%;
    left:5%;
    background:radial-gradient(circle,#6a11cb,#2575fc);
}
.bg2{
    bottom:10%;
    right:8%;
    background:radial-gradient(circle,#ff512f,#dd2476);
    animation-delay:3s;
}
@keyframes float{
    0%,100%{transform:translateY(0);}
    50%{transform:translateY(-40px);}
}

/* 🧊 Glass Container */
.container{
    width:95%;
    max-width:1200px;
    background:rgba(255,255,255,0.14);
    backdrop-filter:blur(22px);
    padding:35px;
    border-radius:30px;
    border:1px solid rgba(255,255,255,0.35);
    box-shadow:0 40px 90px rgba(0,0,0,.7);
    animation:fadeUp .9s ease;
}
@keyframes fadeUp{
    from{opacity:0; transform:translateY(40px) scale(.96);}
    to{opacity:1; transform:translateY(0) scale(1);}
}

/* 🔮 Heading */
.container h2{
    text-align:center;
    font-size:32px;
    margin-bottom:30px;
    background:linear-gradient(90deg,#00ffe0,#8f00ff,#ff00c8);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
    text-shadow:0 0 20px rgba(0,255,224,.8);
}

/* 📊 Table */
table{
    width:100%;
    border-collapse:collapse;
    overflow:hidden;
    border-radius:20px;
}
th,td{
    padding:15px;
    text-align:center;
}
th{
    background:linear-gradient(135deg,#00ffe0,#8f00ff);
    color:#fff;
    font-size:15px;
}
td{
    color:#eee;
    font-size:14px;
    border-bottom:1px solid rgba(255,255,255,.15);
}

/* ✨ Row Hover */
tr{
    transition:.4s;
}
tr:hover{
    background:rgba(255,255,255,.12);
    transform:scale(1.015);
}

/* 🚀 Action Buttons */
.action a{
    text-decoration:none;
    padding:9px 16px;
    border-radius:25px;
    color:#fff;
    font-size:13px;
    font-weight:bold;
    margin:0 4px;
    display:inline-block;
    transition:.35s;
}
.edit{
    background:linear-gradient(135deg,#00c853,#b2ff59);
    box-shadow:0 0 18px rgba(0,200,83,.9);
}
.delete{
    background:linear-gradient(135deg,#ff1744,#ff616f);
    box-shadow:0 0 18px rgba(255,23,68,.9);
}
.action a:hover{
    transform:translateY(-4px) scale(1.1);
    filter:brightness(1.2);
}

/* ⬅ Back */
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

/* 🧾 Footer */
.footer{
    text-align:center;
    margin-top:30px;
    font-size:12px;
    color:#ddd;
}

/* 🔔 Toast */
#toast{
    visibility:hidden;
    min-width:280px;
    background:rgba(0,0,0,.85);
    backdrop-filter:blur(12px);
    color:#fff;
    text-align:center;
    border-radius:30px;
    padding:14px 22px;
    position:fixed;
    left:50%;
    bottom:30px;
    transform:translateX(-50%);
    z-index:999;
    box-shadow:0 0 30px rgba(0,0,0,.9);
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

<div class="bg-circle bg1"></div>
<div class="bg-circle bg2"></div>

<div class="container">
<h2>📋 Product List</h2>

<table>
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Price</th>
    <th>Qty</th>
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
    <td class="action">
        <a href="editProduct.jsp?id=<%=rs.getInt("id")%>" class="edit">✏ Edit</a>
        <a href="DeleteProductServlet?id=<%=rs.getInt("id")%>"
           class="delete"
           onclick="return confirm('Are you sure you want to delete this product?')">
           🗑 Delete
        </a>
    </td>
</tr>
<% } %>
</table>

<div class="back">
    ⬅ <a href="adminDashboard.jsp">Back to Dashboard</a>
</div>

<div class="footer">
    Designed By Jagdish Kamlekar ❤️ | Java Full Stack
</div>
</div>

<div id="toast"></div>

<%
String msg=(String)session.getAttribute("msg");
if(msg!=null){
%>
<script>showToast("<%=msg%>");</script>
<%
session.removeAttribute("msg");
}
rs.close(); ps.close(); con.close();
%>

</body>
</html>
