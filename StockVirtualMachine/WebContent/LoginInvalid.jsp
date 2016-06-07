<!DOCTYPE html>
<head>
<title>Login Page</title>

<link href="css/main.css" rel="stylesheet" type="text/css">
</head>
<body class="LoginBackGround-Image">
	<div class="container">
		<div class="navbar navbar-default">
			<div class="navbar-center">
				<ul class="nav navbar-nav">
					<li><a href="Welcome.jsp"><i class="fa fa-home"></i> Home</a></li>
					<li><a href="Register.jsp"><i class="fa fa-key"></i>
							Register</a></li>
					<li class="active"><a href="Login.jsp"><i
							class="fa fa-sign-in"></i> Login</a></li>
					<li><a href="Help.jsp"><i class="fa fa-question"></i> Help</a></li>
					<li><a href="Contact.jsp"><i class="fa fa-envelope-o"></i>
							Contact</a></li>
				</ul>
			</div>
		</div>
		<h1><font color="red">Invalid User Credentials. Try again!</font></h1>
		<div class="col-md-12">
			<form class="form-horizontal FormDesign" role="form"
				action="/StockVirtualMachine/LoginServlet" method="post">
				<div>
					<div class="col-md-12">
						<h1>
							<b>Login To Stock Virtual Machine</b>
						</h1>
					</div>
				</div>
				<div class="row">
					<div class="BorderLine col-md-6">
						<div class="form-group">
							<div class="col-md-12">
								<label for="username" class="control-label">USERNAME</label>
								<div class="Input_Icons">
									<i class="fa fa-user"></i> <input type="text"
										class="form-control" id="username" name="username"
										placeholder="">
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="col-md-12">
								<label for="password" class="control-label">PASSWORD</label>
								<div class="Input_Icons">
									<i class="fa fa-lock"></i> <input type="password"
										name="password" class="form-control" id="password"
										placeholder="">
								</div>
							</div>
						</div>

						<div class="form-group">
							<div class="col-md-12">
								<input type="submit" value="LOG IN" class="btn btn-warning">
							</div>
						</div>
						<div class="form-group">
							<div class="col-md-12">
								<a href="forgot-password.html" class="text-center">Forget
									Username/Password?</a>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<label>
							<h4>
								<b><span style="color: Pink;"> WELCOME </span></b>
							</h4>
							<p>
								<font size="3"> Stock Virtual Machine is simply designed
									to simulate buying and selling stocks in the stock market in a
									very realistic manner.</font>
							</p>
							<p>
								<font size="3">To use the program users <b>must</b>
									register with a Username, Email and Password.
								</font>
							</p>
						</label>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>