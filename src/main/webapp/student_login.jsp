<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Login</title>

<script>

function validateForm()
{
    var email = document.forms["loginForm"]["email"].value;
    var password = document.forms["loginForm"]["password"].value;


    /* Check if all fields are blank */

    if((email=="" || email==null) &&
       (password=="" || password==null))
    {
        alert("All mandatory fields are blank");

        document.forms["loginForm"]["email"].focus();

        return false;
    }


    /* Email */

    if(email=="" || email==null)
    {
        alert("Email is required");

        document.forms["loginForm"]["email"].focus();

        return false;
    }


    /* Password */

    if(password=="" || password==null)
    {
        alert("Password is required");

        document.forms["loginForm"]["password"].focus();

        return false;
    }


    return true;
}

</script>

</head>


<body>

<h2>Student Login</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="loginForm"
      method="post"
      action="studentLogin"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<tr>

<td>
Email ID <span style="color:red">*</span>
</td>

<td>

<input type="email"
       name="email"
       placeholder="Enter Email">

</td>

</tr>


<tr>

<td>
Password <span style="color:red">*</span>
</td>

<td>

<input type="password"
       name="password"
       placeholder="Enter Password">

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


</body>

</html>