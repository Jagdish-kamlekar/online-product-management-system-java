package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {

protected void doPost(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

    HttpSession session = req.getSession();
    String email = (String) session.getAttribute("email");

    int pid = Integer.parseInt(req.getParameter("pid"));
    String action = req.getParameter("action");

    try {
        Connection con = DBConnection.getConnection();

        /* 1️⃣ Cart quantity */
        PreparedStatement ps1 = con.prepareStatement(
            "SELECT quantity FROM cart WHERE user_email=? AND product_id=?");
        ps1.setString(1, email);
        ps1.setInt(2, pid);
        ResultSet rs1 = ps1.executeQuery();

        if (!rs1.next()) {
            res.sendRedirect("cart.jsp");
            return;
        }

        int cartQty = rs1.getInt("quantity");

        /* 2️⃣ Product stock */
        PreparedStatement ps2 = con.prepareStatement(
            "SELECT quantity FROM product WHERE id=?");
        ps2.setInt(1, pid);
        ResultSet rs2 = ps2.executeQuery();

        rs2.next();
        int stockQty = rs2.getInt("quantity");

        /* 3️⃣ ADD */
        if ("add".equals(action)) {

            if (cartQty < stockQty) {
                PreparedStatement ps3 = con.prepareStatement(
                    "UPDATE cart SET quantity=quantity+1 WHERE user_email=? AND product_id=?");
                ps3.setString(1, email);
                ps3.setInt(2, pid);
                ps3.executeUpdate();
            } else {
                session.setAttribute("msg", "❌ Stock limit reached");
            }

        }

        /* 4️⃣ REMOVE */
        if ("remove".equals(action)) {

            if (cartQty > 1) {
                PreparedStatement ps4 = con.prepareStatement(
                    "UPDATE cart SET quantity=quantity-1 WHERE user_email=? AND product_id=?");
                ps4.setString(1, email);
                ps4.setInt(2, pid);
                ps4.executeUpdate();
            } else {
                PreparedStatement ps5 = con.prepareStatement(
                    "DELETE FROM cart WHERE user_email=? AND product_id=?");
                ps5.setString(1, email);
                ps5.setInt(2, pid);
                ps5.executeUpdate();
            }
        }

        res.sendRedirect("cart.jsp");

    } catch (Exception e) {
        e.printStackTrace();
    }
}
}
