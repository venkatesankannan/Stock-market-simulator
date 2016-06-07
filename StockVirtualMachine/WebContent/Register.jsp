<!DOCTYPE html>
<head>
<title>Registration Page</title>

<script src="//code.jquery.com/jquery-1.9.1.js"></script>
<script
	src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
<link href="css/main.css" rel="stylesheet" type="text/css">

<!-- jQuery Form Validation code -->
<script>
	
<%!String errorString = "";%>
	$(function() {

		// Setup for validation
		$("#register-form")
				.validate(
						{

							// Specify the validation rules
							rules : {
								firstName : "required",
								lastName : "required",
								email : {
									required : true,
									email : true
								},
								password : {
									required : true,
									minlength : 5
								},
								confirmPassword : {
									required : true,
									minlength : 5
								},
								userName : {
									required : true,
								},
								terms : "required",
								gender : "required",
							},

							// Specify the validation error messages
							messages : {
								firstname : "Please enter your first name",
								lastname : "Please enter your last name",
								password : {
									required : "Please provide a password",
									minlength : "Your password must be at least 5 characters long"
								},
								confirmPassword : {
									required : "Please provide a Confirm password",
									minlength : "Your password must be at least 5 characters long"
								},
								userName : {
									required : "Please enter a User Name",
								},
								email : "Please enter a valid email address",
								terms : "Please accept our policy"
							},

							submitHandler : function(form) {
								form.submit();
							}
						});
	});
</script>
</head>
<body class="Register-Image">
	<%
		if (session.getAttribute("username") != null) {
			response.sendRedirect("Portfolio.jsp");
		}
	%>
	<div class="container">
		<div class="navbar navbar-default" role="navigation">
			<div class="navbar-center">
				<ul class="nav navbar-nav">
					<li><a href="Welcome.jsp"><i class="fa fa-home"></i> Home</a></li>
					<li class="active"><a href="Register.jsp"><i
							class="fa fa-key"></i> Sign up</a></li>
					<li><a href="Login.jsp"><i class="fa fa-sign-in"></i>
							Login</a></li>
					<li><a href="Help.jsp"><i class="fa fa-question"></i> Help</a></li>
					<li><a href="Contact.jsp"><i class="fa fa-envelope-o"></i>
							Contact Us</a></li>
				</ul>
			</div>
		</div>
		<div class="col-md-12">
			<form class="form-horizontal FormDesign" role="form"
				action="" method="post"
				id="register-form">
				<div class="row">
					<div class="col-md-12">
						<h1>Create Account</h1>
						<%
							Object errorCode = session.getAttribute("reg_error");
							if (errorCode != null) {
								String sErrorCode = errorCode.toString();
								int iError = Integer.parseInt(sErrorCode);
								switch (iError) {
								case 0:
									errorString = "Something went wrong. Please try again.";
									break;
								case 1:
									errorString = "Password Mismatch. Check again";
									break;
								case 2:
									errorString = "Username already exists. Please choose another one";
									break;

								}
							}
						%>
						<h3 style="color: red;"><%=errorString%></h1>
							<div class="container">
								<div class="col-md-12">
									<form class="FormDesign" role="form"
										action="" method="post">
										<div>
											<div class="form-group">
												<div class="col-md-3">
													<label for="first_name" class="control-label">First
														Name</label> <input type="text" class="form-control"
														id="first_name" name="firstName" placeholder="">
												</div>
												<div class="col-md-3">
													<label for="last_name" class="control-label">Last
														Name</label> <input type="text" class="form-control"
														id="last_name" name="lastName" placeholder="">
												</div>
											</div>
											<div class="form-group">
												<div class="col-md-6">
													<label for="username" class="control-label">Email</label> <input
														type="email" class="form-control" id="email" name="email"
														placeholder="">
												</div>
											</div>
											<div class="form-group">
												<div class="col-md-3">
													<label for="username" class="control-label">Username</label>
													<input type="text" class="form-control" id="username"
														name="userName" placeholder="">
												</div>
												<br />
												<div class="col-md-3 templatemo-radio-group">
													<label class="radio-inline"> <input type="radio"
														name="gender" id="optionsRadios1" value="m"> Male
													</label> <label class="radio-inline"> <input type="radio"
														name="gender" id="optionsRadios2" value="f">
														Female
													</label>
												</div>
											</div>
											<div class="form-group">
												<div class="col-md-3">
													<label for="password" class="control-label">Password</label>
													<input type="password" class="form-control" id="password"
														name="password" placeholder="">
												</div>
												<div class="col-md-3">
													<label for="password" class="control-label">Confirm
														Password</label> <input type="password" class="form-control"
														name="confirmPassword" id="password_confirm"
														placeholder="">
												</div>
											</div>
											<div class="form-group">
											<div class="col-md-6">
												Secret question <select class="form-control"  name="secret">
													<option value="What is your pet's name">What is your pet's name</option>
													<option value="What is the color of your first car">What is the color of your first car</option>
													<option value="What is your mother's maiden name">What is your mother's maiden name</option>
													<option value="What is your favorite grad subject">What is your favorite grad subject</option>
													<option value="What is your crush's name">What is your crush's name</option>
												</select>
											</div></div>
											
											<div class="form-group">
												<div class="col-md-6">
													<label for="answer" class="control-label">Answer</label> <input
														type="text" class="form-control" id="answer" name="answer"
														placeholder="">
												</div>
											</div>
											

											<div class="form-group">
												<div class="col-md-12">
													<label><input type="checkbox" name="terms"><a href="TermsConditions.jsp" class="text-center">
									I agree to Terms of Service and Privacy Policy.</a>
														</label>
												</div>
											</div>
											<div class="form-group">
												<div class="col-md-6">
													<input type="submit" value="Create account"
														class="btn btn-info"> <a href="Login.jsp"
														class="pull-right">LOGIN</a>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>