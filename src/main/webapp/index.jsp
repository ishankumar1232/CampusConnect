<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>CampusConnect</title>

    <style>

        body
        {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
        }

        /* HEADER */

        .header
        {
            background-color: #1f4e79;
            color: white;
            text-align: center;
            padding: 30px;
        }

        .header h1
        {
            margin: 0;
            font-size: 40px;
        }

        .header p
        {
            font-size: 18px;
            margin-top: 10px;
        }


        /* MAIN CONTAINER */

        .container
        {
            width: 90%;
            margin: 40px auto;
            text-align: center;
        }

        .container h2
        {
            color: #333;
        }

        .container > p
        {
            color: #555;
        }


        /* MODULE CARDS */

        .modules
        {
            display: flex;
            justify-content: center;
            gap: 25px;
            flex-wrap: wrap;
            margin-top: 30px;
        }


        .card
        {
            background-color: white;
            width: 240px;
            min-height: 230px;

            padding: 25px;

            border-radius: 10px;

            box-shadow: 0 3px 10px #aaa;

            text-align: center;
        }


        .card h3
        {
            color: #1f4e79;
            font-size: 24px;
            margin-top: 10px;
        }


        .card p
        {
            color: #555;
            line-height: 1.5;
            min-height: 75px;
        }


        /* BUTTON */

        .btn
        {
            display: inline-block;

            padding: 12px 20px;

            margin: 7px 3px;

            background-color: #1f4e79;

            color: white;

            text-decoration: none;

            border-radius: 5px;
        }


        .btn:hover
        {
            background-color: #163a5c;
        }


        /* FOOTER */

        .footer
        {
            margin-top: 50px;

            background-color: #1f4e79;

            color: white;

            text-align: center;

            padding: 15px;
        }

    </style>

</head>


<body>


    <!-- HEADER -->

    <div class="header">

        <h1>CAMPUSCONNECT</h1>

        <p>
            Campus Recruitment Management System
        </p>

    </div>



    <!-- MAIN CONTENT -->

    <div class="container">

        <h2>Select Your Portal</h2>

        <p>
            Choose your role to continue
        </p>


        <div class="modules">


            <!-- ================= STUDENT ================= -->

            <div class="card">

                <h3>Student</h3>

                <p>
                    New students can explore colleges
                    and start the admission process.
                    Existing students can login to
                    their student portal.
                </p>


                <!-- NEW STUDENT -->

                <a href="new_student_colleges.jsp" class="btn">
                    New Student
                </a>


                <!-- EXISTING STUDENT -->

                <a href="student_login.jsp" class="btn">
                    Existing Student
                </a>

            </div>



            <!-- ================= COLLEGE ================= -->

            <div class="card">

                <h3>College</h3>

                <p>
                    Manage students, companies,
                    placement drives, applications
                    and recruitment activities.
                </p>


                <!-- Actual College page will be added later -->

                <a href="#" class="btn">
                    College Portal
                </a>

            </div>



            <!-- ================= COMPANY ================= -->

            <div class="card">

                <h3>Company</h3>

                <p>
                    Create placement drives,
                    view applications, shortlist
                    students and conduct recruitment.
                </p>


                <!-- Actual Company page will be added later -->

                <a href="#" class="btn">
                    Company Portal
                </a>

            </div>



            <!-- ================= SUPER ADMIN ================= -->

            <div class="card">

                <h3>Super Admin</h3>

                <p>
                    Manage colleges, companies,
                    students and system activities.
                </p>


                <!-- Actual Admin page will be added later -->

                <a href="#" class="btn">
                    Admin Portal
                </a>

            </div>


        </div>

    </div>



    <!-- FOOTER -->

    <div class="footer">

        <p>
            © 2026 CampusConnect |
            Campus Recruitment Management System
        </p>

    </div>


</body>

</html>