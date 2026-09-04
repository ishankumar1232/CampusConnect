<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Project</title>


<script>

function validateForm()
{
    var projectName =
        document.forms["projectForm"]["projectName"].value;

    var description =
        document.forms["projectForm"]["description"].value;

    var technologies =
        document.forms["projectForm"]["technologies"].value;

    var projectUrl =
        document.forms["projectForm"]["projectUrl"].value;


    /* Project Name */

    if(projectName=="" || projectName==null)
    {
        alert("Project Name is required");

        document.forms["projectForm"]["projectName"].focus();

        return false;
    }


    /* Description */

    if(description=="" || description==null)
    {
        alert("Project Description is required");

        document.forms["projectForm"]["description"].focus();

        return false;
    }


    /* Technologies */

    if(technologies=="" || technologies==null)
    {
        alert("Technologies are required");

        document.forms["projectForm"]["technologies"].focus();

        return false;
    }


    return true;
}

</script>

</head>


<body>

<h2>Student Project</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="projectForm"
      method="post"
      action="studentProject"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<!-- PROJECT NAME -->

<tr>

<td>
Project Name <span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="projectName"
       placeholder="Enter Project Name">

</td>

</tr>


<!-- DESCRIPTION -->

<tr>

<td>
Description <span style="color:red">*</span>
</td>

<td>

<textarea name="description"
          rows="5"
          cols="30"
          placeholder="Enter Project Description"></textarea>

</td>

</tr>


<!-- TECHNOLOGIES -->

<tr>

<td>
Technologies <span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="technologies"
       placeholder="Example: Java, Oracle, HTML">

</td>

</tr>


<!-- PROJECT URL -->

<tr>

<td>
Project URL
</td>

<td>

<input type="text"
       name="projectUrl"
       placeholder="https://github.com/...">

</td>

</tr>


<!-- BUTTONS -->

<tr>

<td>

<input type="submit"
       value="Add Project">

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