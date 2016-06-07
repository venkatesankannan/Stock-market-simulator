<!DOCTYPE html PUBLIC>
<html>
<head>
<style>

</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<link href="css/main.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="css/main.css">
<title>Forgot Username and Password</title>
</head>
<body background="images/Portfolio3.jpg">

	
	
	<div style="padding-top: 20px">
		<div style="float: left; padding-left: 15px">
			<a class="btn btn-primary" href="Login.jsp"> <i
				class="fa fa-home"></i> Home
			</a>
		</div>
		</div>
		
		
		<div class="container">
	  <div class="col-md-12">
			<form class="form-horizontal FormDesign" role="form" action="/StockVirtualMachine/SecretServlet"
				method="post" id="profile-form">
				<div class="row">
					<div class="col-md-12">
					  <h4><left>SECRET QUESTION</left></h4>
						<div class="container">
							<div class="col-md-12">
								<form class="FormDesign" role="form"
									action="/StockVirtualMachine/SecretServlet" method="post">
									<div>
									<div class="form-group">
												<div class="col-md-6">
													<label for="userName" class="control-label">username</label> <input
														type="text" class="form-control" id="userName" name="userName"
														placeholder="">
												</div>
											</div>
										<div class="form-group">
											<div class="col-md-6">
												Secret question <select class="form-control" name="secret">
													<option value="What is your pet's name">What is your pet's name</option>
													<option value="What is the color of your first car">What is the color of your first car</option>
													<option value="What is your mother's maiden name">What is your mother's maiden name</option>
													<option value="What is your favorite grad subject">What is your favorite grad subject</option>
													<option value="What is your crush's name">What is your crush's name</option>
												</select>
											</div></div>
										<div class="form-group">
											<div class="col-md-6">
												<label for="username" class="control-label">Answer</label> <input
													type="text" class="form-control" id="answer" name="answer"
													placeholder="" value="">
											</div>
										</div>
											
                                             </div>
                                             <br>
                                             
									<div class="form-group">
										<div class="col-md-6">
											<input type="submit" value="SUBMIT"
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