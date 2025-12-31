package com.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ViewProductsServlet")
public class ViewProductsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> products = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pmsdb", "root", "root");

            PreparedStatement ps =
                    con.prepareStatement("SELECT * FROM product");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> p = new HashMap<>();
                p.put("id", rs.getInt("id"));
                p.put("name", rs.getString("name"));
                p.put("price", rs.getDouble("price"));
                p.put("quantity", rs.getInt("quantity"));
                p.put("category", rs.getString("category"));
                products.add(p);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("products", products);
        RequestDispatcher rd = request.getRequestDispatcher("viewProducts.jsp");
        rd.forward(request, response);
    }
}
