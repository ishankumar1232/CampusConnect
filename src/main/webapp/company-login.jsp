<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Company Login</title>

<script>

function validateForm()
{
    var email = document.forms["myForm"]["email"].value;
    var password = document.forms["myForm"]["password"].value;


    // Check if all fields are blank

    if ((email=="" || email==null) &&
        (password=="" || password==null))
    {
        alert("Email and Password are required");

        document.forms["myForm"]["email"].focus();

        return false;
    }


    // Email

    if(email=="" || email==null)
    {
        alert("Email is required");

        document.forms["myForm"]["email"].focus();

        return false;
    }


    // Password

    if(password=="" || password==null)
    {
        alert("Password is required");

        document.forms["myForm"]["password"].focus();

        return false;
    }
    
    if(password.length<6)
    {
        alert("Password must be at least 6 characters");
        document.forms["myForm"]["password"].focus();
        return false;
    }


    return true;
}

</script>

</head>


<body>

<h2>Company Login</h2>

<p><span style="color:red;">*</span> Indicates Mandatory Fields</p>



<form name="myForm"
      method="post"
      action="CompanyLoginServlet"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<tr>

<td>
Email ID
<span style="color:red">*</span>
</td>

<td>

<input type="email"
       name="email">

</td>

</tr>


<tr>

<td>
Password
<span style="color:red">*</span>
</td>

<td>

<input type="password"
       name="password">

</td>

</tr>


<tr>

<td>

<input type="submit"
       value="Login">

</td>

<td>

<input type="reset"
       value="Reset">

</td>

</tr>


</table>

</form>


<br>


<a href="company-registration.jsp">
New Company? Register Here
</a>


</body>

</html>