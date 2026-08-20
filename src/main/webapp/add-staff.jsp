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
    <title>Add Staff - Sunrise Dental</title>
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
            max-width: 600px;
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

       
        .form-card {
            background: #FFFFFF;
            padding: 30px;
            border-radius: 12px;
            border: 1px solid #D4E3EB;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .form-card label {
            color: #263E5E;
            font-weight: bold;
            font-size: 14px;
            display: block;
            margin-bottom: 5px;
        }

        .form-card input {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 20px;
            border: 1px solid #D4E3EB;
            border-radius: 6px;
            font-size: 15px;
            box-sizing: border-box;
            font-family: 'Times New Roman', Times, serif;
            transition: border-color 0.3s;
        }

        .form-card input:focus {
            outline: none;
            border-color: #3D83C7;
        }

        .form-card .btn {
            background-color: #3D83C7;
            color: white;
            padding: 14px 25px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            font-family: 'Times New Roman', Times, serif;
            transition: background-color 0.3s;
            width: 100%;
        }

        .form-card .btn:hover {
            background-color: #2C6FA8;
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
        <h1>Add New Staff</h1>
        <p class="subtitle">Create a new account for staff members to login to the system.</p>

        
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

        
        <div class="form-card">
            <form action="StaffServlet" method="post">
                <input type="hidden" name="action" value="add">

                <label>Employee ID</label>
                <input type="text" name="employeeId" placeholder="Enter employee ID (e.g., EMP001)" required>

                <label>Employee Name</label>
                <input type="text" name="employeeName" placeholder="Enter full name" required>

                <label>Username</label>
                <input type="text" name="username" placeholder="Enter username for login" required>

                <label>Password</label>
                <input type="password" name="password" placeholder="Enter password" required>

                <button type="submit" class="btn">Add Staff</button>
            </form>
        </div>

        <a href="admin-dashboard.jsp" class="back-link">⬅ Back to Dashboard</a>
    </div>

</body>
</html>