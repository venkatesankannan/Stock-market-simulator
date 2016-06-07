package com.svm.databases;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdatePassword extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UpdatePassword() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	private boolean updateNewPassword(String password,String userName) {

		try {
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			Statement stmt = c.createStatement();
			String queryString = "update svm.\"Login\" set password='" + password + "' where username='" + userName + "';";
			int result = stmt.executeUpdate(queryString.toString());
			if (result != 0) {
				return true;
			}
			return false;

		} catch (Exception ex) {
			ex.printStackTrace();
			return false;
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");

		PrintWriter out = response.getWriter();
		
				if (password.equals(confirmPassword)) {
					boolean success = updateNewPassword(password,userName);
					if (success) {
						response.sendRedirect("/StockVirtualMachine/PasswordSuccess.jsp");
					} else {
						response.sendRedirect("/StockVirtualMachine/PasswordMismatch.jsp");
					}
				} 
			} 
		
	}

