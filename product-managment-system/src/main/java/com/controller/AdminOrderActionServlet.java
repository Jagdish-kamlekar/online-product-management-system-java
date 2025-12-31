package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.util.DBConnection;

@WebServlet("/AdminOrderActionServlet")
public class AdminOrderActionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 🔐 Admin check
        if (session.getAttribute("email") == null ||
            !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String action = request.getParameter("action"); // APPROVED / CANCELLED

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // ✅ If approve → reduce stock
            if ("APPROVED".equals(action)) {

                PreparedStatement psCheck = con.prepareStatement(
                    "SELECT oi.product_id, oi.quantity, p.quantity AS stock " +
                    "FROM order_items oi JOIN product p ON oi.product_id=p.id " +
                    "WHERE oi.order_id=?"
                );
                psCheck.setInt(1, orderId);
                ResultSet rs = psCheck.executeQuery();

                while (rs.next()) {
                    if (rs.getInt("stock") < rs.getInt("quantity")) {
                        session.setAttribute("msg", "Not enough stock!");
                        response.sendRedirect("adminOrders.jsp");
                        return;
                    }
                }

                PreparedStatement psReduce = con.prepareStatement(
                    "UPDATE product p JOIN order_items oi ON p.id=oi.product_id " +
                    "SET p.quantity = p.quantity - oi.quantity WHERE oi.order_id=?"
                );
                psReduce.setInt(1, orderId);
                psReduce.executeUpdate();
            }

            // ✅ Update order status
            PreparedStatement ps = con.prepareStatement(
                "UPDATE orders SET status=? WHERE order_id=?"
            );
            ps.setString(1, action);
            ps.setInt(2, orderId);
            ps.executeUpdate();

            con.commit();
            session.setAttribute("msg", "Order " + action + " successfully!");
            response.sendRedirect("adminOrders.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminOrders.jsp");
        }
    }
}
