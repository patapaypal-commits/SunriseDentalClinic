<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.sunrise.dao.DatabaseConnection" %>

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
    <title>View Patients - Sunrise Dental</title>
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
            margin-bottom: 30px;
        }

        .card {
            background: #FFFFFF;
            border-radius: 12px;
            padding: 25px;
            border: 1px solid #D4E3EB;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }
        table th {
            background-color: #263E5E;
            padding: 12px;
            text-align: left;
            color: white;
            font-weight: bold;
        }
        table td {
            padding: 10px 12px;
            border-bottom: 1px solid #D4E3EB;
        }
        table tr:hover {
            background-color: #F4F8FB;
        }

        .btn-delete {
            background-color: #C0392B;
            color: white;
            padding: 6px 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 13px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-delete:hover {
            background-color: #A5301F;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #3D83C7;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link:hover {
            text-decoration: underline;
        }

        .msg {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: bold;
            text-align: center;
        }
        .msg-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .msg-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .empty-msg {
            text-align: center;
            color: #687789;
            padding: 30px;
            font-size: 16px;
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
        <h1>Patient Management</h1>
        <p class="subtitle">View and manage all registered patients.</p>

        <%
            String successMsg = (String) request.getAttribute("successMsg");
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (successMsg != null) {
        %>
            <div class="msg msg-success"><%= successMsg %></div>
        <%
            }
            if (errorMsg != null) {
        %>
            <div class="msg msg-error"><%= errorMsg %></div>
        <%
            }
        %>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Patient ID</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Contact</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = DatabaseConnection.getInstance().getConnection();
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM patients ORDER BY patient_id");
                        ResultSet rs = ps.executeQuery();
                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                            int id = rs.getInt("patient_id");
                            String name = rs.getString("name");
                            String address = rs.getString("address");
                            String contact = rs.getString("contact_number");
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= address != null ? address : "-" %></td>
                        <td><%= contact %></td>
                        <td>
                            <a href="PatientServlet?action=delete&id=<%= id %>" class="btn-delete" onclick="return confirm('Delete this patient?')"> Delete</a>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hasData) {
                    %>
                    <tr>
                        <td colspan="5" class="empty-msg">No patients found.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <a href="admin-dashboard.jsp" class="back-link">⬅ Back to Dashboard</a>
    </div>

</body>
</html>