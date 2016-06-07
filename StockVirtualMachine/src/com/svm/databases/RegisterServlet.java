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

public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public RegisterServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	private boolean termsCheck(String termsAgree) {
		return true;
	}

	private boolean isUserExists(String userName) {
		try {
			int counter = 0;
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			Statement stmt = c.createStatement();
			String query = "select * from svm.\"Login\" where username='" + userName + "'";
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				counter++;
			}
			if (counter == 0) {
				return false;
			}
			return true;

		} catch (Exception ex) {
			ex.printStackTrace();
			return false;
		}
	}

	private boolean createNewUser(String firstName, String lastName, String email, String userName, String password, String gender, String secret, String answer) {

		try {
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			Statement stmt = c.createStatement();
			StringBuilder queryString = new StringBuilder("insert into svm.\"Login\" (username,password,firstname,lastname,email,gender,virtualamount, secret,answer) values ('"
					+ userName + "','" + password + "','" + firstName + "','" + lastName + "','" + email + "','" + gender + "'," + 1000 + ",'"+ secret +"','"+ answer +"')");
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

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String secret = request.getParameter("secret");
		String answer = request.getParameter("answer");
		String gender = request.getParameter("gender");
		String termsAgree = request.getParameter("terms");
		System.out.println("*** In Register Servlet. Terms: " + termsAgree);

		PrintWriter out = response.getWriter();
		if (termsCheck(termsAgree)) {
			if (!isUserExists(userName)) {
				if (password.equals(confirmPassword)) {
					boolean success = createNewUser(firstName, lastName, email, userName, password, gender, secret, answer);
					if (success) {
						request.getSession().setAttribute("username", userName);
					   request.getSession().setAttribute("password", password);
						request.getSession().removeAttribute("reg_error");
						request.getSession().setAttribute("portfolio_background", "images/PortfolioBackGround.jpg");
						request.getSession().setAttribute("font_size", "18");
						request.getSession().setAttribute("font_style", "sans-serif");
						response.sendRedirect("/StockVirtualMachine/Portfolio.jsp");
					} else {

						request.getSession().setAttribute("reg_error", "0");
						response.sendRedirect("/StockVirtualMachine/Register.jsp");
						//out.println("<html> <body> Something went wrong while creating a user </body></html>");
					}
				} else {
					request.getSession().setAttribute("reg_error", "1");
					response.sendRedirect("/StockVirtualMachine/Register.jsp");
					//out.println("<html> <body> Password Mismatch </body></html>");
				}
			} else {
				request.getSession().setAttribute("reg_error", "2");
				response.sendRedirect("/StockVirtualMachine/Register.jsp");
			}
		}
	}

}
