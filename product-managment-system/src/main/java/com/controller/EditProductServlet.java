package com.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.util.DBConnection;

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {

protected void doGet(HttpServletRequest req, HttpServletResponse res)
throws ServletException, IOException {

HttpSession session = req.getSession(false);
if(session == null || !"admin".equals(session.getAttribute("role"))){
    res.sendRedirect("adminLogin.jsp");
    return;
}

int id = Integer.parseInt(req.getParameter("id"));

try{
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM product WHERE id=?");
ps.setInt(1, id);

ResultSet rs = ps.executeQuery();

if(rs.next()){
    req.setAttribute("id", rs.getInt("id"));
    req.setAttribute("name", rs.getString("name"));
    req.setAttribute("price", rs.getDouble("price"));
    req.setAttribute("qty", rs.getInt("quantity"));
    req.setAttribute("category", rs.getString("category"));

    RequestDispatcher rd = req.getRequestDispatcher("editProduct.jsp");
    rd.forward(req, res);
}else{
    res.sendRedirect("viewProducts.jsp");
}

}catch(Exception e){
e.printStackTrace();
}
}
}
