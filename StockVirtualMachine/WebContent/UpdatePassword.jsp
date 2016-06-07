<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<link href="css/main.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="css/main.css">
<title>Update Password</title>

<script src="//code.jquery.com/jquery-1.9.1.js"></script>
<script
	src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
<link href="css/main.css" rel="stylesheet" type="text/css">

<!-- jQuery Form Validation code -->
<script>
	
	$(function() {

		// Setup for validation
		$("#update-form")
				.validate(
						{

							// Specify the validation rules
							rules : {
								
								password : {
									required : true,
									minlength : 5
								},
								confirmPassword : {
									required : true,
									minlength : 5
								},
								
						     },

							// Specify the validation error messages
							messages : {
								
								password : {
									required : "Please provide a password",
									minlength : "Your password must be at least 5 characters long"
								},
								confirmPassword : {
									required : "Please provide a Confirm password",
									minlength : "Your password must be at least 5 characters long"
								},
			
							},

							submitHandler : function(form) {
								form.submit();
							}
						});
	});
</script>

</head>
<body background="images/Portfolio2.jpg">

	
	
	<div style="padding-top: 20px">
		<div style="float: left; padding-left: 15px">
			<a class="btn btn-primary" href="Login.jsp"> <i
				class="fa fa-home"></i> Home
			</a>
		</div>
		</div>
		
		
		<div class="container">
	  <div class="col-md-12">
			<form class="form-horizontal FormDesign" role="form" action="/StockVirtualMachine/UpdatePassword"
				method="post" id="profile-form">
				<div class="row">
					<div class="col-md-12">
					  <h4><left>UPDATE PASSWORD</left></h4>
						<div class="container">
							<div class="col-md-12">
								<form class="FormDesign" role="form"
									action="/StockVirtualMachine/UpdatePassword" method="post">
									<div>
										<div class="form-group">
										        <div class="col-md-6">
													<label for="username" class="control-label">username</label>
													<input type="text" class="form-control" id="username"
														name="userName" placeholder="">
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
											
                                             </div>
                                             <br>
                                             
									<div class="form-group">
										<div class="col-md-6">
											<input type="submit" value="UPDATE"
												class="btn btn-warning btn-lg">
										</div>
										
									</div>
									</div>
						           </div></div></div></form>
						           
						           </div></div>

</body>
</html>
	</div>
	
	
	
	
</html>