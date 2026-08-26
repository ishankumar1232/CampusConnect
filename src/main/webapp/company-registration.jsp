<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Company Registration</title>

<script>

function validateForm()
{
    var companyName = document.forms["myForm"]["companyName"].value;
    var email = document.forms["myForm"]["email"].value;
    var phone = document.forms["myForm"]["phone"].value;
    var password = document.forms["myForm"]["password"].value;
    var confirmPassword = document.forms["myForm"]["confirmPassword"].value;
    var address = document.forms["myForm"]["address"].value;
    var website = document.forms["myForm"]["website"].value;
    var status = document.forms["myForm"]["status"].value;


    // Check if all mandatory fields are blank

    if ((companyName=="" || companyName==null) &&
        (email=="" || email==null) &&
        (phone=="" || phone==null) &&
        (password=="" || password==null) &&
        (confirmPassword=="" || confirmPassword==null) &&
        (address=="" || address==null) &&
        (status=="" || status==null))
    {
        alert("All mandatory fields are blank");

        document.forms["myForm"]["companyName"].focus();

        return false;
    }


    // Company Name

    if(companyName=="" || companyName==null)
    {
        alert("Company Name is required");

        document.forms["myForm"]["companyName"].focus();

        return false;
    }

    var letters=/^[A-Za-z ]+$/;

    if(!letters.test(companyName))
    {
        alert("Company Name should contain letters only");

        document.forms["myForm"]["companyName"].focus();

        return false;
    }


    // Email

    if(email=="" || email==null)
    {
        alert("Email is required");

        document.forms["myForm"]["email"].focus();

        return false;
    }


    // Phone

    if(phone=="" || phone==null)
    {
        alert("Phone Number is required");

        document.forms["myForm"]["phone"].focus();

        return false;
    }

    var numbers=/^[0-9]+$/;

    if(!numbers.test(phone))
    {
        alert("Phone Number should contain numbers only");

        document.forms["myForm"]["phone"].focus();

        return false;
    }

    if(phone.length!=10)
    {
        alert("Phone Number must be 10 digits");

        document.forms["myForm"]["phone"].focus();

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


    // Confirm Password

    if(confirmPassword=="" || confirmPassword==null)
    {
        alert("Confirm Password is required");

        document.forms["myForm"]["confirmPassword"].focus();

        return false;
    }

    if(password!=confirmPassword)
    {
        alert("Password and Confirm Password do not match");

        document.forms["myForm"]["confirmPassword"].focus();

        return false;
    }


    // Address

    if(address=="" || address==null)
    {
        alert("Address is required");

        document.forms["myForm"]["address"].focus();

        return false;
    }


    // Website

    if(website!="" && website!=null)
    {
        if(website.indexOf("http://")!=0 &&
           website.indexOf("https://")!=0)
        {
            alert("Website should start with http:// or https://");

            document.forms["myForm"]["website"].focus();

            return false;
        }
    }


    // Status

    if(status=="" || status==null)
    {
        alert("Status is required");

        document.forms["myForm"]["status"].focus();

        return false;
    }


    alert("Form Submitted Successfully");

    return true;
}

</script>

</head>


<body>

<h2>Company Registration Form</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="myForm"
      method="post"
      action="CompanyServlet"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<tr>

<td>
Company Name
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="companyName"
       placeholder="Enter Company Name"
       onkeypress="return ((event.charCode>=65 && event.charCode<=90)||(event.charCode>=97 && event.charCode<=122)||event.charCode==32)">

</td>

</tr>


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
Phone Number
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="phone"
       maxlength="10"
       onkeypress="return(event.charCode>=48 && event.charCode<=57)">

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
Confirm Password
<span style="color:red">*</span>
</td>

<td>

<input type="password"
       name="confirmPassword">

</td>

</tr>


<tr>

<td>
Address
<span style="color:red">*</span>
</td>

<td>

<textarea name="address"
          rows="3"
          cols="20"></textarea>

</td>

</tr>


<tr>

<td>
Website
</td>

<td>

<input type="text"
       name="website"
       placeholder="https://example.com">

</td>

</tr>


<tr>

<td>
Status
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="status"
       value="ACTIVE">

</td>

</tr>


<tr>

<td>

<input type="submit"
       value="Submit">

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