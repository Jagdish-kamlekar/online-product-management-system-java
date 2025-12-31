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

@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		String email = (String) session.getAttribute("email");

		if (email == null) {
			response.sendRedirect("index.jsp");
			return;
		}

		int orderId = Integer.parseInt(request.getParameter("orderId"));

		try (Connection con = DBConnection.getConnection()) {
			con.setAutoCommit(false);

			PreparedStatement check = con.prepareStatement(
				"SELECT status FROM orders WHERE order_id=? AND user_email=?"
			);
			check.setInt(1, orderId);
			check.setString(2, email);
			ResultSet crs = check.executeQuery();

			if (crs.next() && !"PLACED".equals(crs.getString("status"))) {
				session.setAttribute("success", "Order cannot be cancelled now");
				response.sendRedirect("myOrders.jsp");
				return;
			}

			PreparedStatement ps = con.prepareStatement(
				"UPDATE orders SET status='CANCELLED' WHERE order_id=?"
			);
			ps.setInt(1, orderId);
			ps.executeUpdate();

			con.commit();
			session.setAttribute("success", "Order cancelled ❌");
			response.sendRedirect("myOrders.jsp");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
