<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Customer Login | Product Management System</title>

<style>
/* ===== RESET ===== */
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI', Arial, sans-serif;
}

/* 🌈 WATERCOLOUR + RETRO ANIMATED BACKGROUND */
body{
    min-height:100vh;
    background:
        radial-gradient(circle at 20% 30%, #ff9a9e, transparent 40%),
        radial-gradient(circle at 80% 20%, #fad0c4, transparent 45%),
        radial-gradient(circle at 70% 80%, #a18cd1, transparent 45%),
        linear-gradient(120deg, #1a1a2e, #16213e, #0f3460);
    background-size: 200% 200%;
    animation:bgFlow 18s ease infinite;
    display:flex;
    justify-content:center;
    align-items:center;
    overflow:hidden;
}

@keyframes bgFlow{
    0%{background-position:0% 50%;}
    50%{background-position:100% 50%;}
    100%{background-position:0% 50%;}
}

/* ✨ FLOATING GLOW ORBS */
.orb{
    position:absolute;
    width:220px;
    height:220px;
    border-radius:50%;
    background:rgba(255,255,255,0.12);
    filter:blur(40px);
    animation:floatOrb 10s infinite ease-in-out;
}
.orb1{top:10%;left:5%;}
.orb2{bottom:15%;right:10%;animation-delay:3s;}

@keyframes floatOrb{
    0%,100%{transform:translateY(0);}
    50%{transform:translateY(-35px);}
}

/* 🧊 GLASSMORPHISM CARD */
.login-box{
    position:relative;
    background:rgba(255,255,255,0.88);
    backdrop-filter:blur(20px);
    width:420px;
    padding:45px;
    border-radius:28px;
    box-shadow:
        0 40px 80px rgba(0,0,0,0.45),
        inset 0 1px 0 rgba(255,255,255,0.6);
    border:1px solid rgba(255,255,255,0.35);
    text-align:center;
    animation:fadeUp .9s ease;
}

/* 🎯 TITLE */
.login-box h2{
    font-size:28px;
    margin-bottom:6px;
    background:linear-gradient(90deg,#ff0080,#7928ca);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
}

.subtitle{
    font-size:14px;
    color:#555;
    margin-bottom:30px;
}

/* 🔤 FLOATING LABEL INPUTS */
.input-group{
    position:relative;
    margin-bottom:26px;
    text-align:left;
}

.input-group input{
    width:100%;
    padding:16px 14px;
    border-radius:14px;
    border:1px solid #ccc;
    font-size:15px;
    background:#fafafa;
    transition:.3s;
}

.input-group label{
    position:absolute;
    top:50%;
    left:14px;
    font-size:14px;
    color:#777;
    background:white;
    padding:0 6px;
    transform:translateY(-50%);
    pointer-events:none;
    transition:.3s;
}

.input-group input:focus,
.input-group input:not(:placeholder-shown){
    border-color:#7928ca;
    box-shadow:0 0 0 5px rgba(121,40,202,0.15);
    background:white;
}

.input-group input:focus + label,
.input-group input:not(:placeholder-shown) + label{
    top:-8px;
    font-size:12px;
    color:#7928ca;
}

/* 🚀 3D NEON BUTTON */
.btn{
    width:100%;
    padding:15px;
    background:linear-gradient(135deg,#ff0080,#7928ca);
    border:none;
    color:white;
    font-size:17px;
    border-radius:40px;
    cursor:pointer;
    font-weight:bold;
    transition:.35s;
    box-shadow:
        0 18px 40px rgba(255,0,128,0.45),
        inset 0 -3px 0 rgba(0,0,0,0.25);
}

.btn:hover{
    transform:translateY(-4px) scale(1.05);
    box-shadow:
        0 30px 65px rgba(255,0,128,0.65),
        inset 0 -3px 0 rgba(0,0,0,0.3);
}

/* LINKS */
.links{
    margin-top:18px;
    font-size:14px;
}

.links a{
    color:#7928ca;
    font-weight:bold;
    text-decoration:none;
}

.links a:hover{
    text-decoration:underline;
}

/* HOME BUTTON */
.home-btn{
    margin-top:18px;
    background:transparent;
    border:2px solid #7928ca;
    color:#7928ca;
    box-shadow:none;
}

.home-btn:hover{
    background:#7928ca;
    color:white;
}

/* 🔔 TOAST */
#toast{
    visibility:hidden;
    min-width:260px;
    background:#222;
    color:#fff;
    text-align:center;
    border-radius:18px;
    padding:14px 22px;
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
    from{bottom:0;opacity:0;}
    to{bottom:30px;opacity:1;}
}
@keyframes fadeout{
    from{bottom:30px;opacity:1;}
    to{bottom:0;opacity:0;}
}

/* ENTRY ANIMATION */
@keyframes fadeUp{
    from{opacity:0;transform:translateY(45px);}
    to{opacity:1;transform:translateY(0);}
}
</style>

<script>
function showToast(msg){
    var t=document.getElementById("toast");
    t.innerHTML=msg;
    t.className="show";
    setTimeout(()=>{
        t.className=t.className.replace("show","");
    },3000);
}
</script>

</head>
<body>

<div class="orb orb1"></div>
<div class="orb orb2"></div>

<div class="login-box">
    <h2>🛒 Customer Login</h2>
    <div class="subtitle">Product Management System</div>

    <form action="LoginServlet" method="post">
        <input type="hidden" name="loginType" value="customer">

        <div class="input-group">
            <input type="text" name="email" required placeholder=" ">
            <label>📧 Email</label>
        </div>

        <div class="input-group">
            <input type="password" name="password" required placeholder=" ">
            <label>🔑 Password</label>
        </div>

        <input type="submit" value="Login" class="btn">
    </form>

    <div class="links">
        New Customer? <a href="register.jsp">Register Here</a>
    </div>

    <input type="button"
           value="⬅ Go to Home"
           class="btn home-btn"
           onclick="location.href='index.jsp'">
</div>

<div id="toast"></div>

<%
String msg=(String)request.getAttribute("msg");
if(msg!=null){
%>
<script>
    showToast("<%=msg%>");
</script>
<% } %>

</body>
</html>
