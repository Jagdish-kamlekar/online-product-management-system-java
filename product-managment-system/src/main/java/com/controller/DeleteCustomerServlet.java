package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.util.DBConnection;

@WebServlet("/DeleteCustomerServlet")
public class DeleteCustomerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 🔐 Admin check
        if (session.getAttribute("email") == null ||
            !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // ✅ transaction start

            // 1️⃣ Delete order_items
            PreparedStatement ps1 = con.prepareStatement(
                "DELETE oi FROM order_items oi " +
                "JOIN orders o ON oi.order_id = o.order_id " +
                "WHERE o.user_email = (SELECT email FROM users WHERE id=?)"
            );
            ps1.setInt(1, userId);
            ps1.executeUpdate();

            // 2️⃣ Delete orders
            PreparedStatement ps2 = con.prepareStatement(
                "DELETE FROM orders WHERE user_email = (SELECT email FROM users WHERE id=?)"
            );
            ps2.setInt(1, userId);
            ps2.executeUpdate();

            // 3️⃣ Delete cart
            PreparedStatement ps3 = con.prepareStatement(
                "DELETE FROM cart WHERE user_email = (SELECT email FROM users WHERE id=?)"
            );
            ps3.setInt(1, userId);
            ps3.executeUpdate();

            // 4️⃣ Delete user
            PreparedStatement ps4 = con.prepareStatement(
                "DELETE FROM users WHERE id=? AND role='customer'"
            );
            ps4.setInt(1, userId);
            int result = ps4.executeUpdate();

            con.commit(); // ✅ success

            if (result > 0) {
                session.setAttribute("msg", "✅ Customer removed successfully");
            } else {
                session.setAttribute("msg", "❌ Customer not found");
            }

            response.sendRedirect("viewCustomers.jsp");

        } catch (Exception e) {
            try {
                if (con != null)
                    con.rollback(); // ❌ rollback
            } catch (Exception ex) {}

            e.printStackTrace();
            session.setAttribute("msg", "❌ Delete failed due to orders");
            response.sendRedirect("viewCustomers.jsp");
        }
    }
}
