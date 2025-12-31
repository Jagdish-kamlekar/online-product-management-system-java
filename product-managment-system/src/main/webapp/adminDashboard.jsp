<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
if (session.getAttribute("email") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect("adminLogin.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | Product Management System</title>

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
    padding: 60px 20px;
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
    width: 280px;
    height: 280px;
    border-radius: 50%;
    filter: blur(50px);
    opacity: 0.6;
    animation: float 9s infinite ease-in-out;
    z-index: -1;
}

.bg1 {
    top: 10%;
    left: 5%;
    background: radial-gradient(circle, #6a11cb, #2575fc);
}

.bg2 {
    bottom: 10%;
    right: 8%;
    background: radial-gradient(circle, #ff512f, #dd2476);
    animation-delay: 3s;
}

@keyframes float {
    0%,100% { transform: translateY(0); }
    50% { transform: translateY(-40px); }
}

/* Container */
.dashboard-container {
    max-width: 1200px;
    margin: auto;
}

/* Header */
.header {
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(20px);
    padding: 28px;
    border-radius: 26px;
    text-align: center;
    color: white;
    margin-bottom: 45px;
    box-shadow: 0 35px 70px rgba(0,0,0,0.6);
    animation: fadeUp 0.8s ease;
}

.header h2 {
    font-size: 32px;
    background: linear-gradient(90deg, #6a11cb, #2575fc, #ff512f);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.header p {
    font-size: 16px;
    color: #ddd;
}

/* Welcome Card */
.welcome-card {
    background: rgba(255,255,255,0.9);
    border-radius: 24px;
    padding: 30px;
    text-align: center;
    box-shadow: 0 25px 55px rgba(0,0,0,0.35);
    margin-bottom: 45px;
    animation: fadeUp 1s ease;
}

.welcome-card h3 {
    color: #302b63;
    margin-bottom: 10px;
}

.welcome-card p {
    font-size: 15px;
    color: #555;
}

/* Cards grid */
.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 30px;
}

/* Card */
.card {
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(18px);
    border-radius: 24px;
    padding: 30px;
    text-align: center;
    color: white;
    box-shadow: 0 30px 60px rgba(0,0,0,0.6);
    transition: 0.4s;
    position: relative;
    overflow: hidden;
}

.card::before {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(120deg, transparent, rgba(255,255,255,0.35), transparent);
    transform: translateX(-100%);
}

.card:hover::before {
    animation: shine 1s;
}

@keyframes shine {
    to { transform: translateX(100%); }
}

.card:hover {
    transform: translateY(-12px) scale(1.05);
    box-shadow: 0 45px 90px rgba(0,0,0,0.8);
}

.card h4 {
    margin-bottom: 10px;
    background: linear-gradient(90deg, #ff512f, #f09819);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.card p {
    font-size: 14px;
    color: #ddd;
    margin-bottom: 18px;
}

/* Card Button */
.card a {
    display: inline-block;
    padding: 12px 28px;
    background: linear-gradient(135deg, #6a11cb, #2575fc);
    color: white;
    border-radius: 30px;
    font-weight: bold;
    text-decoration: none;
    letter-spacing: 1px;
    transition: 0.3s;
    box-shadow: 0 0 25px rgba(106,17,203,0.8);
}

.card a:hover {
    filter: brightness(1.2);
    transform: translateY(-3px);
}

/* Logout */
.logout {
    text-align: center;
    margin-top: 55px;
}

.logout a {
    padding: 14px 36px;
    background: linear-gradient(135deg, #ff512f, #dd2476);
    color: white;
    border-radius: 35px;
    text-decoration: none;
    font-weight: bold;
    letter-spacing: 1px;
    box-shadow: 0 0 30px rgba(255,81,47,0.9);
    transition: 0.35s;
}

.logout a:hover {
    transform: translateY(-4px) scale(1.05);
    filter: brightness(1.15);
}

/* Footer */
.footer {
    text-align: center;
    margin-top: 45px;
    font-size: 14px;
    color: #ddd;
}

/* Fade animation */
@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(50px) scale(0.96);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}
</style>
</head>

<body>

<div class="bg-circle bg1"></div>
<div class="bg-circle bg2"></div>

<div class="dashboard-container">

    <div class="header">
        <h2>📦 Product Management System</h2>
        <p>Admin Dashboard</p>
    </div>

    <div class="welcome-card">
        <h3>👋 Welcome Admin</h3>
        <p>You can manage products, customers, and system data from here.</p>
    </div>

    <div class="cards">
        <div class="card">
            <h4>➕ Add Product</h4>
            <p>Add new products to the system</p>
            <a href="addProduct.jsp">Open</a>
        </div>

        <div class="card">
            <h4>📋 View Products</h4>
            <p>View and manage all products</p>
            <a href="viewProducts.jsp">Open</a>
        </div>

        <div class="card">
            <h4>👥 Manage Customers</h4>
            <p>View registered customers</p>
            <a href="viewCustomers.jsp">Open</a>
        </div>

        <div class="card">
            <h4>📦 Orders</h4>
            <p>Manage customer orders</p>
            <a href="adminOrders.jsp">Open</a>
        </div>
    </div>

    <div class="logout">
        <a href="LogoutServlet">🚪 Logout</a>
    </div>

    <div class="footer">
        Designed By Jagdish Kamlekar ❤️ | Java Full Stack
    </div>

</div>

</body>
</html>
