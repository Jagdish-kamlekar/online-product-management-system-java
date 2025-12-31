<%@ page language="java" contentType="text/html; charset=UTF-8"%>

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
<title>Add Product | Admin</title>

<style>
/* Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Arial, sans-serif;
}

/* Body */
body {
    min-height: 100vh;
    background: linear-gradient(270deg, #0f0c29, #302b63, #24243e);
    background-size: 400% 400%;
    animation: gradientMove 14s ease infinite;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 40px 20px;
}

/* Animated gradient */
@keyframes gradientMove {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* Floating neon orbs */
.bg-circle {
    position: fixed;
    width: 260px;
    height: 260px;
    border-radius: 50%;
    filter: blur(45px);
    opacity: 0.6;
    animation: float 9s infinite ease-in-out;
    z-index: -1;
}

.bg1 {
    top: 10%;
    left: 8%;
    background: radial-gradient(circle, #6a11cb, #2575fc);
}

.bg2 {
    bottom: 12%;
    right: 10%;
    background: radial-gradient(circle, #ff512f, #dd2476);
    animation-delay: 3s;
}

@keyframes float {
    0%,100% { transform: translateY(0); }
    50% { transform: translateY(-35px); }
}

/* Glass Card */
.box {
    width: 430px;
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(22px);
    padding: 40px;
    border-radius: 28px;
    border: 1px solid rgba(255,255,255,0.35);
    box-shadow: 0 35px 80px rgba(0,0,0,0.6);
    animation: fadeUp 0.9s ease;
}

/* Animation */
@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(50px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

/* Heading */
.box h2 {
    text-align: center;
    font-size: 28px;
    margin-bottom: 28px;
    background: linear-gradient(90deg, #6a11cb, #2575fc, #ff512f);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

/* Labels */
label {
    font-size: 14px;
    font-weight: bold;
    color: #eee;
    margin-top: 14px;
    display: block;
}

/* Inputs */
input {
    width: 100%;
    padding: 15px;
    margin-top: 6px;
    border-radius: 14px;
    border: none;
    font-size: 14px;
    background: rgba(255,255,255,0.9);
    transition: 0.35s;
}

input:focus {
    outline: none;
    transform: scale(1.02);
    box-shadow: 0 0 0 5px rgba(106,17,203,0.35);
}

/* Button */
button {
    width: 100%;
    padding: 16px;
    margin-top: 26px;
    font-size: 16px;
    font-weight: bold;
    border: none;
    border-radius: 40px;
    background: linear-gradient(135deg, #6a11cb, #2575fc);
    color: white;
    cursor: pointer;
    letter-spacing: 1px;
    box-shadow: 0 0 30px rgba(106,17,203,0.8);
    transition: 0.35s;
    position: relative;
    overflow: hidden;
}

button::before {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(120deg, transparent, rgba(255,255,255,0.6), transparent);
    transform: translateX(-100%);
}

button:hover::before {
    animation: shine 0.9s;
}

@keyframes shine {
    to { transform: translateX(100%); }
}

button:hover {
    transform: translateY(-4px) scale(1.05);
    filter: brightness(1.15);
}

/* Back link */
.back {
    text-align: center;
    margin-top: 22px;
}

.back a {
    color: #6a11cb;
    font-weight: bold;
    text-decoration: none;
    transition: 0.3s;
}

.back a:hover {
    color: #ff512f;
    text-decoration: underline;
}

/* Footer */
.footer {
    text-align: center;
    margin-top: 26px;
    font-size: 12px;
    color: #ddd;
}
</style>
</head>

<body>

<div class="bg-circle bg1"></div>
<div class="bg-circle bg2"></div>

<div class="box">
    <h2>➕ Add Product</h2>

    <form action="AddProductServlet" method="post">

        <label>📦 Product Name</label>
        <input type="text" name="name" placeholder="Enter product name" required>

        <label>💰 Price</label>
        <input type="number" name="price" step="0.01" placeholder="Enter price" required>

        <label>📊 Quantity</label>
        <input type="number" name="qty" placeholder="Enter quantity" required>

        <label>🏷 Category</label>
        <input type="text" name="category" placeholder="Enter category" required>

        <button type="submit">Add Product</button>
    </form>

    <div class="back">
        ⬅ <a href="adminDashboard.jsp">Back to Dashboard</a>
    </div>

    <div class="footer">
        Designed By Jagdish Kamlekar ❤️ | Java Full Stack
    </div>
</div>

</body>
</html>
