<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard - Sunrise Dental</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #F4F8FB;
            font-family: 'Segoe UI', Arial, Helvetica, sans-serif;
            min-height: 100vh;
            color: #263E5E;
        }

        
        .dashboard {
            min-height: 100vh;
            display: flex;
            padding: 28px;
        }

        
        .sidebar {
            width: 220px;
            background-color: #171717;
            border-radius: 22px;
            padding: 28px 18px;
            display: flex;
            flex-direction: column;
            color: white;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
        }

        .logo {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 85px;
            margin-bottom: 28px;
        }

        .logo img {
            max-width: 125px;
            max-height: 75px;
            object-fit: contain;
        }

        .side-menu {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .side-item {
            height: 52px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 0 18px;
            color: #bdbdbd;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
        }

        .side-item.active {
            background-color: #3D83C7;
            color: white;
        }

        .side-item:hover {
            background-color: #252525;
            color: white;
        }

        .side-item.active:hover {
            background-color: #3D83C7;
        }

        .side-icon {
            width: 22px;
            text-align: center;
            font-size: 18px;
        }

        .sidebar-bottom {
            margin-top: auto;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        
        .content {
            flex: 1;
            padding: 5px 0 5px 30px;
            min-width: 0;
        }

        
        .top-bar {
            height: 75px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 10px 0 5px;
            margin-bottom: 20px;
        }

        .page-title {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .page-title .back {
            font-size: 25px;
            color: #263E5E;
        }

        .page-title h1 {
            font-size: 22px;
            font-weight: 600;
            color: #263E5E;
        }

        .user-area {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .notification {
            width: 42px;
            height: 42px;
            background-color: white;
            border: 1px solid #E2E9F0;
            border-radius: 11px;
        }

        .profile {
            display: flex;
            align-items: center;
            gap: 11px;
            padding-left: 5px;
        }

        .profile-avatar {
            width: 43px;
            height: 43px;
            border-radius: 50%;
            background-color: #DCEFFA;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #3D83C7;
            font-size: 17px;
            font-weight: 700;
        }

        .profile-text {
            line-height: 1.3;
        }

        .profile-text strong {
            display: block;
            font-size: 14px;
            color: #263E5E;
            font-weight: 600;
        }

        .profile-text span {
            display: block;
            font-size: 12px;
            color: #687789;
            margin-top: 2px;
        }

        
        .welcome-card {
            background: linear-gradient(135deg, #3D83C7, #2A5F94);
            color: white;
            border-radius: 18px;
            padding: 28px 32px;
            margin-bottom: 22px;
            box-shadow: 0 8px 24px rgba(47, 103, 173, 0.20);
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 155px;
        }

        .welcome-content h2 {
            font-size: 25px;
            font-weight: 650;
            margin-bottom: 8px;
        }

        .welcome-content p {
            color: white;
            font-size: 14px;
            line-height: 1.6;
            opacity: 0.92;
        }

        .welcome-content strong {
            color: white;
        }

        
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1.35fr 0.65fr;
            gap: 22px;
        }

        
        .card {
            background-color: #FFFFFF;
            border: 1px solid #E2E9F0;
            border-radius: 18px;
            box-shadow: 0 5px 20px rgba(38, 62, 94, 0.05);
        }

        .card-header {
            padding: 24px 26px 16px;
        }

        .card-header h3 {
            font-size: 18px;
            font-weight: 650;
            color: #263E5E;
        }

        .card-header p {
            margin-top: 5px;
            color: #687789;
            font-size: 13px;
        }

        
        .quick-actions {
            padding: 10px 26px 26px;
            display: grid;
            grid-template-columns: 1fr;
            gap: 15px;
        }

        .quick-link {
            min-height: 145px;
            background-color: #FFFFFF;
            border: 1px solid #E2E9F0;
            border-radius: 14px;
            padding: 22px;
            text-decoration: none;
            color: #263E5E;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.2s ease;
        }

        .quick-link:hover {
            transform: translateY(-3px);
            border-color: #3D83C7;
            box-shadow: 0 8px 22px rgba(47, 103, 173, 0.12);
        }

        .quick-icon {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            background-color: #E8F5FD;
            color: #3D83C7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .quick-link span {
            font-size: 15px;
            font-weight: 600;
            margin-top: 15px;
        }

        .quick-link small {
            color: #687789;
            font-size: 12px;
            margin-top: 5px;
        }

        /* SIDE INFO */
        .info-card {
            padding-bottom: 20px;
        }

        .info-row {
            padding: 17px 26px;
            border-top: 1px solid #E2E9F0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .info-label {
            color: #687789;
            font-size: 13px;
        }

        .info-value {
            color: #263E5E;
            font-size: 13px;
            font-weight: 600;
            text-align: right;
        }

        .role-value {
            background-color: #E9F5FD;
            color: #3D83C7;
            padding: 5px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        
        .logout-btn {
            color: #bdbdbd;
            text-decoration: none;
        }

        .logout-btn:hover {
            color: #fff;
        }

        
        @media (max-width: 900px) {
            .dashboard {
                padding: 15px;
            }

            .sidebar {
                width: 180px;
            }

            .content {
                padding-left: 20px;
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 700px) {
            .dashboard {
                display: block;
            }

            .sidebar {
                width: 100%;
                margin-bottom: 15px;
            }

            .side-menu {
                flex-direction: row;
                flex-wrap: wrap;
            }

            .sidebar-bottom {
                margin-top: 10px;
            }

            .content {
                padding: 0;
            }

            .top-bar {
                padding: 0;
            }

            .quick-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="dashboard">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="logo">
            <img src="logo.png" alt="Sunrise Dental">
        </div>

        <div class="side-menu">

            <a href="#" class="side-item active">
                <span class="side-icon">▦</span>
                <span>Dashboard</span>
            </a>

            <a href="view-patients.jsp" class="side-item">
                <span class="side-icon">●</span>
                <span>View Patient</span>
            </a>

            <a href="#" class="side-item">
                <span class="side-icon">▣</span>
                <span>View Appointments</span>
            </a>

            <a href="#" class="side-item">
                <span class="side-icon">●</span>
                <span>View Bills</span>
            </a>

            <a href="#" class="side-item">
                <span class="side-icon">?</span>
                <span>Help</span>
            </a>

        </div>

        <div class="sidebar-bottom">

            <a href="logout.jsp" class="side-item logout-btn">
                <span class="side-icon">⇥</span>
                <span>Log Out</span>
            </a>

        </div>

    </aside>


    <!-- MAIN CONTENT -->
    <main class="content">

        <!-- TOP BAR -->
        <div class="top-bar">

            <div class="page-title">
                <span class="back">‹</span>
                <h1>Dashboard</h1>
            </div>

            <div class="user-area">

                <div class="notification"></div>

                <div class="profile">

                    <div class="profile-avatar">
                        <%= username.substring(0, 1).toUpperCase() %>
                    </div>

                    <div class="profile-text">
                        <strong><%= username %></strong>
                        <span><%= role %></span>
                    </div>

                </div>

            </div>

        </div>


        <!-- WELCOME -->
        <div class="welcome-card">

            <div class="welcome-content">

                <h2>Welcome, <%= username %>!</h2>
            </div>

        </div>


        <!-- DASHBOARD CARDS -->
        <div class="dashboard-grid">

            <!-- QUICK ACTIONS -->
            <div class="card">

                <div class="card-header">
                    <h3>Quick Actions</h3>
                    <p>Access your frequently used option</p>
                </div>

                <div class="quick-actions">

                    <a href="#" class="quick-link">

                        <div class="quick-icon">
                            +
                        </div>

                        <div>
                            <span>Book an Appointment</span>
                        </div>

                    </a>

                </div>

            </div>


            <!-- USER INFORMATION -->
            <div class="card info-card">

                <div class="card-header">
                    <h3>Account Information</h3>
                    <p>Current session details</p>
                </div>

                <div class="info-row">

                    <span class="info-label">
                        Username
                    </span>

                    <span class="info-value">
                        <%= username %>
                    </span>

                </div>

                <div class="info-row">

                    <span class="info-label">
                        Role
                    </span>

                    <span class="role-value">
                        <%= role %>
                    </span>

                </div>

                <div class="info-row">

                    <span class="info-label">
                        Status
                    </span>

                    <span class="info-value">
                        Active
                    </span>

                </div>

            </div>

        </div>

    </main>

</div>

</body>
</html>