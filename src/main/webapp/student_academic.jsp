<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Academic Details</title>


<script>

function validateForm()
{
    var qualification =
        document.forms["academicForm"]["qualification"].value;

    var year =
        document.forms["academicForm"]["year"].value;

    var percentage =
        document.forms["academicForm"]["percentage"].value;

    var cgpa =
        document.forms["academicForm"]["cgpa"].value;

    var backlogs =
        document.forms["academicForm"]["backlogs"].value;


    /* Qualification */

    if(qualification=="" || qualification==null)
    {
        alert("Qualification is required");

        document.forms["academicForm"]["qualification"].focus();

        return false;
    }


    /* Year */

    if(year=="" || year==null)
    {
        alert("Year is required");

        document.forms["academicForm"]["year"].focus();

        return false;
    }


    /* Percentage */

    if(percentage=="" || percentage==null)
    {
        alert("Percentage is required");

        document.forms["academicForm"]["percentage"].focus();

        return false;
    }


    if(percentage < 0 || percentage > 100)
    {
        alert("Percentage must be between 0 and 100");

        document.forms["academicForm"]["percentage"].focus();

        return false;
    }


    /* CGPA */

    if(cgpa=="" || cgpa==null)
    {
        alert("CGPA is required");

        document.forms["academicForm"]["cgpa"].focus();

        return false;
    }


    if(cgpa < 0 || cgpa > 10)
    {
        alert("CGPA must be between 0 and 10");

        document.forms["academicForm"]["cgpa"].focus();

        return false;
    }


    /* Backlogs */

    if(backlogs=="" || backlogs==null)
    {
        alert("Backlogs is required");

        document.forms["academicForm"]["backlogs"].focus();

        return false;
    }


    if(backlogs < 0)
    {
        alert("Backlogs cannot be negative");

        document.forms["academicForm"]["backlogs"].focus();

        return false;
    }


    return true;
}

</script>

</head>


<body>

<h2>Academic Details</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="academicForm"
      method="post"
      action="studentAcademic"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<!-- QUALIFICATION -->

<tr>

<td>
Qualification <span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="qualification"
       placeholder="Example: B.Tech">

</td>

</tr>


<!-- YEAR -->

<tr>

<td>
Year <span style="color:red">*</span>
</td>

<td>

<input type="number"
       name="year"
       placeholder="Example: 2026">

</td>

</tr>


<!-- PERCENTAGE -->

<tr>

<td>
Percentage <span style="color:red">*</span>
</td>

<td>

<input type="number"
       name="percentage"
       step="0.01"
       placeholder="Example: 85.50">

</td>

</tr>


<!-- CGPA -->

<tr>

<td>
CGPA <span style="color:red">*</span>
</td>

<td>

<input type="number"
       name="cgpa"
       step="0.01"
       placeholder="Example: 8.50">

</td>

</tr>


<!-- BACKLOGS -->

<tr>

<td>
Backlogs <span style="color:red">*</span>
</td>

<td>

<input type="number"
       name="backlogs"
       min="0"
       placeholder="Example: 0">

</td>

</tr>


<!-- BUTTONS -->

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


<br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>


</body>

</html>