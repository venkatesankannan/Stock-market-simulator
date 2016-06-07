<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>User Preferences</title>
<link href="css/main.css" rel="stylesheet" type="text/css">
</head>
<%
if(session.getAttribute("username") == null)
{
	RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
	dispatcher.forward(request, response);
}
%>
<body class="ProfilePage-Image">
	<div style="padding-top: 20px">
		<div style="float: left; padding-left: 15px">
			<a class="btn btn-primary" href="Portfolio.jsp"> <i
				class="fa fa-home"></i> Home
			</a>
		</div>
		<div style="float: right; padding-right: 15px">
			<a class="btn btn-success" href="Portfolio.jsp"> <i
				class="fa fa-long-arrow-left"></i>Back to Portfolio
			</a> <a class="btn btn-info" href="ProfilePage.jsp"> <i
				class="fa fa-pencil-square"></i> Edit Profile
			</a> <a class="btn btn-warning" href="/StockVirtualMachine/LogoutServlet">
				<i class="fa fa-sign-out"></i> Logout
			</a>


		</div>
	</div>

	<div class="container">
		<div class="col-md-12">
			<form class="form-horizontal FormDesign" role="form"
				action="/StockVirtualMachine/UpdatePrefServlet" method="get">
				<h4>
					<br>
					<left>Edit your preferences</left><br/><br/>
				</h4>
				<div class="row">
					<div class="BorderLine col-md-6">
						<div class="form-group">
							<div class="col-md-12">
								<h4>
									<left>Change Background Image</left>
								</h4>
								<a href="/StockVirtualMachine/UpdatePrefServlet?background=1">Portfolio
									Background Template 1</a><br /> <a
									href="/StockVirtualMachine/UpdatePrefServlet?background=2">Portfolio
									Background Template 2</a><br /> <a
									href="/StockVirtualMachine/UpdatePrefServlet?background=3">Portfolio
									Background Template 3</a><br /> <a
									href="/StockVirtualMachine/UpdatePrefServlet?background=4">Portfolio
									Background Template 4</a><br />
							</div>
						</div>
					</div>
					<form class="FormDesign" role="form"
						action="/StockVirtualMachine/UpdatePrefServlet" method="post">
						<div class="col-md-6" style="padding-left: 70px;">
							<div>
								<h4>
									<left>Edit Font Size:</left>
								</h4>
								<select name="font_size" style="color: black;">
									<option value="10">10px</option>
									<option value="12">12px</option>
									<option value="14">14px</option>
									<option value="16">16px</option>
									<option value="18">18px</option>
									<option value="20">20px</option>
								</select>
							</div>
							<div>
								<h4>
									<left>Edit Font Style:</left>
								</h4>
								<select name="font_style" style="color: black;">
									<option value="cursive">cursive</option>
									<option value="sans">sans-serif</option>
									<option value="monospace">monospace</option>
								</select>
							</div>
							<div class="form-group">
							<br/>
								<div class="col-md-5">
											<input type="submit" value="Apply"
												class="btn btn-warning btn-lg">
										</div>
							</div>
						</div>
					</form>
				</div>
			</form>
		</div>
	</div>
</body>
</html>