package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.util.DBConnection;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // 🔐 start transaction

            // 🔒 lock cart rows
            PreparedStatement psCart = con.prepareStatement(
                "SELECT * FROM cart WHERE user_email=? FOR UPDATE"
            );
            psCart.setString(1, email);
            ResultSet rsCart = psCart.executeQuery();

            if (!rsCart.next()) {
                session.setAttribute("error", "Cart is empty!");
                response.sendRedirect("cart.jsp");
                return;
            }

            double total = Double.parseDouble(request.getParameter("total"));

            // ✅ insert order
            PreparedStatement psOrder = con.prepareStatement(
                "INSERT INTO orders(user_email, total_amount, order_date, status) VALUES (?, ?, NOW(), 'PLACED')",
                Statement.RETURN_GENERATED_KEYS
            );
            psOrder.setString(1, email);
            psOrder.setDouble(2, total);
            psOrder.executeUpdate();

            ResultSet rsKey = psOrder.getGeneratedKeys();
            rsKey.next();
            int orderId = rsKey.getInt(1);

            // ✅ insert order items
            PreparedStatement psItems = con.prepareStatement(
                "INSERT INTO order_items(order_id, product_id, pname, price, quantity) VALUES (?, ?, ?, ?, ?)"
            );

            do {
                psItems.setInt(1, orderId);
                psItems.setInt(2, rsCart.getInt("product_id"));
                psItems.setString(3, rsCart.getString("pname"));
                psItems.setDouble(4, rsCart.getDouble("price"));
                psItems.setInt(5, rsCart.getInt("quantity"));
                psItems.addBatch();
            } while (rsCart.next());

            psItems.executeBatch();

            // ✅ clear cart
            PreparedStatement clear = con.prepareStatement(
                "DELETE FROM cart WHERE user_email=?"
            );
            clear.setString(1, email);
            clear.executeUpdate();

            con.commit(); // ✅ success

            session.setAttribute("success",
                "Order placed successfully 🕒 Waiting for Admin approval");
            response.sendRedirect("myOrders.jsp");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=Order failed");
        }
    }
}
