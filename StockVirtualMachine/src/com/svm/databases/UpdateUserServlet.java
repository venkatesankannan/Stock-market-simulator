package com.svm.databases;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UpdateUserServlet
 */
public class UpdateUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdateUserServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	private boolean updateUser(String firstName, String lastName, String email, String gender, String userName) {

		try {
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			Statement stmt = c.createStatement();
			StringBuilder queryString = new StringBuilder("update svm.\"Login\" set firstname='" + firstName + "', lastname='" + lastName + "', email='"
					+ email + "', gender='" + gender + "' where username='" + userName + "'");
			System.out.println("Query String: " + queryString);

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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String gender = request.getParameter("gender");
		String upload = request.getParameter("uploadpic");
		System.out.println("FirstName: " + firstName);
		System.out.println("LastName: " + lastName);
		System.out.println("Email: " + email);
		System.out.println("Gender: " + gender);
		System.out.println("Upload: " + upload);
		updateUser(firstName, lastName, email, gender, request.getSession().getAttribute("username").toString());
		response.sendRedirect("/StockVirtualMachine/UpdateSuccess.jsp");
	}

}
