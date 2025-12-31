<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Registration | Product Management System</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Arial, sans-serif;
}

body {
    min-height: 100vh;
    background: linear-gradient(135deg,#43cea2,#185a9d);
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 50px 20px;
}

/* Glass Card */
.register-box {
    width: 400px;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(15px);
    border-radius: 20px;
    padding: 35px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.25);
    text-align: center;
    animation: fadeUp 0.7s ease;
}

@keyframes fadeUp {
    from {opacity:0; transform: translateY(40px);}
    to {opacity:1; transform: translateY(0);}
}

.register-box h2 {
    color: #185a9d;
    margin-bottom: 10px;
}

.subtitle {
    font-size: 14px;
    color: #555;
    margin-bottom: 25px;
}

/* Input group */
.input-group {
    text-align: left;
    margin-bottom: 15px;
}

.input-group label {
    display: block;
    font-weight: 600;
    color: #333;
    margin-bottom: 5px;
}

.input-group input {
    width: 100%;
    padding: 12px;
    border-radius: 8px;
    border: 1px solid #ccc;
    font-size: 14px;
    transition: 0.3s;
}

.input-group input:focus {
    outline: none;
    border-color: #43cea2;
    box-shadow: 0 0 8px rgba(67, 206, 162, 0.3);
}

/* Buttons */
.btn {
    width: 100%;
    padding: 14px;
    margin-top: 15px;
    border: none;
    border-radius: 30px;
    font-size: 16px;
    font-weight: bold;
    color: white;
    cursor: pointer;
    background: linear-gradient(135deg,#43cea2,#185a9d);
    transition: 0.3s;
}

.btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 25px rgba(67,206,162,0.4);
}

/* Home button */
.home-btn {
    background: #f39c12;
    margin-top: 10px;
}

.home-btn:hover {
    background: #e67e22;
}

/* Links */
.links {
    margin-top: 18px;
    font-size: 14px;
}

.links a {
    color: #185a9d;
    text-decoration: none;
    font-weight: bold;
}

.links a:hover {
    text-decoration: underline;
}

/* Toast */
#toast {
    visibility: hidden;
    min-width: 260px;
    background: #333;
    color: white;
    text-align: center;
    border-radius: 14px;
    padding: 14px;
    position: fixed;
    bottom: 30px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 999;
}

#toast.show {
    visibility: visible;
    animation: fadein 0.5s, fadeout 0.5s 2.5s;
}

@keyframes fadein {
    from {opacity: 0; bottom: 0;}
    to {opacity: 1; bottom: 30px;}
}

@keyframes fadeout {
    from {opacity: 1;}
    to {opacity: 0;}
}
</style>

<script>
function showToast(msg){
    var t = document.getElementById("toast");
    t.innerHTML = msg;
    t.className = "show";
    setTimeout(() => { t.className = t.className.replace("show",""); }, 3000);
}
</script>

</head>
<body>

<div class="register-box">
    <h2>📝 Customer Registration</h2>
    <div class="subtitle">Create your account</div>

    <form action="RegisterServlet" method="post">
        <div class="input-group">
            <label>👤 Name</label>
            <input type="text" name="name" placeholder="Enter your name" required>
        </div>

        <div class="input-group">
            <label>📧 Email</label>
            <input type="email" name="email" placeholder="Enter email address" required>
        </div>

        <div class="input-group">
            <label>🔑 Password</label>
            <input type="password" name="password" placeholder="Create password" required>
        </div>

        <div class="input-group">
            <label>📞 Phone</label>
            <input type="text" name="phone" placeholder="Enter phone number" required>
        </div>

        <div class="input-group">
            <label>🏠 Address</label>
            <input type="text" name="address" placeholder="Enter address" required>
        </div>

        <input type="hidden" name="role" value="customer">
        <input type="submit" value="Register" class="btn">
    </form>

    <div class="links">
        Already have an account? <a href="customerLogin.jsp">Login Here</a>
    </div>

    <input type="button" value="⬅ Go to Home" class="btn home-btn" onclick="location.href='index.jsp'">
</div>

<div id="toast"></div>

<%
String msg = (String) request.getAttribute("msg");
if(msg != null){
%>
<script>
    showToast("<%=msg%>");
</script>
<% } %>

</body>
</html>
