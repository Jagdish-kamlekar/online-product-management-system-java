package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		HttpSession session = req.getSession(false);
		if (session == null || !"admin".equals(session.getAttribute("role"))) {
			res.sendRedirect("adminLogin.jsp");
			return;
		}

		int id = Integer.parseInt(req.getParameter("id"));

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement ps = con.prepareStatement("DELETE FROM product WHERE id=?");
			ps.setInt(1, id);
			ps.executeUpdate();

			res.sendRedirect("viewProducts.jsp");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
