package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.util.DBConnection;

@WebServlet("/ApproveOrderServlet")
public class ApproveOrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("order_id"));

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE orders SET status='APPROVED' WHERE order_id=?"
            );
            ps.setInt(1, orderId);
            ps.executeUpdate();

            response.sendRedirect("adminOrders.jsp");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}
