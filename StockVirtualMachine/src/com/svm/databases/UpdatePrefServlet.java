package com.svm.databases;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UpdatePrefServlet
 */
@WebServlet("/UpdatePrefServlet")
public class UpdatePrefServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdatePrefServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String backgroundParam = request.getParameter("background");
		String fontSize = request.getParameter("font_size");
		String fontStyle = request.getParameter("font_style");
		if (backgroundParam != null) {
			int iBgParam = Integer.parseInt(backgroundParam);
			switch (iBgParam) {
			case 1:
				request.getSession().setAttribute("portfolio_background", "images/Portfolio1.jpg");
				break;
			case 2:
				request.getSession().setAttribute("portfolio_background", "images/Portfolio2.jpg");
				break;
			case 3:
				request.getSession().setAttribute("portfolio_background", "images/Portfolio3.jpg");
				break;
			case 4:
				request.getSession().setAttribute("portfolio_background", "images/Portfolio4.jpg");
				break;
			default:
				request.getSession().setAttribute("portfolio_background", "images/PortfolioBackGround.jpg");
				break;
			}
		} else {
			if ((fontSize != null) && (fontStyle != null)) {
				request.getSession().setAttribute("font_size", fontSize);
				request.getSession().setAttribute("font_style", fontStyle);
			}
		}

		response.sendRedirect("/StockVirtualMachine/Portfolio.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
