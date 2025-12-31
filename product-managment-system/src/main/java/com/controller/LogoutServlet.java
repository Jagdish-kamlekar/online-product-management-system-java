package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Get session (false = do not create new)
        HttpSession session = request.getSession(false);

        // 2️⃣ Destroy session if exists
        if (session != null) {
            session.invalidate();
        }

        // 3️⃣ Redirect to HOME page (index.jsp)
        response.sendRedirect("index.jsp");
    }
}
