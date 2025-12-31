package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import com.util.DBConnection;

public class BuyNowServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        int cartId = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DBConnection.getConnection();

            // get cart data
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT * FROM cart WHERE id=?"
            );
            ps1.setInt(1, cartId);
            ResultSet rs = ps1.executeQuery();

            if(rs.next()){
                PreparedStatement ps2 = con.prepareStatement(
                    "INSERT INTO orders(user_email,pname,price,quantity) VALUES(?,?,?,?)"
                );
                ps2.setString(1, email);
                ps2.setString(2, rs.getString("pname"));
                ps2.setDouble(3, rs.getDouble("price"));
                ps2.setInt(4, rs.getInt("quantity"));
                ps2.executeUpdate();

                // delete from cart
                PreparedStatement ps3 = con.prepareStatement(
                    "DELETE FROM cart WHERE id=?"
                );
                ps3.setInt(1, cartId);
                ps3.executeUpdate();
            }

            session.setAttribute("toast", "Order placed successfully 🎉");
            response.sendRedirect("cart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
