<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Check Admission Status</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
        }

        .container {
            width: 450px;
            margin: 80px auto;
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        h2 {
            text-align: center;
            color: #1e3a8a;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #333;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-top: 7px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus {
            border-color: #2563eb;
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 25px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #1d4ed8;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #2563eb;
        }

        .back:hover {
            text-decoration: underline;
        }

    </style>

</head>

<body>

<div class="container">

    <h2>Check Admission Status</h2>

    <form action="newStudentCheckStatus" method="post">

        <label>Admission / Request ID</label>

        <input type="number"
               name="admissionId"
               placeholder="Enter Request ID"
               required>

        <label>Email</label>

        <input type="email"
               name="email"
               placeholder="Enter your email"
               required>

        <button type="submit">
            Check Status
        </button>

    </form>

    <a href="new_student_colleges.jsp" class="back">
        Back to Colleges
    </a>

</div>

</body>
</html>