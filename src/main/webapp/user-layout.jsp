<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String pageName = request.getParameter("page");
    if (pageName == null) pageName = "dashboard";
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
            background-color: #1A1A2E;
            font-family: 'Segoe UI', Arial, Helvetica, sans-serif;
            min-height: 100vh;
            color: #FFFFFF;
        }

        .dashboard {
            min-height: 100vh;
            display: flex;
            padding: 28px;
            gap: 20px;
        }

        .sidebar {
            width: 220px;
            background-color: #171717;
            border-radius: 22px;
            padding: 28px 18px;
            display: flex;
            flex-direction: column;
            color: white;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
            flex-shrink: 0;
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

        .logout-btn {
            color: #bdbdbd;
            text-decoration: none;
        }

        .logout-btn:hover {
            color: #fff;
        }

        .content {
            flex: 1;
            padding: 5px 0 5px 0;
            min-width: 0;
            background: transparent;
        }

        .top-bar {
            height: 75px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .page-title h1 {
            font-size: 22px;
            font-weight: 600;
            color: #FFFFFF;
            text-transform: capitalize;
        }

        .user-area {
            display: flex;
            align-items: center;
            gap: 15px;
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
            background: rgba(255, 255, 255, 0.15);
            display: flex;
            justify-content: center;
            align-items: center;
            color: #FFFFFF;
            font-size: 17px;
            font-weight: 700;
        }

        .profile-text {
            line-height: 1.3;
        }

        .profile-text strong {
            display: block;
            font-size: 14px;
            color: #FFFFFF;
            font-weight: 600;
        }

        .profile-text span {
            display: block;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 2px;
        }

        @media (max-width: 900px) {
            .dashboard { padding: 15px; }
            .sidebar { width: 180px; }
            .content { padding-left: 0; }
        }

        @media (max-width: 700px) {
            .dashboard { display: block; }
            .sidebar { width: 100%; margin-bottom: 15px; }
            .side-menu { flex-direction: row; flex-wrap: wrap; }
            .sidebar-bottom { margin-top: 10px; }
            .content { padding: 0; }
            .top-bar { padding: 0 15px; }
        }
    </style>
</head>

<body>

<div class="dashboard">

    <aside class="sidebar">
        <div class="logo">
            <img src="logo.png" alt="Sunrise Dental">
        </div>
        <div class="side-menu">
            <a href="UserLayoutServlet?page=dashboard" class="side-item <%= "dashboard".equals(pageName) ? "active" : "" %>">
                <span class="side-icon">▦</span>
                <span>Dashboard</span>
            </a>
            <a href="UserLayoutServlet?page=book-appointment" class="side-item <%= "book-appointment".equals(pageName) ? "active" : "" %>">
                <span class="side-icon">+</span>
                <span>Book Appointment</span>
            </a>
           
            <a href="UserLayoutServlet?page=view-appointments" class="side-item <%= "view-appointments".equals(pageName) ? "active" : "" %>">
                <span class="side-icon">▣</span>
                <span>View Appointments</span>
            </a>

            <a href="UserLayoutServlet?page=view-bills" class="side-item <%= "view-bills".equals(pageName) ? "active" : "" %>">
                <span class="side-icon">🧾</span>
                <span>View Bills</span>
            </a>

            <a href="UserLayoutServlet?page=help" class="side-item <%= "help".equals(pageName) ? "active" : "" %>">
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

    <main class="content">

        <div class="top-bar">
            <div class="page-title">
                <h1><%= pageName.replace("-", " ") %></h1>
            </div>
            <div class="user-area">
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

        <%
            String contentPage = "user-dashboard-content.jsp";
            if ("book-appointment".equals(pageName)) contentPage = "book-appointment.jsp";
            else if ("view-appointments".equals(pageName)) contentPage = "view-appointments.jsp";
            else if ("view-bills".equals(pageName)) contentPage = "view-bills.jsp";
            else if ("help".equals(pageName)) contentPage = "help.jsp";
        %>
        <jsp:include page="<%= contentPage %>" />

    </main>

</div>

</body>
</html>