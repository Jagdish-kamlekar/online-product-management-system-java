<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
int id = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnection.getConnection();
PreparedStatement ps =
 con.prepareStatement("SELECT * FROM product WHERE id=?");
ps.setInt(1, id);

ResultSet rs = ps.executeQuery();
rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Product</title>

<style>
body{
    margin:0;
    font-family: Arial, Helvetica, sans-serif;
    background: linear-gradient(135deg,#1d2671,#c33764);
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
}

.card{
    background:#fff;
    width:380px;
    padding:25px;
    border-radius:12px;
    box-shadow:0 10px 25px rgba(0,0,0,0.25);
}

.card h2{
    text-align:center;
    margin-bottom:20px;
    color:#1d2671;
}

input{
    width:100%;
    padding:10px;
    margin:8px 0;
    border:1px solid #ccc;
    border-radius:6px;
    font-size:14px;
}

input:focus{
    border-color:#1d2671;
    outline:none;
}

button{
    width:100%;
    padding:10px;
    margin-top:15px;
    background:#1d2671;
    color:white;
    border:none;
    border-radius:6px;
    font-size:15px;
    cursor:pointer;
}

button:hover{
    background:#16205c;
}

.back{
    display:block;
    text-align:center;
    margin-top:15px;
    text-decoration:none;
    color:#1d2671;
    font-weight:bold;
}

.back:hover{
    text-decoration:underline;
}
</style>

</head>
<body>

<div class="card">

<h2>✏ Edit Product</h2>

<form action="UpdateProductServlet" method="post">

<input type="hidden" name="id" value="<%=id%>">

<input type="text" name="name"
 value="<%=rs.getString("name")%>"
 placeholder="Product Name" required>

<input type="number" name="price"
 value="<%=rs.getDouble("price")%>"
 placeholder="Price" required>

<input type="number" name="quantity"
 value="<%=rs.getInt("quantity")%>"
 placeholder="Quantity" required>

<input type="text" name="category"
 value="<%=rs.getString("category")%>"
 placeholder="Category" required>

<button type="submit">Update Product</button>

</form>

<a href="viewProducts.jsp" class="back">⬅ Back to Products</a>

</div>

</body>
</html>
