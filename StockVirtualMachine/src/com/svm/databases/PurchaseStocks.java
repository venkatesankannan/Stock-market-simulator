package com.svm.databases;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * Servlet implementation class PurchaseStocks
 */
public class PurchaseStocks extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public PurchaseStocks() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	private String getTodayQuote(String symbol) {
		try {
			String url = "http://dev.markitondemand.com/Api/Quote?symbol=" + symbol;
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document dom = db.parse(new InputSource(new URL(url).openStream()));
			Element root = dom.getDocumentElement();
			NodeList quote = root.getElementsByTagName("Data");
			System.out.println("*** quote outside: " + quote.getLength());
			if (null != quote && quote.getLength() > 0) {

				System.out.println("*** quote: " + quote.getLength());

				Element data = (Element) quote.item(0);
				String lastVal = data.getFirstChild().getNodeName();
				Element item = (Element) quote.item(0).getChildNodes().item(3);
				String retValString = item.getTextContent();
				System.out.println("*** lastVal: " + item.getTextContent());

				return retValString;

			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return "";
		}
		return "";
	}

	private int checkIfStockExists(String username, String selectedStock) {
		int quantity = 0;
		try {
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			Statement stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery("select quantity from svm.\"UserStockData\" where userid='" + username + "' and stocksymbol='"
					+ selectedStock + "';");
			if (rs.next()) {
				quantity = Integer.parseInt(rs.getString(1));
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return quantity;
	}

	private void updateRecord(String username, String selectedStock, String quantity, String purchaseValue) {
		try {
			int existingQuantity = checkIfStockExists(username, selectedStock);
			System.out.println("*** Existing Quantity: " + existingQuantity);
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			Statement stmt = c.createStatement();
			String query = "";
			if (existingQuantity != 0) {
				int newQuantity = existingQuantity + Integer.parseInt(quantity);
				query = "update svm.\"UserStockData\" set quantity='" + (newQuantity + "") + "' where userid='" + username + "' and stocksymbol='"
						+ selectedStock + "';";
			} else {
				query = "insert into svm.\"UserStockData\" (userid, stocksymbol, quantity, costprice) values('" + username + "','" + selectedStock
						+ "','" + quantity + "','" + purchaseValue + "')";
			}

			System.out.println("Query String: " + query);

			int result = stmt.executeUpdate(query.toString());

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private String getUserAmount(String username) {
		Connection c = null;
		Statement stmt = null;
		ResultSet rs = null;
		String userVirtualBal = "";
		try {
			Class.forName("org.postgresql.Driver");
			c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			stmt = c.createStatement();
			rs = stmt.executeQuery("select virtualamount from svm.\"Login\" where username='" + username + "';");
			if (rs.next()) {
				userVirtualBal = rs.getString(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (null != c) {
				try {
					c.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}

			if (null != rs) {
				try {
					rs.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		}

		return userVirtualBal;

	}

	private int updateVirtualBalance(String username, String quantity, String purchaseValue) {
		Connection c = null;
		Statement stmt = null;
		try {
			int iQuantity = Integer.parseInt(quantity);
			double dPurchaseVal = Double.parseDouble(purchaseValue);
			double virtualAmount = iQuantity * dPurchaseVal;
			Class.forName("org.postgresql.Driver");
			c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			stmt = c.createStatement();
			String userAmount = getUserAmount(username);
			double dUserAmt = Double.parseDouble(userAmount);
			virtualAmount = dUserAmt - virtualAmount;
			Double truncatedDouble = new BigDecimal(virtualAmount).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
			virtualAmount = truncatedDouble.doubleValue();
			if (virtualAmount < 0) {
				return -1;
			} else {
				String query = "update svm.\"Login\" set virtualamount='" + virtualAmount + "' where username='" + username + "';";
				System.out.println("Query String: " + query);

				int result = stmt.executeUpdate(query.toString());
				return 0;
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			return -1;
		} finally {
			if (null != c) {
				try {
					c.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}

		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String selectedStock = request.getParameter("StockSymbol").toString();
		String quantity = request.getParameter("quantity").toString();
		String username = request.getSession().getAttribute("username").toString();

		String virtualAmount = getUserAmount(username);
		String purchaseValue = getTodayQuote(selectedStock);
		double dVirtualAmount = Double.parseDouble(virtualAmount);
		double dPurchaseValue = Double.parseDouble(purchaseValue);
		int iQuantity = Integer.parseInt(quantity);

		System.out.println("*** purchaseValue: " + purchaseValue);
		if (null != purchaseValue && purchaseValue.equalsIgnoreCase("")) {
			request.getSession().setAttribute("stockError", "No Stock Data Available for this stock. Choose another stock");
			response.sendRedirect("/StockVirtualMachine/BuyStock.jsp");
		}

		else {
			if (dVirtualAmount < (iQuantity * dPurchaseValue)) {
				request.getSession().setAttribute("stockError", "Insufficient account balance to purchase stocks.");
				response.sendRedirect("/StockVirtualMachine/BuyStock.jsp");
			} else {
				updateRecord(username, selectedStock, quantity, purchaseValue);

				try {
					int result = updateVirtualBalance(username, quantity, purchaseValue);
					response.sendRedirect("/StockVirtualMachine/Portfolio.jsp");
				} catch (Exception ex) {
					response.sendRedirect("/StockVirtualMachine/Error.jsp");
				}
			}
		}

	}

}
