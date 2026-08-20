<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Student Registration</title>

<script>

function validateForm()
{
    var name = document.forms["studentForm"]["name"].value;
    var email = document.forms["studentForm"]["email"].value;
    var password = document.forms["studentForm"]["password"].value;
    var cpassword = document.forms["studentForm"]["cpassword"].value;
    var phone = document.forms["studentForm"]["phone"].value;
    var dob = document.forms["studentForm"]["dob"].value;
    var address = document.forms["studentForm"]["address"].value;
    var college = document.forms["studentForm"]["college"].value;
    var course = document.forms["studentForm"]["course"].value;
    var gender = document.forms["studentForm"]["gender"];

    /* Check if all mandatory fields are blank */

    if ((name=="" || name==null) &&
        (email=="" || email==null) &&
        (password=="" || password==null) &&
        (cpassword=="" || cpassword==null) &&
        (phone=="" || phone==null) &&
        (college=="" || college==null) &&
        (course=="" || course==null))
    {
        alert("All mandatory fields are blank");
        document.forms["studentForm"]["name"].focus();
        return false;
    }

    /* Name */

    if(name=="" || name==null)
    {
        alert("Name is required");
        document.forms["studentForm"]["name"].focus();
        return false;
    }

    var letters=/^[A-Za-z ]+$/;

    if(!letters.test(name))
    {
        alert("Name should contain letters only");
        document.forms["studentForm"]["name"].focus();
        return false;
    }

    /* Email */

    if(email=="" || email==null)
    {
        alert("Email is required");
        document.forms["studentForm"]["email"].focus();
        return false;
    }

    var emailPattern=/^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(!emailPattern.test(email))
    {
        alert("Enter a valid Email ID");
        document.forms["studentForm"]["email"].focus();
        return false;
    }

    /* Password */

    if(password=="" || password==null)
    {
        alert("Password is required");
        document.forms["studentForm"]["password"].focus();
        return false;
    }

    if(password.length<6)
    {
        alert("Password must be at least 6 characters");
        document.forms["studentForm"]["password"].focus();
        return false;
    }

    /* Confirm Password */

    if(cpassword=="" || cpassword==null)
    {
        alert("Confirm Password is required");
        document.forms["studentForm"]["cpassword"].focus();
        return false;
    }

    if(password!=cpassword)
    {
        alert("Passwords do not match");
        document.forms["studentForm"]["cpassword"].focus();
        return false;
    }

    /* Phone */

    if(phone=="" || phone==null)
    {
        alert("Phone Number is required");
        document.forms["studentForm"]["phone"].focus();
        return false;
    }

    var numbers=/^[0-9]+$/;

    if(!numbers.test(phone))
    {
        alert("Phone Number should contain numbers only");
        document.forms["studentForm"]["phone"].focus();
        return false;
    }

    if(phone.length!=10)
    {
        alert("Phone Number must be 10 digits");
        document.forms["studentForm"]["phone"].focus();
        return false;
    }

    /* Date of Birth */

    if(dob=="" || dob==null)
    {
        alert("Date of Birth is required");
        document.forms["studentForm"]["dob"].focus();
        return false;
    }

    /* Gender */

    if(!gender[0].checked && !gender[1].checked)
    {
        alert("Please select Gender");
        return false;
    }

    /* Address */

    if(address=="" || address==null)
    {
        alert("Address is required");
        document.forms["studentForm"]["address"].focus();
        return false;
    }

    /* College */

    if(college=="" || college==null)
    {
        alert("Please select College");
        document.forms["studentForm"]["college"].focus();
        return false;
    }

    /* Course */

    if(course=="" || course==null)
    {
        alert("Please select Course");
        document.forms["studentForm"]["course"].focus();
        return false;
    }

    alert("Registration Form Submitted Successfully");

    return true;
}

</script>

</head>


<body>

<h2>Student Registration</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="studentForm"
      method="post"
      action="studentRegister"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<tr>

<td>
Name <span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="name"
       placeholder="Enter Name"
       onkeypress="return ((event.charCode>=65 && event.charCode<=90)||(event.charCode>=97 && event.charCode<=122)||event.charCode==32)">

</td>

</tr>


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
Confirm Password <span style="color:red">*</span>
</td>

<td>

<input type="password"
       name="cpassword"
       placeholder="Confirm Password">

</td>

</tr>


<tr>

<td>
Phone Number <span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="phone"
       maxlength="10"
       placeholder="Enter 10 digit number"
       onkeypress="return(event.charCode>=48 && event.charCode<=57)">

</td>

</tr>


<tr>

<td>
Date of Birth <span style="color:red">*</span>
</td>

<td>

<input type="date"
       name="dob">

</td>

</tr>


<tr>

<td>
Gender <span style="color:red">*</span>
</td>

<td>

<input type="radio"
       name="gender"
       value="Male">

Male

<input type="radio"
       name="gender"
       value="Female">

Female

</td>

</tr>


<tr>

<td>
Address <span style="color:red">*</span>
</td>

<td>

<textarea name="address"
          rows="3"
          cols="25"
          placeholder="Enter Address"></textarea>

</td>

</tr>


<tr>

<td>
College <span style="color:red">*</span>
</td>

<td>

<select name="college">

    <option value="">Select College</option>

    <%
        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();

            String q = "SELECT COLLEGE_ID, COLLEGE_NAME " +
                       "FROM COLLEGE " +
                       "WHERE STATUS='ACTIVE' " +
                       "ORDER BY COLLEGE_NAME";

            ResultSet rs = stmt.executeQuery(q);

            while(rs.next())
            {
    %>

                <option value="<%=rs.getInt("COLLEGE_ID")%>">
                    <%=rs.getString("COLLEGE_NAME")%>
                </option>

    <%
            }

            rs.close();
            stmt.close();
            con.close();
        }
        catch(Exception e)
        {
            out.println(e);
        }
    %>

</select>

</td>

</tr>


<tr>

<td>
Course <span style="color:red">*</span>
</td>

<td>

<select name="course">

    <option value="">Select Course</option>

    <%
        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();

            String q = "SELECT COURSE_ID, COURSE_NAME " +
                       "FROM COURSE " +
                       "ORDER BY COURSE_NAME";

            ResultSet rs = stmt.executeQuery(q);

            while(rs.next())
            {
    %>

                <option value="<%=rs.getInt("COURSE_ID")%>">
                    <%=rs.getString("COURSE_NAME")%>
                </option>

    <%
            }

            rs.close();
            stmt.close();
            con.close();
        }
        catch(Exception e)
        {
            out.println(e);
        }
    %>

</select>

</td>

</tr>


<tr>

<td>

<input type="submit"
       value="Register">

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