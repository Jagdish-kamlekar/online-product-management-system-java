<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Login | Product Management System</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Arial, sans-serif;
    min-height: 100vh;
    background: linear-gradient(270deg, #0f0c29, #302b63, #24243e);
    background-size: 400% 400%;
    animation: gradientMove 12s ease infinite;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden;
}

/* Animated Background */
@keyframes gradientMove {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* Neon Floating Orbs */
.bg-circle {
    position: absolute;
    width: 260px;
    height: 260px;
    border-radius: 50%;
    filter: blur(45px);
    opacity: 0.6;
    animation: float 8s infinite ease-in-out;
}

.bg1 {
    top: 8%;
    left: 10%;
    background: radial-gradient(circle, #6a11cb, #2575fc);
}

.bg2 {
    bottom: 10%;
    right: 12%;
    background: radial-gradient(circle, #ff512f, #dd2476);
    animation-delay: 2s;
}

@keyframes float {
    0%,100% { transform: translateY(0); }
    50% { transform: translateY(-35px); }
}

/* Glass Login Box */
.login-box {
    position: relative;
    width: 420px;
    padding: 45px;
    border-radius: 28px;
    background: rgba(255, 255, 255, 0.12);
    backdrop-filter: blur(22px);
    border: 1px solid rgba(255,255,255,0.35);
    box-shadow: 0 40px 80px rgba(0,0,0,0.6);
    text-align: center;
    animation: fadeUp 1s ease;
}

@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(60px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

/* Title */
.login-box h2 {
    font-size: 30px;
    background: linear-gradient(90deg, #6a11cb, #2575fc, #ff512f);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 8px;
    filter: drop-shadow(0 0 8px rgba(255,255,255,0.3));
}

.subtitle {
    font-size: 14px;
    color: #ddd;
    margin-bottom: 28px;
}

/* Inputs */
.input-group {
    text-align: left;
    margin-bottom: 20px;
}

.input-group label {
    font-size: 14px;
    font-weight: 600;
    color: #eee;
}

.input-group input {
    width: 100%;
    padding: 15px 16px;
    margin-top: 6px;
    border-radius: 14px;
    border: none;
    font-size: 15px;
    background: rgba(255,255,255,0.9);
    transition: 0.35s;
}

.input-group input:focus {
    outline: none;
    box-shadow: 0 0 0 5px rgba(106,17,203,0.35);
    transform: scale(1.02);
}

/* Neon Button */
.btn {
    width: 100%;
    padding: 16px;
    margin-top: 10px;
    background: linear-gradient(135deg, #6a11cb, #2575fc);
    border: none;
    color: white;
    font-size: 17px;
    border-radius: 40px;
    cursor: pointer;
    font-weight: bold;
    letter-spacing: 1px;
    position: relative;
    overflow: hidden;
    box-shadow: 0 0 30px rgba(106,17,203,0.8);
    transition: 0.35s;
}

.btn::before {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(120deg, transparent, rgba(255,255,255,0.6), transparent);
    transform: translateX(-100%);
}

.btn:hover::before {
    animation: shine 0.9s;
}

@keyframes shine {
    to { transform: translateX(100%); }
}

.btn:hover {
    transform: translateY(-4px) scale(1.05);
    filter: brightness(1.15);
}

/* Error */
.error {
    background: rgba(255,0,0,0.15);
    color: #ffb3b3;
    padding: 12px;
    margin-top: 18px;
    border-radius: 12px;
    font-size: 14px;
}

/* Back link */
.back {
    margin-top: 26px;
    font-size: 14px;
    color: #ddd;
}

.back a {
    color: #6a11cb;
    font-weight: 600;
    text-decoration: none;
    transition: 0.3s;
}

.back a:hover {
    color: #ff512f;
    text-decoration: underline;
}
</style>
</head>

<body>

<div class="bg-circle bg1"></div>
<div class="bg-circle bg2"></div>

<div class="login-box">
    <h2>🔐 Admin Login</h2>
    <div class="subtitle">Product Management System</div>

    <form action="LoginServlet" method="post">
        <input type="hidden" name="loginType" value="admin">

        <div class="input-group">
            <label>📧 Email</label>
            <input type="text" name="email" placeholder="Enter admin email" required>
        </div>

        <div class="input-group">
            <label>🔑 Password</label>
            <input type="password" name="password" placeholder="Enter password" required>
        </div>

        <input type="submit" value="Login" class="btn">
    </form>

    <%
        String msg = (String) request.getAttribute("msg");
        if (msg != null) {
    %>
        <div class="error"><%=msg%></div>
    <%
        }
    %>

    <div class="back">
        ⬅ <a href="index.jsp">Back to Home</a>
    </div>
</div>

</body>
</html>
