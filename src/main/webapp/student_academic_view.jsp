<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Available Colleges | CampusConnect</title>


    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }


        body {
            background: #f4f7fb;
            color: #26364f;
        }


        /* ================= HEADER ================= */

        .header {
            background: linear-gradient(135deg, #123c88, #1769e0);

            color: white;

            padding: 20px 7%;

            display: flex;

            justify-content: space-between;

            align-items: center;
        }


        .logo {
            font-size: 26px;
            font-weight: bold;
        }


        .logo span {
            color: #a9d0ff;
        }


        .home-btn {
            color: white;

            text-decoration: none;

            border: 1px solid rgba(255,255,255,0.7);

            padding: 9px 16px;

            border-radius: 7px;

            font-size: 14px;
        }


        .home-btn:hover {
            background: rgba(255,255,255,0.15);
        }


        /* ================= MAIN ================= */

        .container {
            width: 90%;

            max-width: 1150px;

            margin: 45px auto;
        }


        /* ================= TITLE ================= */

        .page-title {
            text-align: center;

            margin-bottom: 30px;
        }


        .page-title h1 {
            color: #173c76;

            font-size: 35px;

            margin-bottom: 10px;
        }


        .page-title p {
            color: #718096;

            font-size: 15px;
        }


        /* ================= SEARCH ================= */

        .search-box {
            background: white;

            padding: 18px;

            border-radius: 12px;

            border: 1px solid #e2e8f0;

            margin-bottom: 30px;

            box-shadow: 0 5px 20px rgba(30,60,100,0.06);
        }


        .search-input {
            width: 100%;

            padding: 13px 16px;

            border: 1px solid #d6dfeb;

            border-radius: 8px;

            outline: none;

            font-size: 14px;
        }


        .search-input:focus {
            border-color: #1769e0;

            box-shadow:
                0 0 0 3px rgba(23,105,224,0.10);
        }


        /* ================= COLLEGE GRID ================= */

        .college-grid {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 25px;
        }


        /* ================= CARD ================= */

        .college-card {
            background: white;

            border-radius: 15px;

            overflow: hidden;

            border: 1px solid #e2e8f0;

            box-shadow:
                0 7px 25px rgba(30,60,100,0.08);

            transition: 0.3s;
        }


        .college-card:hover {
            transform: translateY(-6px);

            box-shadow:
                0 14px 35px rgba(30,60,100,0.13);
        }


        /* ================= IMAGE ================= */

        .college-image {
            width: 100%;

            height: 190px;

            background: #e7f0ff;

            overflow: hidden;
        }


        .college-image img {
            width: 100%;

            height: 100%;

            object-fit: cover;
        }


        /* ================= CARD CONTENT ================= */

        .card-content {
            padding: 20px;
        }


        .college-name {
            color: #173c76;

            font-size: 20px;

            line-height: 1.35;

            margin-bottom: 10px;
        }


        .location {
            color: #6d7b90;

            font-size: 13px;

            margin-bottom: 18px;
        }


        .location strong {
            color: #3d506b;
        }


        /* ================= INFO ================= */

        .info {
            border-top: 1px solid #edf0f5;

            padding-top: 14px;

            margin-bottom: 15px;
        }


        .info-row {
            display: flex;

            margin-bottom: 8px;

            font-size: 13px;
        }


        .info-label {
            width: 65px;

            color: #929dad;
        }


        .info-value {
            flex: 1;

            color: #465a75;

            word-break: break-word;
        }


        /* ================= BUTTON ================= */

        .view-btn {
            display: block;

            width: 100%;

            text-align: center;

            text-decoration: none;

            background: #1769e0;

            color: white;

            padding: 12px;

            border-radius: 8px;

            font-size: 13px;

            font-weight: bold;

            transition: 0.3s;
        }


        .view-btn:hover {
            background: #0d54bd;
        }


        /* ================= NO COLLEGE ================= */

        .no-college {
            grid-column: 1 / -1;

            background: white;

            padding: 50px;

            text-align: center;

            border-radius: 15px;

            border: 1px solid #e2e8f0;
        }


        .no-college h2 {
            color: #173c76;

            margin-bottom: 10px;
        }


        .no-college p {
            color: #718096;
        }


        /* ================= FOOTER ================= */

        .footer {
            margin-top: 60px;

            background: #123c88;

            color: #dceaff;

            text-align: center;

            padding: 20px;

            font-size: 13px;
        }


        /* ================= RESPONSIVE ================= */

        @media(max-width: 900px) {

            .college-grid {
                grid-template-columns: repeat(2, 1fr);
            }

        }


        @media(max-width: 600px) {

            .college-grid {
                grid-template-columns: 1fr;
            }

            .header {
                padding: 18px 5%;
            }

            .page-title h1 {
                font-size: 29px;
            }

        }

    </style>


    <script>

        function searchCollege()
        {

            var input =
                document.getElementById("search");

            var filter =
                input.value.toLowerCase();

            var cards =
                document.getElementsByClassName(
                    "college-card"
                );


            for(var i = 0; i < cards.length; i++)
            {

                var name =
                    cards[i]
                    .getElementsByClassName(
                        "college-name"
                    )[0]
                    .innerText
                    .toLowerCase();


                var city =
                    cards[i]
                    .getElementsByClassName(
                        "college-city"
                    )[0]
                    .innerText
                    .toLowerCase();


                if(name.indexOf(filter) > -1 ||
                   city.indexOf(filter) > -1)
                {

                    cards[i].style.display = "";

                }
                else
                {

                    cards[i].style.display = "none";

                }

            }

        }

    </script>

</head>


<body>


    <!-- ================= HEADER ================= -->

    <div class="header">


        <div class="logo">

            Campus<span>Connect</span>

        </div>


        <a href="index.jsp"
           class="home-btn">

            Back to Home

        </a>


    </div>



    <!-- ================= MAIN ================= -->

    <div class="container">


        <div class="page-title">

            <h1>
                Explore Colleges
            </h1>


            <p>
                Find the right college and start your
                admission journey with CampusConnect.
            </p>

        </div>



        <!-- ================= SEARCH ================= -->

        <div class="search-box">

            <input type="text"

                   id="search"

                   class="search-input"

                   placeholder="Search college by name or city..."

                   onkeyup="searchCollege()">

        </div>



        <!-- ================= COLLEGE GRID ================= -->

        <div class="college-grid">


<%

    Connection con = null;

    PreparedStatement ps = null;

    ResultSet rs = null;


    try
    {

        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );


        con = DriverManager.getConnection(

            "jdbc:oracle:thin:@localhost:1521:XE",

            "CAMPUSCONNECT",

            "campus123"

        );


        String sql =

            "SELECT COLLEGE_ID, " +
            "COLLEGE_NAME, " +
            "ADDRESS, " +
            "CITY, " +
            "STATE, " +
            "EMAIL, " +
            "PHONE " +
            "FROM COLLEGE " +
            "WHERE STATUS = 'APPROVED' " +
            "ORDER BY COLLEGE_NAME";


        ps = con.prepareStatement(sql);


        rs = ps.executeQuery();


        boolean found = false;


        while(rs.next())
        {

            found = true;


%>


            <!-- ================= COLLEGE CARD ================= -->

            <div class="college-card">


                <!-- IMAGE -->

                <div class="college-image">

                    <img src="images/college-default.jpg"
                         alt="College Image">

                </div>



                <!-- CONTENT -->

                <div class="card-content">


                    <h2 class="college-name">

                        <%=rs.getString("COLLEGE_NAME")%>

                    </h2>


                    <div class="location">

                        <span class="college-city">

                            <%=rs.getString("CITY")%>

                        </span>

                        ,

                        <strong>

                            <%=rs.getString("STATE")%>

                        </strong>

                    </div>



                    <!-- INFORMATION -->

                    <div class="info">


                        <div class="info-row">

                            <div class="info-label">
                                Address
                            </div>

                            <div class="info-value">

                                <%=rs.getString("ADDRESS")%>

                            </div>

                        </div>


                        <div class="info-row">

                            <div class="info-label">
                                Email
                            </div>

                            <div class="info-value">

                                <%=rs.getString("EMAIL")%>

                            </div>

                        </div>


                        <div class="info-row">

                            <div class="info-label">
                                Phone
                            </div>

                            <div class="info-value">

                                <%=rs.getString("PHONE")%>

                            </div>

                        </div>


                    </div>



                    <!-- VIEW BUTTON -->

                    <a href="new_student_college_compare.jsp?collegeId=<%=rs.getInt("COLLEGE_ID")%>"

                       class="view-btn">

                        View College Details

                    </a>


                </div>


            </div>


<%

        }


        if(!found)
        {

%>


            <div class="no-college">

                <h2>
                    No Colleges Available
                </h2>


                <p>

                    Currently there are no approved colleges
                    available for admission.

                </p>

            </div>


<%

        }

    }
    catch(Exception e)
    {

%>


            <div class="no-college">

                <h2>
                    Unable to Load Colleges
                </h2>


                <p>

                    <%=e.getMessage()%>

                </p>

            </div>


<%

    }
    finally
    {

        try
        {

            if(rs != null)
                rs.close();

            if(ps != null)
                ps.close();

            if(con != null)
                con.close();

        }
        catch(Exception e)
        {

        }

    }

%>


        </div>

    </div>



    <!-- ================= FOOTER ================= -->

    <div class="footer">

        CampusConnect |

        Campus Recruitment Management System

    </div>


</body>

</html>