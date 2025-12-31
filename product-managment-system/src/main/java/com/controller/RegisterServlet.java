package com.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.util.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {
            Connection con = DBConnection.getConnection();

            // Check if email already exists
            PreparedStatement check = con.prepareStatement(
                "SELECT * FROM users WHERE email=?"
            );
            check.setString(1, email);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                request.setAttribute("msg", "❌ Email already registered!");
                RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
                rd.forward(request, response);
                return;
            }

            // Insert user
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name, email, password, role, phone, address) VALUES(?,?,?,?,?,?)"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password); // For real apps, hash password!
            ps.setString(4, role);
            ps.setString(5, phone);
            ps.setString(6, address);

            int i = ps.executeUpdate();
            if (i > 0) {
                request.setAttribute("msg", "✅ Registration successful! Login now.");
                RequestDispatcher rd = request.getRequestDispatcher("customerLogin.jsp");
                rd.forward(request, response);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
