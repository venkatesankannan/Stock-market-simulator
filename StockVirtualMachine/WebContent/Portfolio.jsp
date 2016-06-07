<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.svm.utils.StockDataUtils"%>
<%@page import="com.svm.model.SymbolData"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.svm.webservices.StockDataFetcher"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC>
<html>
<head>
<style>
table {
	color: #000000;
	font-family: Helvetica, Arial, sans-serif;
}

th {
	background: linear-gradient(#333 0%, #444 100%);
	color: #A9F5F2;
	font-weight: bold;
	height: 40px;
	border: 8px solid black;
}
</style>
<style type="text/css">
.jqx-chart-axis-text, .jqx-chart-label-text, .jqx-chart-legend-text,
	.jqx-chart-axis-description, .jqx-chart-title-text,
	.jqx-chart-title-description {
	fill: #ffffff;
	color: #ffffff;
}

.jqx-chart-tooltip-text {
	color: #000000;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/main.css">
<script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="jqwidgets/jqxchart.core.js"></script>
<script type="text/javascript" src="jqwidgets/jqxdraw.js"></script>
<script type="text/javascript" src="jqwidgets/jqxdata.js"></script>
<link rel="stylesheet" href="jqwidgets/styles/jqx.darkblue.css"
	type="text/css" />
<title>Portfolio Page</title>

<%!
HashMap<String,String> weekData = new HashMap<String,String>();
HashMap<String,String> userPortfolios = new HashMap<String,String>();
ArrayList<String> userStockSymbols = new ArrayList<String>();
HashMap<String,SymbolData> completePortfolioData = new HashMap<String,SymbolData>();
String rssFeedString = "";
String userVirtualBal = "";
LinkedHashMap<String,Double> topPerformerList = new LinkedHashMap<String,Double>();
HashMap<String,String> stockQuanity = new HashMap<String,String>();


private ArrayList<String> getStockSymbolsForUser(String username)
{
ArrayList<String> symbols = new ArrayList<String>();
try {
	Class.forName("org.postgresql.Driver");
	Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
	System.out.println("Opened Database successfully");
	Statement stmt = c.createStatement();
	ResultSet rs = stmt.executeQuery("select * from svm.\"UserStockData\" where userid='" + username+ "';");
	int counter = 0;
	while (rs.next()) {
	symbols.add(rs.getString(2));
	stockQuanity.put(rs.getString(2), rs.getString(3));
	}
	}catch(Exception ex)
	{
	ex.printStackTrace();
	}
return symbols;
}

private void loadTopFivePerformers()
{
	topPerformerList = StockDataUtils.fetchTopFivePerformers();
	System.out.println("*** topPerformerList: " + topPerformerList);
	
}

private HashMap<String,String> getPortfolioForUser(String user)
{
	HashMap<String,String> folios = new HashMap<String,String>();
	// Do Database Connection
	ArrayList<String> symbols = getStockSymbolsForUser(user);
	if(symbols.isEmpty())
	{
		System.out.println("*** No STocks for the user");
		return new HashMap<String,String>();
	}
	rssFeedString = "";
	for(int i=0;i<symbols.size();i++)
	{
		rssFeedString += symbols.get(i) + ",";
StockDataFetcher fetcher = new StockDataFetcher();
System.out.println("*** symbols: " + symbols.get(i));
HashMap<String,String> retVal = fetcher.getStockDataForFiveYears(symbols.get(i));
Iterator it = retVal.entrySet().iterator();
String val = "";
while(it.hasNext())
{
	Map.Entry stockData = (Map.Entry)it.next();
	
	String[] stockValues = stockData.getValue().toString().split(",");
	
	SymbolData data = new SymbolData();
	data.setOpen(stockValues[0]);
	data.setHigh(stockValues[1]);
	data.setLow(stockValues[2]);
	data.setClose(stockValues[3]);
	data.setVolume(stockValues[4]);
	data.setAdjClose(stockValues[5]);
	
	val = val+stockValues[5]+",";
	completePortfolioData.put(symbols.get(i),data);
}
val = val.substring(0,val.length()-2);
System.out.println("*** Val: " + val);
folios.put(symbols.get(i), val);
	}
	rssFeedString = rssFeedString.substring(0,rssFeedString.length()-1);
	System.out.println("*** rssFeed: " + rssFeedString);
	// Use StockDataFetcher to get the db data
	
	return folios;
}

%>

<%
if(session.getAttribute("username") == null)
{
	RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
	dispatcher.forward(request, response);
}
String username = session.getAttribute("username").toString();
try {
	Class.forName("org.postgresql.Driver");
	Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
	System.out.println("Opened Database successfully");
	Statement stmt = c.createStatement();
	ResultSet rs = stmt.executeQuery("select virtualamount from svm.\"Login\" where username='" + username+ "';");
	if(rs.next())
	{
		userVirtualBal = rs.getString(1);
	}
	}catch(Exception ex)
	{
	ex.printStackTrace();
	}

%>

<%
	userPortfolios.clear();
	userStockSymbols.clear();
	loadTopFivePerformers();
	if(request.getSession().getAttribute("username") != null)
	{
	userPortfolios = getPortfolioForUser(request.getSession().getAttribute("username").toString());
	if(userPortfolios.isEmpty())
	{
		
	}
	else
	{
	Iterator it = userPortfolios.entrySet().iterator();
	Map.Entry pairs;
	int countX = 0;
	userStockSymbols.clear();
	while(it.hasNext())
	{
		if(countX < 5)
		{
		pairs = (Map.Entry)it.next();
		StringBuilder cookieVal = new StringBuilder();
		String[] store = pairs.getValue().toString().split(",");
		for(int i=0;i<7;i++)
		{
			cookieVal.append(store[i]).append(",");
		}
		 Cookie c = new Cookie(pairs.getKey().toString(),cookieVal.toString());
		response.addCookie(c); 
		/* System.out.println("Setting attribute: " + pairs.getKey().toString());
		System.out.println("Setting attribute Value: " + pairs.getValue().toString());
		request.setAttribute(pairs.getKey().toString(),"26.63,41.61,41.44,26.65,26.66,26.89,41.64,41.54,41.99,26.61,26.72,26.35,41.83,26.09,26.14,41.43,42.19,26.19,43.81,25.99,41.88,25"); */
		userStockSymbols.add(pairs.getKey().toString());
		countX++;
		}
	}
	int count = 0;
	/* while(it.hasNext())
	{
		if(count%15 == 0)
		{
		Map.Entry pairs = (Map.Entry)it.next();
		userStockSymbols.add(pairs.getKey().toString());
		
	Cookie c = new Cookie(pairs.getKey().toString(),pairs.getValue().toString());
	System.out.println("*** Resp Add Cookie");
	response.addCookie(c);
	count++;
		}
	} */
	/* Cookie c1 = new Cookie("AAPL", "30,20,40,50,30,0,0");
	Cookie c2 = new Cookie("YHOO", "100,30,50,30,20,0,0"); 
	response.addCookie(c1);
	response.addCookie(c2); */
	}
	}
	
	else
	{
		//response.sendRedirect("Login.jsp");
	}
	
%>

<script type="text/javascript">
	function populateThreeMonthsData(first, second, third, fourth) {
		var sampleData = [ {
			Day : '',
			Price : first
		}, {
			Day : '',
			Price : second
		}, {
			Day : '',
			Price : third
		}, {
			Day : '',
			Price : fourth
		} ];
		var settings = {
			title : "Company Performance",
			description : "Represent the company's performance as a chart",
			backgroundColor : 'transparent',
			showBorderLine : 'false',
			padding : {
				left : 5,
				top : 5,
				right : 5,
				bottom : 5
			},
			titlePadding : {
				left : 90,
				top : 0,
				right : 0,
				bottom : 10
			},
			source : sampleData,
			categoryAxis : {
				dataField : 'Day',
				showGridLines : false
			},
			colorScheme : 'scheme01',
			seriesGroups : [ {
				type : 'splinearea',
				columnsGapPercent : 30,
				seriesGapPercent : 0,
				valueAxis : {
					minValue : Math.min(first, second, third, fourth),
					maxValue : Math.max(first, second, third, fourth),
					unitInterval : 10,
					description : 'Price'
				},
				series : [ {
					dataField : 'Price',
					displayText : 'Period'
				},

				]
			} ]
		};

		// select the chartContainer DIV element and render the chart.
		$('#chartContainer').jqxChart(settings);
		$('#chartContainer').jqxChart('refresh');
	}

	function populateOneYearData(first, second, third, fourth, fifth) {
		var sampleData = [ {
			Day : '',
			Price : first
		}, {
			Day : '',
			Price : second
		}, {
			Day : '',
			Price : third
		}, {
			Day : '',
			Price : fourth
		}, {
			Day : '',
			Price : fifth
		} ];
		var settings = {
			title : "Company Performance",
			description : "Represent the company's performance as a chart",
			backgroundColor : 'transparent',
			padding : {
				left : 5,
				top : 5,
				right : 5,
				bottom : 5
			},
			titlePadding : {
				left : 90,
				top : 0,
				right : 0,
				bottom : 10
			},
			source : sampleData,
			categoryAxis : {
				dataField : 'Day',
				showGridLines : false
			},
			colorScheme : 'scheme01',
			seriesGroups : [ {
				type : 'splinearea',
				columnsGapPercent : 30,
				seriesGapPercent : 0,
				valueAxis : {
					minValue : Math.min(first, second, third, fourth),
					maxValue : Math.max(first, second, third, fourth),
					unitInterval : 10,
					description : 'Price'
				},
				series : [ {
					dataField : 'Price',
					displayText : 'Period'
				},

				]
			} ]
		};

		// select the chartContainer DIV element and render the chart.
		$('#chartContainer').jqxChart(settings);
	}
	
	function populateFiveYearData(first, second,third,fourth,fifth)
	{
		var sampleData = [ {
			Day : '',
			Price : first
		}, {
			Day : '',
			Price : second
		}, {
			Day : '',
			Price : third
		}, {
			Day : '',
			Price : fourth
		}, {
			Day : '',
			Price : fifth
		} ];
		var settings = {
			title : "Company Performance",
			description : "Represent the company's performance as a chart",
			backgroundColor : 'transparent',
			padding : {
				left : 5,
				top : 5,
				right : 5,
				bottom : 5
			},
			titlePadding : {
				left : 90,
				top : 0,
				right : 0,
				bottom : 10
			},
			source : sampleData,
			categoryAxis : {
				dataField : 'Day',
				showGridLines : false
			},
			colorScheme : 'scheme01',
			seriesGroups : [ {
				type : 'splinearea',
				columnsGapPercent : 30,
				seriesGapPercent : 0,
				valueAxis : {
					minValue : Math.min(first, second, third, fourth),
					maxValue : Math.max(first, second, third, fourth),
					unitInterval : 10,
					description : 'Price'
				},
				series : [ {
					dataField : 'Price',
					displayText : 'Period'
				},

				]
			} ]
		};

		// select the chartContainer DIV element and render the chart.
		$('#chartContainer').jqxChart(settings);
	}

	function populateSixMonthsData(first, second, third, fourth, fifth, sixth,
			seventh) {
		var sampleData = [ {
			Day : '',
			Price : first
		}, {
			Day : '',
			Price : second
		}, {
			Day : '',
			Price : third
		}, {
			Day : '',
			Price : fourth
		}, {
			Day : '',
			Price : fifth
		}, {
			Day : '',
			Price : sixth
		}, {
			Day : '',
			Price : seventh
		} ];
		var settings = {
			title : "Company Performance",
			description : "Represent the company's performance as a chart",
			backgroundColor : 'transparent',
			padding : {
				left : 5,
				top : 5,
				right : 5,
				bottom : 5
			},
			titlePadding : {
				left : 90,
				top : 0,
				right : 0,
				bottom : 10
			},
			source : sampleData,
			categoryAxis : {
				dataField : 'Day',
				showGridLines : false
			},
			colorScheme : 'scheme01',
			seriesGroups : [ {
				type : 'splinearea',
				columnsGapPercent : 30,
				seriesGapPercent : 0,
				valueAxis : {
					minValue : Math.min(first, second, third, fourth, fifth,
							sixth),
					maxValue : Math.max(first, second, third, fourth, fifth,
							sixth),
					unitInterval : 10,
					description : 'Price'
				},
				series : [ {
					dataField : 'Price',
					displayText : 'Period'
				},

				]
			} ]
		};

		// select the chartContainer DIV element and render the chart.
		$('#chartContainer').jqxChart(settings);
	}

	function populateMonthlyData(first, second, third, fourth) {
		var sampleData = [ {
			Day : '',
			Price : first
		}, {
			Day : '',
			Price : second
		}, {
			Day : '',
			Price : third
		}, {
			Day : '',
			Price : fourth
		} ];
		var settings = {
			title : "Company Performance",
			description : "Represent the company's performance as a chart",
			padding : {
				left : 5,
				top : 5,
				right : 5,
				bottom : 5
			},
			titlePadding : {
				left : 90,
				top : 0,
				right : 0,
				bottom : 10
			},
			source : sampleData,
			categoryAxis : {
				dataField : 'Day',
				showGridLines : false
			},
			colorScheme : 'scheme01',
			seriesGroups : [ {
				type : 'splinearea',
				columnsGapPercent : 30,
				seriesGapPercent : 0,
				valueAxis : {
					minValue : Math.min(first, second, third, fourth),
					maxValue : Math.max(first, second, third, fourth),
					unitInterval : 10,
					description : 'Price'
				},
				series : [ {
					dataField : 'Price',
					displayText : 'Period'
				},

				]
			} ]
		};

		// select the chartContainer DIV element and render the chart.
		$('#chartContainer').jqxChart(settings);
	}

	function populateWeeklyData(monday, tuesday, wednesday, thursday, friday,
			saturday, sunday) {
		var sampleData = [ {
			Day : '',
			Price : monday
		}, {
			Day : '',
			Price : tuesday
		}, {
			Day : '',
			Price : wednesday
		}, {
			Day : '',
			Price : thursday
		}, {
			Day : '',
			Price : friday
		}, {
			Day : '',
			Price : saturday
		}, {
			Day : '',
			Price : sunday
		} ];
		var settings = {
			title : "Company Performance",
			description : "Represent the company's performance as a chart",
			backgroundColor : 'transparent',
			padding : {
				left : 5,
				top : 5,
				right : 5,
				bottom : 5
			},
			titlePadding : {
				left : 90,
				top : 0,
				right : 0,
				bottom : 10
			},
			source : sampleData,
			categoryAxis : {
				dataField : 'Day',
				showGridLines : false
			},
			colorScheme : 'scheme01',
			seriesGroups : [ {
				type : 'splinearea',
				columnsGapPercent : 30,
				seriesGapPercent : 20,
				valueAxis : {
					minValue : Math.min(monday, tuesday, wednesday, thursday,
							friday, saturday, sunday),
					maxValue : Math.max(monday, tuesday, wednesday, thursday,
							friday, saturday, sunday),
					unitInterval : 10,
					description : 'Price'
				},
				series : [ {
					dataField : 'Price',
					displayText : 'Period'
				},

				]
			} ]

		};

		// select the chartContainer DIV element and render the chart.
		$('#chartContainer').jqxChart(settings);
	}

	function refreshOneMonth(event) {

		
		var c = document.cookie.split(";");
		for (var i = 0; i < c.length; i++) {
			var val = c[i];
			var stockSymbol = document.getElementById("stocksymbol");

			if(stocksymbol.value == '')
			{
			return;
			}
			if (val.indexOf(stockSymbol.value) != -1) {
				var graphData = val.substring(event.target.id.length + 3,
						val.length - 1).split(",");

				//alert("Graph Data: " + graphData[0]);
				populateMonthlyData(graphData[0], graphData[1], graphData[2],
						graphData[3]);
			}
		}
	}

	function refreshOneYear(event) {

		var c = document.cookie.split(";");
		for (var i = 0; i < c.length; i++) {
			var val = c[i];
			var stockSymbol = document.getElementById("stocksymbol");

			if(stocksymbol.value == '')
			{
			return;
			}
			if (val.indexOf(stockSymbol.value) != -1) {
				var graphData = val.substring(stockSymbol.value.length + 3,
						val.length - 1).split(",");
				//alert("Graph Data: " + graphData[0]);
				populateOneYearData(graphData[0], graphData[1],
						graphData[2], graphData[3], graphData[4]);
			}
		}
	}
	
	function refreshFiveYears(event)
	{
		var c = document.cookie.split(";");
		for (var i = 0; i < c.length; i++) {
			var val = c[i];
			var stockSymbol = document.getElementById("stocksymbol");
			if(stocksymbol.value == '')
			{
			return;
			}
			if (val.indexOf(stockSymbol.value) != -1) {
				var graphData = val.substring(stockSymbol.value.length + 3,
						val.length - 1).split(",");
				//alert("Graph Data: " + graphData[0]);
				populateFiveYearData(graphData[1], graphData[2],
						graphData[3], graphData[4], graphData[5]);
			}
		}
		
	}

	function refreshThreeMonths(event) {

		var c = document.cookie.split(";");
		for (var i = 0; i < c.length; i++) {
			var val = c[i];
			var stockSymbol = document.getElementById("stocksymbol");
			if(stocksymbol.value == '')
			{
			return;
			}
			if (val.indexOf(stockSymbol.value) != -1) {
				var graphData = val.substring(event.target.id.length + 3,
						val.length - 1).split(",");
				//alert("Graph Data: " + graphData[0]);
				populateThreeMonthsData(graphData[0], graphData[2],
						graphData[4], graphData[6]);
			}
		}
	}

	function refreshSixMonths(event) {
		var c = document.cookie.split(";");
		for (var i = 0; i < c.length; i++) {
			var val = c[i];
			var stockSymbol = document.getElementById("stocksymbol");
			if(stocksymbol.value == '')
			{
			return;
			}
			if (val.indexOf(stockSymbol.value) != -1) {
				var graphData = val.substring(event.target.id.length + 3,
						val.length - 1).split(",");
				//alert("Graph Data: " + graphData[0]);
				populateSixMonthsData(graphData[0], graphData[1],
						graphData[2], graphData[3], graphData[4],
						graphData[5], graphData[6]);
			}
		}
	}

	function refreshOneWeek(event) {
		var c = document.cookie.split(";");
		for (var i = 0; i < c.length; i++) {

			var val = c[i];
			var stockSymbol = document.getElementById("stocksymbol");
			if(stocksymbol.value == '')
				{
				return;
				}
			if (val.indexOf(stockSymbol.value) != -1) {
				var graphData = val.substring(event.target.id.length + 3,
						val.length - 1).split(",");
				//alert("Graph Data: " + graphData[0]);
				populateWeeklyData(graphData[0], graphData[1], graphData[2],
						graphData[3], graphData[4], graphData[5], graphData[6]);
				break;
			}
		}
	}

	function refreshGraph(event) {
		var c = document.cookie.split(";");
		for (var i = 0; i < c.length; i++) {

			var val = c[i];
			if (val.indexOf(event.target.id) != -1) {
				var graphData = val.substring(event.target.id.length + 3,
						val.length - 1).split(",");
				//alert("Graph Data: " + graphData[0]);
				populateWeeklyData(graphData[0], graphData[1], graphData[2],
						graphData[3], graphData[4], graphData[5], graphData[6]);
				break;
			}
		}
		document.getElementById("stocksymbol").value = event.target.id;
	}
</script>

<script type="text/javascript" async="true"
	src="http://www.google-analytics.com/ga.js"></script>
<script type="text/javascript">
	var _gaq = _gaq || [];
	_gaq.push([ '_setAccount', 'UA-29467710-1' ]);
	_gaq.push([ '_trackPageview' ]);

	(function() {
		var ga = document.createElement('script');
		ga.type = 'text/javascript';
		ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl'
				: 'http://www')
				+ '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0];
		s.parentNode.insertBefore(ga, s);
	})();
</script>



</head>
<body
	<%
if(null != session.getAttribute("stockError"))
{
	session.removeAttribute("stockError");
}
%>
	background="<%=(null != 
session.getAttribute("portfolio_background")?session.getAttribute("portfolio_background"):"images/PortfolioBackGround.jpg") %>">
	<input type="hidden" id="stocksymbol" />


	<div style="padding-top: 20px">
		<div style="float: left; padding-left: 15px">
			<a class="btn btn-primary" href="Portfolio.jsp"> <i
				class="fa fa-home"></i> Home
			</a>
		</div>
		<div style="float: right; padding-right: 15px">
			<a class="btn btn-success" href="UserPreferences.jsp"> <i
				class="fa fa-pencil-square"></i> User Preferences
			</a> <a class="btn btn-info" href="ProfilePage.jsp"> <i
				class="fa fa-pencil-square"></i> Edit Profile
			</a> <a class="btn btn-warning" href="/StockVirtualMachine/LogoutServlet">
				<i class="fa fa-sign-out"></i> Logout
			</a>
		</div>
	</div>

	<div class="container">
		<div class="col-md-12">
			<form class="form-horizontal PortfolioDesign" method="post">
				<div class="row">
					<div class="BorderLine col-md-6">
						<%
System.out.println("*** Font Style: " + session.getAttribute("font_style"));
System.out.println("*** Font Style: " + session.getAttribute("font_size"));
%>
						<div class="col-md-12">
							<label for="username"><h2>
									<i class="fa fa-user"></i><b
										style="font-family: <%=(null != session.getAttribute("font_style")?session.getAttribute("font_style"):"sans-serif")%>; font-size: <%=(null != session.getAttribute("font_size")?session.getAttribute("font_size"):"18")%>;">
										<%=session.getAttribute("username")%>
									</b>
								</h2></label>
						</div>
						<div class="col-md-12">
							<label for="username"><h4>
									<b
										style="font-family: <%=session.getAttribute("font_style")%>; font-size: <%=session.getAttribute("font_size")%>;">Virtual
										Account Balance: <i class="fa fa-usd"></i> <%=userVirtualBal %>
									</b>
								</h4></label>
						</div>
						<div class="col-md-12">
							<TABLE class="table table-bordered table-striped">
								<TR>
									<TH COLSPAN="5" style="text-shadow: black;">List of Owned
										Stocks</TH>
								</TR>

								<TR style="background-color: black; color: white;">
									<TH align="center">Symbol</TH>

									<TH align="center">High</TH>
									<TH align="center">Low
									<TH align="center">Close</TH>
									<TH align="center">Quantity</TH>
								</TR>
								<%
									Iterator it1 = userPortfolios.entrySet().iterator();
															System.out.println("*** Before While : " + userStockSymbols);
															for (int i = 0; i < userStockSymbols.size(); i++) {
																out.println("<tr align=\"center\"><td style=\"background-color: #B8B8E6;\"><a href=\"#\" style=\"color:white;\" id="
																		+ userStockSymbols.get(i) + " onclick=refreshGraph(event)>" + userStockSymbols.get(i) + "</a></td>");
										SymbolData data = completePortfolioData.get(userStockSymbols.get(i));
										out.println("<td style = \"background-color: #B8B8E6;\">" + "<font color=\"white\">" + data.getHigh() + "</font></td>");
										out.println("<td style = \"background-color: #B8B8E6;\">" + "<font color=\"white\">" + data.getLow() + "</font></td>");
										out.println("<td style = \"background-color: #B8B8E6;\">" + "<font color=\"white\">" + data.getClose() + "</font></td>");
										out.println("<td style = \"background-color: #B8B8E6;\">" + "<font color=\"white\">" + stockQuanity.get(userStockSymbols.get(i)) + "</font></td>");
										out.println("</tr>");
									}
								%>
								<!-- <TR ALIGN="CENTER">
									<TD><h6>AAP</h6></TD>
									<TD><h6>Advance Auto Parts Inc</h6></TD>
									<TD><h6>119.60</h6></TD>
									<TD><h6>117.80</h6></TD>
									<TD><h6>119.40</h6></TD>
								</TR>
								<TR ALIGN="CENTER">
									<TD><h6>AAT</h6></TD>
									<TD><h6>American Assets Trust</h6></TD>
									<TD><h6>119.60</h6></TD>
									<TD><h6>117.80</h6></TD>
									<TD><h6>119.40</h6></TD>
								</TR> -->
							</TABLE>
							<div class="col-md-12">
								<br> &nbsp;&nbsp;&nbsp;<a class="btn btn-success"
									href="BuyStock.jsp"> <i class="fa fa-plus"></i> Buy Stocks
								</a> &nbsp;&nbsp;&nbsp;<a class="btn btn-danger"
									href="SellStock.jsp"> <i class="fa fa-minus"></i> Sell
									Stocks
								</a> &nbsp;&nbsp;&nbsp;<a class="btn btn-primary" href="Search.jsp">
									<i class="fa fa-search"></i> Search
								</a>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div align="right" style="padding-top: 50px">
							<a href="#" id="Test" onclick=refreshOneWeek(event)>One Week</a>&nbsp;&nbsp;&nbsp;
							<a href="#" id="Test1" onclick=refreshOneMonth(event)>One
								Month</a>&nbsp;&nbsp;&nbsp; <a href="#" id="Test1"
								onclick=refreshThreeMonths(event)>Three Months</a>&nbsp;&nbsp;&nbsp;
							<a href="#" id="Test1" onclick=refreshSixMonths(event)>Six
								Months</a>&nbsp;&nbsp;&nbsp; <a href="#" id="Test1"
								onclick=refreshOneYear(event)>One Year</a>&nbsp;&nbsp;&nbsp; <a
								href="#" id="Test1" onclick=refreshFiveYears(event)>Five
								Years</a>&nbsp;&nbsp;&nbsp;
							<div id='chartContainer'
								style="width: 450px; height: 300px; padding-top: 20px"></div>
						</div>
					</div>
				</div>
			</form>
			<form class="form-horizontal PortfolioRightSideDesign" method="post">
				<div class="row">
					<div class="col-md-6">
						<div align="right">
							<!-- start sw-rss-feed code -->
							<script type="text/javascript"> 
<!-- 
rssfeed_url = new Array(); 
rssfeed_url[0]="http://finance.yahoo.com/rss/industry?s=<%=rssFeedString%>";  
rssfeed_frame_width="350"; 
rssfeed_frame_height="700"; 
rssfeed_scroll="on"; 
rssfeed_scroll_step="6"; 
rssfeed_scroll_bar="off"; 
rssfeed_target="_blank"; 
rssfeed_font_size="12"; 
rssfeed_font_face=""; 
rssfeed_border="on"; 
rssfeed_css_url=""; 
rssfeed_title="on"; 
rssfeed_title_name=""; 
rssfeed_title_bgcolor="#3366ff"; 
rssfeed_title_color="#fff"; 
rssfeed_title_bgimage="http://"; 
rssfeed_footer="off"; 
rssfeed_footer_name="rss feed"; 
rssfeed_footer_bgcolor="#fff"; 
rssfeed_footer_color="#333"; 
rssfeed_footer_bgimage="http://"; 
rssfeed_item_title_length="50"; 
rssfeed_item_title_color="#fff"; 
rssfeed_item_bgcolor="#000"; 
rssfeed_item_bgimage="http://"; 
rssfeed_item_border_bottom="on"; 
rssfeed_item_source_icon="on";
rssfeed_item_date="off"; 
rssfeed_item_description="on"; 
rssfeed_item_description_length="120"; 
rssfeed_item_description_color="#fff"; 
rssfeed_item_description_link_color="#333"; 
rssfeed_item_description_tag="off"; 
rssfeed_no_items="0"; 
rssfeed_cache = "<%=new java.util.Random()%>"; 
//--> 

						
						</script>
							<script type="text/javascript"
								src="http://feed.surfing-waves.com/js/rss-feed.js"></script>
							<!-- The link below helps keep this service FREE, and helps other people find the SW widget. Please be cool and keep it! Thanks. -->
						</div>
					</div>
				</div>
			</form>
			<form class="form-horizontal LeaderBoardDesign" method="post">
				<div align="LEFT">
					<table class="table table-bordered table-hover">
						<TR>
							<TH COLSPAN="5" style="text-shadow: black;">Leaderboard: Top
								5 Players</TH>
						</TR>
						<tr style="background-color: black; color: white;">
							<th>Rank</th>
							<th>Player's Username</th>
							<th>Total Balance</th>
							<th>Profit</th>
						</tr>
						<%
							HashMap<String, String> userBalance = new HashMap<String, String>();
							try {
								Class.forName("org.postgresql.Driver");
								Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
								System.out.println("Opened Database successfully");
								Statement stmt = c.createStatement();
								ResultSet rs = stmt.executeQuery("select username,virtualamount from svm.\"Login\";");
								while (rs.next()) {
									userBalance.put(rs.getString(1), rs.getString(2));
								}
							} catch (Exception ex) {
								ex.printStackTrace();
							}
							int counter = 1;
							for (Map.Entry<String, Double> entry : topPerformerList.entrySet()) {
						%>
						<tr style="background-color: #B8B8E6;" align="center">
							<td><%=counter%></td>
							<td><%=entry.getKey()%></td>
							<td>$ <%=userBalance.get(entry.getKey())%></td>
							<td>$ <%=entry.getValue()%></td>
						</tr>
						<%
							counter++;
							}
						%>
					</table>
				</div>
			</form>
		</div>
	</div>
</body>
</html>