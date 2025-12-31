<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>
<style>
body {
    font-family: Arial;
    background: #f2f2f2;
}
.login-box {
    width: 300px;
    margin: 100px auto;
    padding: 20px;
    background: white;
    box-shadow: 0 0 10px gray;
}
input {
    width: 100%;
    padding: 8px;
    margin: 8px 0;
}
button {
    width: 100%;
    padding: 8px;
    background: green;
    color: white;
    border: none;
}
.error {
    color: red;
}
</style>
</head>

<body>

<div class="login-box">
    <h2>Login</h2>

    <form action="LoginServlet" method="post">
        <input type="text" name="email" placeholder="Enter Email" required>
        <input type="password" name="password" placeholder="Enter Password" required>
        <button type="submit">Login</button>
    </form>

    <%
        String msg = (String) request.getAttribute("msg");
        if(msg != null){
    %>
        <p class="error"><%= msg %></p>
    <%
        }
    %>
</div>

</body>
</html>
