<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }
%>

<html>

<head>

<title>Create Recruitment Drive</title>

<script>

function validateForm()
{
    var driveType = document.forms["myForm"]["driveType"].value;
    var jobTitle = document.forms["myForm"]["jobTitle"].value;
    var description = document.forms["myForm"]["description"].value;
    var vacancy = document.forms["myForm"]["vacancy"].value;
    var eligibilityCgpa = document.forms["myForm"]["eligibilityCgpa"].value;
    var requiredBranch = document.forms["myForm"]["requiredBranch"].value;
    var requiredSkills = document.forms["myForm"]["requiredSkills"].value;
    var salary = document.forms["myForm"]["salary"].value;
    var deadline = document.forms["myForm"]["deadline"].value;


    if((driveType=="" || driveType==null) &&
       (jobTitle=="" || jobTitle==null) &&
       (description=="" || description==null) &&
       (vacancy=="" || vacancy==null) &&
       (eligibilityCgpa=="" || eligibilityCgpa==null) &&
       (requiredBranch=="" || requiredBranch==null) &&
       (requiredSkills=="" || requiredSkills==null) &&
       (salary=="" || salary==null) &&
       (deadline=="" || deadline==null))
    {
        alert("All mandatory fields are blank");

        document.forms["myForm"]["driveType"].focus();

        return false;
    }


    // Drive Type

    if(driveType=="" || driveType==null)
    {
        alert("Drive Type is required");

        document.forms["myForm"]["driveType"].focus();

        return false;
    }


    // Job Title

    if(jobTitle=="" || jobTitle==null)
    {
        alert("Job Title is required");

        document.forms["myForm"]["jobTitle"].focus();

        return false;
    }


    // Description

    if(description=="" || description==null)
    {
        alert("Description is required");

        document.forms["myForm"]["description"].focus();

        return false;
    }


    // Vacancy

    if(vacancy=="" || vacancy==null)
    {
        alert("Vacancy is required");

        document.forms["myForm"]["vacancy"].focus();

        return false;
    }

    var numbers=/^[0-9]+$/;

    if(!numbers.test(vacancy))
    {
        alert("Vacancy should contain numbers only");

        document.forms["myForm"]["vacancy"].focus();

        return false;
    }


    // Eligibility CGPA

    if(eligibilityCgpa=="" || eligibilityCgpa==null)
    {
        alert("Eligibility CGPA is required");

        document.forms["myForm"]["eligibilityCgpa"].focus();

        return false;
    }

    var cgpa=/^[0-9]+(\.[0-9]+)?$/;

    if(!cgpa.test(eligibilityCgpa))
    {
        alert("Enter a valid CGPA");

        document.forms["myForm"]["eligibilityCgpa"].focus();

        return false;
    }


    // Required Branch

    if(requiredBranch=="" || requiredBranch==null)
    {
        alert("Required Branch is required");

        document.forms["myForm"]["requiredBranch"].focus();

        return false;
    }


    // Required Skills

    if(requiredSkills=="" || requiredSkills==null)
    {
        alert("Required Skills are required");

        document.forms["myForm"]["requiredSkills"].focus();

        return false;
    }


    // Salary

    if(salary=="" || salary==null)
    {
        alert("Salary is required");

        document.forms["myForm"]["salary"].focus();

        return false;
    }

    if(!cgpa.test(salary))
    {
        alert("Salary should contain numbers only");

        document.forms["myForm"]["salary"].focus();

        return false;
    }


    // Deadline

    if(deadline=="" || deadline==null)
    {
        alert("Deadline is required");

        document.forms["myForm"]["deadline"].focus();

        return false;
    }


    alert("Form Submitted Successfully");

    return true;
}

</script>

</head>


<body>

<h2>Create Recruitment Drive</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="myForm"
      method="post"
      action="recruitment-drive-save.jsp"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<tr>

<td>
Drive Type
<span style="color:red">*</span>
</td>

<td>

<select name="driveType">

<option value="">Select Drive Type</option>

<option value="On Campus">On Campus</option>

<option value="Off Campus">Off Campus</option>

</select>

</td>

</tr>


<tr>

<td>
Job Title
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="jobTitle"
       placeholder="Enter Job Title">

</td>

</tr>


<tr>

<td>
Description
<span style="color:red">*</span>
</td>

<td>

<textarea name="description"
          rows="4"
          cols="30"
          placeholder="Enter Job Description"></textarea>

</td>

</tr>


<tr>

<td>
Vacancy
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="vacancy"
       maxlength="5"
       onkeypress="return(event.charCode>=48 && event.charCode<=57)">

</td>

</tr>


<tr>

<td>
Eligibility CGPA
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="eligibilityCgpa"
       placeholder="Example: 7.5">

</td>

</tr>


<tr>

<td>
Required Branch
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="requiredBranch"
       placeholder="Example: CSE">

</td>

</tr>


<tr>

<td>
Required Skills
<span style="color:red">*</span>
</td>

<td>

<textarea name="requiredSkills"
          rows="3"
          cols="30"
          placeholder="Example: Java, SQL, DSA"></textarea>

</td>

</tr>


<tr>

<td>
Salary
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="salary"
       placeholder="Example: 600000">

</td>

</tr>


<tr>

<td>
Deadline
<span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="deadline"
       placeholder="DD-MM-YYYY">

</td>

</tr>


<tr>

<td>
Status
</td>

<td>

<input type="text"
       name="status"
       value="ACTIVE"
       readonly>

</td>

</tr>


<tr>

<td>

<input type="submit"
       value="Create Drive">

</td>

<td>

<input type="reset"
       value="Reset">

</td>

</tr>


</table>

</form>

<br>

<a href="company-dashboard.jsp">Back to Dashboard</a>

</body>

</html>