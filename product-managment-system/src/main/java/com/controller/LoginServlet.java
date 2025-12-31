package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType"); // admin / customer

        Connection con = null;

        try {
            con = DBConnection.getConnection();

            if (con == null) {
                request.setAttribute("msg", "Database Connection Failed");
                request.getRequestDispatcher("customerLogin.jsp").forward(request, response);
                return;
            }

            String sql = "SELECT * FROM users WHERE email=? AND password=? AND role=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, loginType);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ Create session
                HttpSession session = request.getSession();
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("role", rs.getString("role"));

                // ✅ Toast message
                session.setAttribute("toast", "Login Successful");

                // ✅ Role based redirect
                if ("admin".equals(loginType)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    response.sendRedirect("customerDashboard.jsp");
                }

            } else {
                request.setAttribute("msg", "Invalid Email or Password");
                if ("admin".equals(loginType)) {
                    request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("customerLogin.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
