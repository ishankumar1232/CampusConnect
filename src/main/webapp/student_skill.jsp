<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Skills</title>


<script>

function validateForm()
{
    var skillName =
        document.forms["skillForm"]["skillName"].value;


    if(skillName=="" || skillName==null)
    {
        alert("Skill Name is required");

        document.forms["skillForm"]["skillName"].focus();

        return false;
    }


    var letters =
        /^[A-Za-z0-9+#. ]+$/;


    if(!letters.test(skillName))
    {
        alert("Invalid Skill Name");

        document.forms["skillForm"]["skillName"].focus();

        return false;
    }


    return true;
}

</script>

</head>


<body>

<h2>Student Skills</h2>

<p>
<span style="color:red;">*</span>
Indicates Mandatory Fields
</p>


<form name="skillForm"
      method="post"
      action="studentSkill"
      onsubmit="return validateForm();">


<table border="0" cellpadding="8">


<tr>

<td>
Skill Name <span style="color:red">*</span>
</td>

<td>

<input type="text"
       name="skillName"
       placeholder="Example: Java">

</td>

</tr>


<tr>

<td>

<input type="submit"
       value="Add Skill">

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