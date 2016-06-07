<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Legend Page</title>
<link rel="stylesheet" href="css/main.css">
<style>
ul {
	list-style-type: square;
	list-style-position: outside;
	text-align: left;
	font-size: 18px
}

#navlist1 li {
	display: inline;
	font-size: 18px;
	list-style-type: none;
	padding: 0px 50px 0px
}

.center {
	margin-left: auto;
	margin-right: auto;
	width: 90%;
	background: #363636;
	opacity: 0.6;
}
</style>
</head>
<body class="LoginBackGround-Image2">
	<label class="margin-bottom-15"> <b><span
			style="color: Pink;"><font size="5"><center>LEGEND</center></font>
		</span></b> <br>
		<div id="navcontainer">
			<ul id="navlist1">
				<li><a href="Introduction.jsp" id="current">INTRODUCTION</a></li>
				<li id="active"><a href="Legend.jsp">LEGEND</a></li>
				<li><a href="Sitemap.jsp">SITEMAP</a></li>
			</ul>
		</div>
		<br>

		<div class="center">
			<ul>
				<li><font color="yellow">Leaderboard: Displays the leaders based on All-time,
					monthly and weekly basis. The leaderboard is accessible from the
					user’s portfolio.</font></li>
				<li><font color="yellow">Portfolio: This contains the user’s information. That
					includes the current stocks that they own, their current balance in
					their account, and provides access to other companies’
					information.</font></li>
				<li><font color="yellow">Stock market: is the aggregation of buyers and sellers (a
					loose network of economic transactions, not a physical facility or
					discrete entity) of stocks (shares); these are securities listed on
					a stock exchange as well as those only traded privately.</font></li>
				<li><font color="yellow">Stocks: It represents the residual assets of the company
					that would be due to stockholders after discharge of all senior
					claims such as secured and unsecured debt.</font></li>
				<li><font color="yellow">Selling Stocks: This is the exchange of stocks for money;
					it can be accessed from the Portfolio page</font></li>
				<li><font color="yellow">Virtual Bank Account: Online bank account, accessible from
					the user’s portfolio, which contains the current balance of the
					user</font></li>
			</ul>
		</div>
	</label>

</body>
</html>