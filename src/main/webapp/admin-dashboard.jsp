<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

   
    if (username == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Sunrise Dental</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: #F4F8FB;
            font-family: 'Times New Roman', Times, serif;
            min-height: 100vh;
        }

        
        .top-header {
            background-color: #263E5E;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .top-header .logo img {
            height: 72px;
            display: block;
        }
        .top-header .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .top-header .user-info .name {
            color: white;
            font-size: 16px;
        }
        .top-header .user-info .logout-btn {
            background-color: #C0392B;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            font-size: 14px;
        }
        .top-header .user-info .logout-btn:hover {
            background-color: #A5301F;
        }

        
        .main-content {
            padding: 40px 50px;
            max-width: 1000px;
            margin: 0 auto;
        }

        .main-content h1 {
            color: #263E5E;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .main-content .subtitle {
            color: #687789;
            font-size: 18px;
            margin-bottom: 40px;
        }

        
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .card {
            background: #FFFFFF;
            padding: 30px 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #D4E3EB;
            border-top: 4px solid #3D83C7;
            text-align: center;
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card .number {
            font-size: 32px;
            font-weight: bold;
            color: #263E5E;
        }
        .card .label {
            color: #687789;
            font-size: 15px;
            margin-top: 5px;
        }

        
        .quick-links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 10px;
        }

        .quick-link {
            background: #FFFFFF;
            padding: 25px 20px;
            border-radius: 12px;
            border: 1px solid #D4E3EB;
            text-decoration: none;
            color: #263E5E;
            font-weight: bold;
            font-size: 16px;
            text-align: center;
            transition: all 0.3s;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: block;
        }
        .quick-link:hover {
            background-color: #3D83C7;
            color: white;
            border-color: #3D83C7;
            transform: translateY(-3px);
        }

       
        .welcome-banner {
            background-color: #3D83C7;
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 40px;
            text-align: center;
        }
        .welcome-banner h2 {
            font-size: 28px;
            margin-bottom: 5px;
        }
        .welcome-banner p {
            font-size: 16px;
            opacity: 0.9;
        }
    </style>
</head>
<body>

    
    <div class="top-header">
        <div class="logo">
            <img src="logo.png" alt="Sunrise Dental">
        </div>
        <div class="user-info">
            <span class="name">Welcome, <strong><%= username %></strong></span>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
    </div>

   
    <div class="main-content">

        
        <div class="welcome-banner">
            <h2>Welcome, <%= username %>!</h2>
            <p>You are logged in as Administrator. Manage your clinic from here.</p>
        </div>

        
        <div class="card-grid">
            <div class="card">
                <div class="number">0</div>
                <div class="label">Total Staff</div>
            </div>
            <div class="card">
                <div class="number">0</div>
                <div class="label">Total Patients</div>
            </div>
        </div>

      
        <h2 style="color:#263E5E; margin-bottom: 20px;">Quick Actions</h2>
        <div class="quick-links">
            <a href="view-patients.jsp" class="quick-link">
                View Patients
            </a>
            <a href="add-staff.jsp" class="quick-link">
                Add Staff
            </a>
        </div>
    </div>

</body>
</html>