<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Resume</title>


<script>

function validateForm()
{
    var resumeFile =
        document.forms["resumeForm"]["resumeFile"].value;


    if(resumeFile=="" || resumeFile==null)
    {
        alert("Resume File Name is required");

        document.forms["resumeForm"]["resumeFile"].focus();

        return false;
    }


    return true;
}

</script>

</head>


<body>

<h2>Upload Resume</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="resumeForm"
      method="post"
      action="studentResume"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<tr>

<td>
Resume File Name <span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="resumeFile"
       placeholder="Example: Rahul_Resume.pdf">

</td>

</tr>


<tr>

<td>

<input type="submit"
       value="Upload Resume">

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