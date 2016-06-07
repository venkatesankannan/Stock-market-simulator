<!DOCTYPE html PUBLIC>
<%@page import="java.net.URL"%>
<%@page import="org.w3c.dom.NodeList"%>
<%@page import="org.w3c.dom.Element"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="org.xml.sax.InputSource"%>
<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<html>
<head>
<script src="//code.jquery.com/jquery-1.9.1.js"></script>
<script
	src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
<link rel="stylesheet" href="css/main.css">

<script type="text/javascript">
	$(function() {

		// Setup for validation
		$("#BuyStock-form").validate({
			// Specify the validation rules
			rules : {
				StockSymbol : {
					required : true,
				},
				quantity : {
					required : true,
					number : true,
					digits : true,
				},
			},
			submitHandler : function(form) {
				form.submit();
			}
		});
	});
</script>


<script type="text/javascript">
	$(function() {

		// Setup for validation
		$("#BuyStock-form").validate({
			// Specify the validation rules
			rules : {
				Quantity : "required",
			},
			submitHandler : function(form) {
				form.submit();
			}
		});
	});
</script>
<title>Buy Stock Page</title>
</head>
<body background="images/Portfolio4.jpg">
	<%
		String userVirtualBal = "";
		String username = session.getAttribute("username").toString();
		try {
			Class.forName("org.postgresql.Driver");
			Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
			System.out.println("Opened Database successfully");
			Statement stmt = c.createStatement();
			ResultSet rs = stmt.executeQuery("select virtualamount from svm.\"Login\" where username='" + username + "';");
			if (rs.next()) {
				userVirtualBal = rs.getString(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	%>

	<div style="padding-top: 20px">
		<div style="float: left; padding-left: 15px">
			<a class="btn btn-primary" href="Portfolio.jsp"> <i
				class="fa fa-home"></i> Home
			</a>
		</div>
		<div style="float: right; padding-right: 15px">
			<a class="btn btn-success" href="Portfolio.jsp"> <i
				class="fa fa-pencil-square"></i> Back to Portfolio
			</a> <a class="btn btn-info" href="ProfilePage.jsp"> <i
				class="fa fa-pencil-square"></i> Edit Profile
			</a> <a class="btn btn-warning" href="/StockVirtualMachine/LogoutServlet">
				<i class="fa fa-sign-out"></i> Logout
			</a>
		</div>
		<div class="col-md-12">
			<form class="form-horizontal BuyStockDesign" role="form"
				action="/StockVirtualMachine/PurchaseStocks" method="post"
				id="BuyStock-form">
				<div>
					<div class="col-md-12">
						<h1>
							<b>Buy Stocks</b>
						</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<div class="form-group">
							<div class="col-md-12">
								<label><h4>
										<b>Virtual Account Balance: <i class="fa fa-usd"></i> <%=userVirtualBal%>
										</b> <br />
									</h4></label> <br /> <label><h4>

										<b>Select an Company: </b>
									</h4> </label> <select id="StockSymbol" name="StockSymbol">
									<%
										try {
											String userId = session.getAttribute("username").toString(); //Madan
											System.out.println("*** username: " + userId);
											Class.forName("org.postgresql.Driver");
											Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
											System.out.println("Opened Database successfully");
											Statement stmt = c.createStatement();
											String query = "select s.name,s.symbol from svm.\"StockData\" s";
											ResultSet rs = stmt.executeQuery(query);
											while (rs.next()) {
									%>
									<option value="<%=rs.getString(2)%>"><%=rs.getString(1)%></option>
									<%
										}
										} catch (Exception ex) {
											ex.printStackTrace();
										}
									%>
								</select><br> <label><h4>
										<b> Quantity: </b>
									</h4></label> <input type="text" id="quantity" name="quantity"
									placeholder=""> <br> <br> <input
									id="Purchase" type="submit" value="Purchase"
									class="btn btn-success">
							</div>
						</div>
					</div>

				</div>
			</form>
			<%
				String errorMsg = "";
				if (session.getAttribute("stockError") != null) {
					errorMsg = session.getAttribute("stockError").toString();
			%>
			<div align="center">
				<label style="color: red;"><font size="5"><%=errorMsg%></font></label>
			</div>
			<%
				}
			%>
		</div>
	</div>
</html>