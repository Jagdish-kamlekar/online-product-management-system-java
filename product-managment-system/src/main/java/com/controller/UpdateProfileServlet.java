package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.util.DBConnection;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = request.getParameter("email"); // email is readonly, so we use it to identify user
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {
            Connection con = DBConnection.getConnection();

            // Update only fields that are not empty
            String sql = "UPDATE users SET name=?, phone=?, address=? WHERE email=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);    // can be same as before if user didn't change
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, email);

            int i = ps.executeUpdate();
            if(i > 0){
                session.setAttribute("toast", "✅ Profile updated successfully!");
            } else {
                session.setAttribute("toast", "❌ No changes were made!");
            }

            ps.close();
            con.close();

            response.sendRedirect("profile.jsp");

        } catch(Exception e){
            e.printStackTrace();
            session.setAttribute("toast", "❌ Error updating profile!");
            response.sendRedirect("profile.jsp");
        }
    }
}
