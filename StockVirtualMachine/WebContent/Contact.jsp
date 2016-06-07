<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/main.css">
<title>Contact Page</title>
</head>
<body class="Contact-Image">

	<div class="container">
		<div class="navbar navbar-default">
			<div class="navbar-center">
				<ul class="nav navbar-nav">
					<li><a href="Welcome.jsp"><i class="fa fa-home"></i> Home</a></li>
					<li><a href="Register.jsp"><i class="fa fa-key"></i>
							Sign Up</a></li>
					<li><a href="Login.jsp"><i class="fa fa-sign-in"></i>
							Login</a></li>
					<li><a href="Help.jsp"><i class="fa fa-question"></i> Help</a></li>
					<li class="active"><a href="Contact.jsp"><i
							class="fa fa-envelope-o"></i> Contact</a></li>
				</ul>
			</div>
		</div>
		<div class="col-md-12">
			<form class="form-horizontal FormDesign" role="form"
				action="/StockVirtualMachine/LoginServlet" method="post">
				<div>
					<div class="col-md-12">
						<h1>
							<b>Contact Us</b>
						</h1>
					</div>
				</div>
				<div class="row">
					<div class="BorderLine col-md-6">
						<div class="form-group">
							<div class="col-md-12">
								<label>

									<p>
										<h4><font color=#32cd32><b> University of Illinois at
												Chicago </b></font></h4>
									</p>

									<p>
										<font size="4"> Madan Gopal Venkatesan </font>
									</p>
									<p>
										<font size="4"> Sujay Patel</font>
									</p>
									<p>
										<font size="4"> Sujal Patel </font>
									</p>
									<p>
										<font size="4"> Venkatesan Kannan </font>
									</p>

								</label>

							</div>
						</div>

					</div>
					<div class="col-md-6">
						<label>
							<p>
							<h4>
								<font color=#32cd32><b> Group # 1 CS 440 </b></font>
							</h4>
							</p>
							<p>
								<font size="4"> mvenka7@uic.edu</font>
							</p>
							<p>
								<font size="4"> spate292@uic.edu </font>
							</p>
							<p>
								<font size="4"> spate290@uic.edu </font>
							</p>
							<p>
								<font size="4"> vkanna4@uic.edu </font>
							</p>

						</label>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>