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

@WebServlet("/AddCartServlet")
public class AddCartServlet extends HttpServlet {

protected void doGet(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

    HttpSession session = req.getSession();
    String email = (String) session.getAttribute("email");

    int pid = Integer.parseInt(req.getParameter("pid"));

    try {
        Connection con = DBConnection.getConnection();

        /* 1️⃣ Product stock nikaalo */
        PreparedStatement ps1 = con.prepareStatement(
            "SELECT name, price, quantity FROM product WHERE id=?"
        );
        ps1.setInt(1, pid);
        ResultSet rs1 = ps1.executeQuery();

        if (!rs1.next()) {
            res.sendRedirect("customerViewProducts.jsp");
            return;
        }

        String pname = rs1.getString("name");
        double price = rs1.getDouble("price");
        int stockQty = rs1.getInt("quantity");

        /* 2️⃣ Cart me already hai? */
        PreparedStatement ps2 = con.prepareStatement(
            "SELECT quantity FROM cart WHERE user_email=? AND product_id=?"
        );
        ps2.setString(1, email);
        ps2.setInt(2, pid);
        ResultSet rs2 = ps2.executeQuery();

        if (rs2.next()) {
            int cartQty = rs2.getInt("quantity");

            /* ❌ Stock limit cross */
            if (cartQty >= stockQty) {
                session.setAttribute("msg", "Stock limit reached!");
            } else {
                PreparedStatement ps3 = con.prepareStatement(
                    "UPDATE cart SET quantity=quantity+1 WHERE user_email=? AND product_id=?"
                );
                ps3.setString(1, email);
                ps3.setInt(2, pid);
                ps3.executeUpdate();
            }

        } else {
            /* 3️⃣ New item insert */
            PreparedStatement ps4 = con.prepareStatement(
                "INSERT INTO cart(user_email, product_id, pname, price, quantity) VALUES (?,?,?,?,1)"
            );
            ps4.setString(1, email);
            ps4.setInt(2, pid);
            ps4.setString(3, pname);
            ps4.setDouble(4, price);
            ps4.executeUpdate();
        }

        res.sendRedirect("customerViewProducts.jsp");

    } catch (Exception e) {
        e.printStackTrace();
    }
}
}
