<%@page import="java.sql.Blob"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Profile Page2</title>
<script src="//code.jquery.com/jquery-1.9.1.js"></script>
  <script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
<link href="css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function clearFields()
{
	document.getElementById('first_name').value = "";
	document.getElementById('last_name').value = "";
	document.getElementById('email').value = "";
	document.getElementById('gender').value = "";
	document.getElementById('exampleInputFile').value = "";
}
</script>
<script type="text/javascript">

$(function() {

  // Setup for validation
  $("#profile-form").validate({
  
      // Specify the validation rules
      rules: {
          firstName: "required",
          lastName: "required",
          email: {
              required: true,
              email: true
          },
          userName: {
              required: true,
          },
          gender: "required",
      },
      
      // Specify the validation error messages
      messages: {
          firstname: "Please enter your first name",
          lastname: "Please enter your last name",
          password: {
              required: "Please provide a password",
              minlength: "Your password must be at least 5 characters long"
          },
          confirmPassword: {
              required: "Please provide a Confirm password",
              minlength: "Your password must be at least 5 characters long"
          },
          userName: {
             required: "Please enter a User Name",
          },
          email: "Please enter a valid email address",
          terms: "Please accept our policy"
      },
      
      submitHandler: function(form) {
          form.submit();
      }
  });
});



</script>
<style>
.circular {
	position: relative;
	top: 5px;
	left: 190px;
	bottom: 2px;
	width: 150px;
	height: 150px;
	border-radius: 150px;
	-webkit-border-radius: 150px;
	-moz-border-radius: 150px;
	overflow: hidden;
	background: url("images/dummy_profile.jpg") no-repeat;
}

.circular.img {
	max-height: 200px;
	max-width: 200px;
	object-fit: cover;
}

.control-label2 {
	display: block;
	padding: 0px 18px;
	color: #fff000;
}
</style>
</head>
<%!
String firstName = "";
String lastName = "";
String email = "";
String userName = "";
String gender = "";
String maleChecked = "";
String femaleChecked = "";
Blob image;

private void getUserDetails(HttpServletRequest request)
{
	String username = request.getSession().getAttribute("username").toString();
try {
	Class.forName("org.postgresql.Driver");
	Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "cs422");
	System.out.println("Opened Database successfully");
	Statement stmt = c.createStatement();
	ResultSet rs = stmt.executeQuery("select * from svm.\"Login\" where username='" + username+ "';");
	int counter = 0;
	while (rs.next()) {
		firstName = rs.getString(3);
		lastName = rs.getString(4);
		email = rs.getString(5);
		gender = rs.getString(6);
		image = rs.getBlob(8);
		if(gender.equalsIgnoreCase("m")){
			maleChecked = "checked='checked'";
			femaleChecked = "";
		}
		else if(gender.equalsIgnoreCase("f"))
		{
			femaleChecked = "checked='checked'";
			maleChecked = "";
		}
	}
	}catch(Exception ex)
	{
	ex.printStackTrace();
	}
}

%>
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
		</a>
			<a class="btn btn-info" href="ProfilePage.jsp"> <i
				class="fa fa-pencil-square"></i> Edit Profile
			</a> <a class="btn btn-warning" href="/StockVirtualMachine/LogoutServlet">
				<i class="fa fa-sign-out"></i> Logout
			</a>
			
		
		</div>
	</div>
<%
getUserDetails(request);
%>
	<div class="container">
	  <div class="col-md-12">
			<form class="form-horizontal FormDesign" role="form" action="/StockVirtualMachine/UpdateUserServlet"
				method="post" id="profile-form">
				<div class="row">
					<div class="col-md-12">
					  <h4><left>EDIT PROFILE</left></h4>
						<div class="container">
							<div class="col-md-12">
								<form class="FormDesign" role="form"
									action="/StockVirtualMachine/UpdateUserServlet" method="post">
									<div>
										<div class="form-group">
											<div class="col-md-3">
												<label for="first_name" class="control-label">First
													Name</label> <input type="text" class="form-control"
													id="first_name" name="firstName" placeholder="" value="<%= firstName%>">
											</div>
											<div class="col-md-3">
												<label for="last_name" class="control-label">Last
													Name</label> <input type="text" class="form-control" id="last_name"
													name="lastName" placeholder="" value="<%=lastName %>">
											</div>
										</div>
										<div class="form-group">
											<div class="col-md-6">
												<label for="username" class="control-label">Email</label> <input
													type="email" class="form-control" id="email" name="email"
													placeholder="" value="<%= email%>">
											</div>
										</div>
										<div class="form-group">
											<div class="col-md-3">
												<label for="username" class="control-label">Username</label>
												<input type="text" readonly="readonly"  class="form-control" id="username"
													name="userName" placeholder="" value="<%= request.getSession().getAttribute("username") %>">
											</div><br>
											<div class="col-md-3 templatemo-radio-group">
												<label class="radio-inline"> <input type="radio"
													name="gender" id="optionsRadios1" value="m" <%=maleChecked %>> Male
												</label> <label class="radio-inline"> <input type="radio"
													name="gender" id="optionsRadios2" value="f" <%= femaleChecked%>> Female
												</label>
											</div>
											</div>
											
                                             </div>
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