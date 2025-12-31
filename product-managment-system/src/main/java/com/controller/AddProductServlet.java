package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.util.DBConnection;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {

    // If someone types servlet URL directly
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("addProduct.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String qty = request.getParameter("qty");
        String category = request.getParameter("category");

        // ✅ Validation
        if (name == null || name.trim().isEmpty() ||
            price == null || price.trim().isEmpty() ||
            qty == null || qty.trim().isEmpty() ||
            category == null || category.trim().isEmpty()) {

            session.setAttribute("msg", "❌ All fields are required");
            response.sendRedirect("addProduct.jsp");
            return;
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO product(name, price, quantity, category) VALUES (?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setDouble(2, Double.parseDouble(price));
            ps.setInt(3, Integer.parseInt(qty));
            ps.setString(4, category);

            ps.executeUpdate();

            // ✅ Success message
            session.setAttribute("msg", "✅ Product added successfully");

            // ✅ Redirect to view page
            response.sendRedirect("viewProducts.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "❌ Error while adding product");
            response.sendRedirect("addProduct.jsp");
        }
    }
}
