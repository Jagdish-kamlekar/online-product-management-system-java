package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.util.DBConnection;

@WebServlet("/UpdateProductServlet")
public class UpdateProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String qtyStr = request.getParameter("quantity");
        String category = request.getParameter("category");

        try {
            Connection con = DBConnection.getConnection();

            // 1️⃣ Get OLD data
            PreparedStatement ps1 =
                con.prepareStatement("SELECT * FROM product WHERE id=?");
            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();
            rs.next();

            String oldName = rs.getString("name");
            double oldPrice = rs.getDouble("price");
            int oldQty = rs.getInt("quantity");
            String oldCategory = rs.getString("category");

            // 2️⃣ If field empty → use old value
            String finalName =
                (name == null || name.trim().isEmpty()) ? oldName : name;

            double finalPrice =
                (priceStr == null || priceStr.trim().isEmpty())
                ? oldPrice : Double.parseDouble(priceStr);

            int finalQty =
                (qtyStr == null || qtyStr.trim().isEmpty())
                ? oldQty : Integer.parseInt(qtyStr);

            String finalCategory =
                (category == null || category.trim().isEmpty())
                ? oldCategory : category;

            // 3️⃣ Update
            PreparedStatement ps2 =
                con.prepareStatement(
                  "UPDATE product SET name=?, price=?, quantity=?, category=? WHERE id=?");

            ps2.setString(1, finalName);
            ps2.setDouble(2, finalPrice);
            ps2.setInt(3, finalQty);
            ps2.setString(4, finalCategory);
            ps2.setInt(5, id);

            ps2.executeUpdate();

            // 4️⃣ Success message
            HttpSession session = request.getSession();
            session.setAttribute("msg", "Product updated successfully");

            response.sendRedirect("viewProducts.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewProducts.jsp");
        }
    }
}
