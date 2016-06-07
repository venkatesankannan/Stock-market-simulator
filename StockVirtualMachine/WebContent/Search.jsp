<html>
<head>
<title>Markit On Demand Stock Quote API Demo</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/demo.css">
<style>
th {
	color: silver;
	text-shadow: aqua;
}
</style>
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
<%
if(session.getAttribute("username") == null)
{
	RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
	dispatcher.forward(request, response);
}
%>
<body background="images/Search.jpg">

	<div style="padding-top: 20px">
		<div style="float: left; padding-left: 15px">
			<a class="btn btn-primary" href="Portfolio.jsp"> <i
				class="fa fa-home"></i> Home
			</a>
		</div>
		<div style="float: right; padding-right: 15px">
			<a class="btn btn-info" href="ProfilePage.jsp"> <i
				class="fa fa-pencil-square"></i> Edit Profile
			</a> <a class="btn btn-warning" href="/StockVirtualMachine/LogoutServlet">
				<i class="fa fa-sign-out"></i> Logout
			</a>
		</div>
	</div>

	<div class="container web" style="padding-top: 100px">
		<div class="row"></div>
		<div class="row content">
			<div class="span12" align="center">
				<form class="well control-group form-inline">
					<label>Enter the Stock Symbol&nbsp;&nbsp; </label> <input
						type="text" id="symbol" class="input-" placeholder="Enter symbol">
					<button type="submit" class="btn btn-primary"
						data-loading-text="Loading quote data...">Get Quote</button>
				</form>
			</div>
		</div>
	</div>

	<div align="right" style="padding-right: 30px">
		<a class="btn btn-success" href="Portfolio.jsp"> <i
			class="fa fa-long-arrow-left"></i>Back to Portfolio
		</a>
	</div>

	<script>
		!function(d, s, id) {
			var js, fjs = d.getElementsByTagName(s)[0];
			if (!d.getElementById(id)) {
				js = d.createElement(s);
				js.id = id;
				js.src = "//platform.twitter.com/widgets.js";
				fjs.parentNode.insertBefore(js, fjs);
			}
		}(document, "script", "twitter-wjs");
	</script>
	<script type="text/javascript"
		src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script type="text/javascript"
		src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="scripts/QuoteService.js"></script>
	<script type="text/javascript">
		$(function() {

			$("button").button();
			$("#symbol").focus();

			//form submit event
			$("form").submit(function(e) {

				e.preventDefault();

				$("button").button("loading");
				var ticker = $("#symbol").val();
				new Markit.QuoteService(ticker, function(jsonResult) {
					this.clearResult();
					//Catch errors
					if (!jsonResult || jsonResult.Message) {
						this.renderAlert(jsonResult);
						return;
					}
					this.success(jsonResult);
				});
			});
		});

		//prototype some methods onto our Quote Service
		Markit.QuoteService.prototype.clearResult = function() {
			this.resetForm();
			$("#resultContainer").remove();
			$("div.alert").remove();
		};

		Markit.QuoteService.prototype.resetForm = function() {
			$("button").button("reset");
			$("form").removeClass("error");
			$("#symbol").val($("#symbol").val().toUpperCase()).select().focus();
		};

		Markit.QuoteService.prototype.success = function(jsonResult) {
			var $container = $("<div class='hide' id='resultContainer' style=\"padding-top: 20px\" />");
			$container.append("<h4 style=\"color: #ffffff;\">"
					+ jsonResult.Name + " (" + jsonResult.Symbol + ")</h4>");
			$container.append(this.renderResultTable(jsonResult));

			$("form").after($container);
			$container.fadeIn('fast');
			this.resetForm();
		};

		Markit.QuoteService.prototype.renderAlert = function(jsonResult) {
			$("form").addClass("error");
			$("form")
					.before(
							"<div class='alert alert-error'><a class='close' data-dismiss='alert'>&times;</a>"
									+ jsonResult.Message + "</div>");
			$("div.alert").alert();
		};

		Markit.QuoteService.prototype.renderResultTable = function(jsonResult) {
			var $table = $("<table />"), $thead = $("<thead />"), $tbody = $("<tbody />"), tableHeadCells = [];
			tableCells = [];

			tableHeadCells.push("<tr>");
			tableHeadCells.push("<th>Last Price</th>");
			tableHeadCells.push("<th>Change</th>");
			tableHeadCells.push("<th>Change Percent</th>");
			tableHeadCells.push("<th>Change Percent YTD</th>");
			tableHeadCells.push("<th>Last Traded</th>");
			tableHeadCells.push("</tr>");

			tableCells.push("<tr>");
			tableCells.push("<td>$", jsonResult.LastPrice, "</td>");
			tableCells.push("<td>", this.formatChgPct(jsonResult.Change),
					"</td>");
			tableCells.push("<td>",
					this.formatChgPct(jsonResult.ChangePercent), "%</td>");
			tableCells.push("<td>", jsonResult.ChangePercentYTD.toFixed(2),
					"%</td>");
			tableCells.push("<td>", jsonResult.Timestamp, "</td>");
			tableCells.push("</tr>");

			$table.addClass("table table-bordered table-striped");
			$thead.append(tableHeadCells.join(""));
			$tbody.append(tableCells.join(""));

			$table.append($thead).append($tbody);

			return $table;
		};

		Markit.QuoteService.prototype.formatChgPct = function(chg) {
			//the quote API returns negative numbers already,
			//so we just need to add the + sign to positive numbers
			return (chg <= 0) ? chg.toFixed(2) : "+" + chg.toFixed(2);
		};
	</script>
	
	<!-- Reference site for getting the market data web service is http://dev.markitondemand.com/ -->
</body>
</html>