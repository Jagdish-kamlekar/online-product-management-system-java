<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Product Management System</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', sans-serif;
    min-height: 100vh;
    background: linear-gradient(270deg, #0f2027, #203a43, #2c5364);
    background-size: 400% 400%;
    animation: gradientMove 12s ease infinite;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden;
}

/* Animated Gradient Background */
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
    filter: blur(40px);
    opacity: 0.6;
    animation: float 8s infinite ease-in-out;
}

.bg1 {
    top: 8%;
    left: 10%;
    background: radial-gradient(circle, #00f2fe, #4facfe);
}

.bg2 {
    bottom: 10%;
    right: 12%;
    background: radial-gradient(circle, #f857a6, #ff5858);
    animation-delay: 2s;
}

@keyframes float {
    0%,100% { transform: translateY(0); }
    50% { transform: translateY(-35px); }
}

/* Glassmorphism Container */
.container {
    position: relative;
    width: 470px;
    padding: 48px;
    border-radius: 30px;
    background: rgba(255, 255, 255, 0.12);
    backdrop-filter: blur(22px);
    border: 1px solid rgba(255,255,255,0.3);
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

/* Logo (3D + Neon) */
.logo {
    font-size: 54px;
    margin-bottom: 12px;
    filter: drop-shadow(0 0 10px #00f2fe);
}

/* Gradient Chrome Text */
h2 {
    font-size: 28px;
    background: linear-gradient(90deg, #00f2fe, #4facfe, #43cea2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 10px;
}

p {
    color: #ddd;
    margin-bottom: 30px;
    font-size: 14px;
}

/* Feature Cards */
.features {
    display: flex;
    gap: 12px;
    margin-bottom: 30px;
}

.feature {
    flex: 1;
    padding: 14px;
    border-radius: 16px;
    font-size: 12px;
    color: #fff;
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(10px);
    box-shadow: inset 0 0 20px rgba(255,255,255,0.15);
    transition: 0.4s;
}

.feature:hover {
    transform: translateY(-6px) scale(1.05);
    box-shadow: 0 15px 30px rgba(0,0,0,0.5);
}

/* Neon 3D Buttons */
.btn {
    display: block;
    width: 100%;
    padding: 16px;
    margin: 16px 0;
    font-size: 18px;
    border-radius: 40px;
    text-decoration: none;
    color: white;
    font-weight: bold;
    letter-spacing: 1px;
    transition: 0.35s;
    position: relative;
    overflow: hidden;
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

.admin {
    background: linear-gradient(135deg, #667eea, #764ba2);
    box-shadow: 0 0 25px rgba(118,75,162,0.8);
}

.customer {
    background: linear-gradient(135deg, #43cea2, #11998e);
    box-shadow: 0 0 25px rgba(67,206,162,0.8);
}

.btn:hover {
    transform: translateY(-4px) scale(1.05);
    filter: brightness(1.15);
}

/* Footer */
.footer {
    margin-top: 26px;
    font-size: 12px;
    color: #ccc;
}
</style>



</head>
<body>

	<div class="bg-circle bg1"></div>
	<div class="bg-circle bg2"></div>

	<div class="container">

		<div class="logo">📦</div>

		<h2>Product Management System</h2>
		<p>Secure • Fast • Modern product handling platform</p>

		<div class="features">
			<div class="feature">🔒 Secure Login</div>
			<div class="feature">⚡ Fast Orders</div>
			<div class="feature">📊 Easy Control</div>
		</div>

		<a href="adminLogin.jsp" class="btn admin">🔐 Admin Login</a> <a
			href="customerLogin.jsp" class="btn customer">🛒 Customer Login</a>

		<div class="footer">
			© 2025 Product Management System <br>Designed By Jagdish Kamlekar</b> with ❤️ for <b>Java Full Stack</b>
		</div>
	</div>

</body>
</html>
