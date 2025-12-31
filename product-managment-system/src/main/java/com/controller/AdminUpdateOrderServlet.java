package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.util.DBConnection;

@WebServlet("/AdminUpdateOrderServlet")
public class AdminUpdateOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        try (Connection con = DBConnection.getConnection()) {
            String status = "PLACED";
            if("approve".equals(action)) status = "APPROVED";
            else if("cancel".equals(action)) status = "CANCELLED";

            PreparedStatement ps = con.prepareStatement("UPDATE orders SET status=? WHERE order_id=?");
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
            ps.close();

        } catch(Exception e) { e.printStackTrace(); }

        response.sendRedirect("adminOrders.jsp");
    }
}
