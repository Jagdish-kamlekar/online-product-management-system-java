package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.util.DBConnection;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int pid = Integer.parseInt(request.getParameter("pid"));
        String pname = request.getParameter("pname");
        double price = Double.parseDouble(request.getParameter("price"));

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO cart(user_email, product_id, pname, price, quantity) " +
                "VALUES (?, ?, ?, ?, 1) " +
                "ON DUPLICATE KEY UPDATE quantity = quantity + 1"
            );

            ps.setString(1, email);
            ps.setInt(2, pid);
            ps.setString(3, pname);
            ps.setDouble(4, price);

            ps.executeUpdate();
            response.sendRedirect("customerViewProducts.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
