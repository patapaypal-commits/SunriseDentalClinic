<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }
%>

<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }

    .content-wrapper {
        background: rgba(255, 255, 255, 0.06);
        backdrop-filter: blur(16px);
        border-radius: 18px;
        padding: 32px 36px;
        border: 1px solid rgba(255, 255, 255, 0.06);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        max-width: 640px;
        margin: 0 auto;
    }

    .page-header {
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }

    .page-header h2 {
        color: #FFFFFF;
        font-size: 22px;
        font-weight: 600;
    }

    .page-header p {
        color: rgba(255, 255, 255, 0.4);
        font-size: 14px;
        margin-top: 6px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        color: rgba(255, 255, 255, 0.7);
        font-weight: 600;
        font-size: 14px;
        display: block;
        margin-bottom: 6px;
    }

    .form-group input {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 10px;
        font-size: 15px;
        font-family: 'Times New Roman', Times, serif;
        transition: border-color 0.3s, box-shadow 0.3s;
        background: rgba(255, 255, 255, 0.04);
        color: #FFFFFF;
    }

    .form-group input:focus {
        outline: none;
        border-color: #3D83C7;
        box-shadow: 0 0 0 3px rgba(61, 131, 199, 0.15);
        background: rgba(255, 255, 255, 0.06);
    }

    .form-group input::placeholder {
        color: rgba(255, 255, 255, 0.25);
    }

    .btn-submit {
        background: rgba(61, 131, 199, 0.8);
        color: white;
        padding: 14px 28px;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 700;
        font-size: 16px;
        font-family: 'Times New Roman', Times, serif;
        transition: background 0.3s;
        width: 100%;
        margin-top: 4px;
    }

    .btn-submit:hover {
        background: #3D83C7;
    }

    .msg {
        padding: 14px 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        font-weight: 500;
        text-align: center;
    }
    .msg-success { background: rgba(46, 204, 113, 0.15); color: #2ecc71; border: 1px solid rgba(46, 204, 113, 0.15); }
    .msg-error { background: rgba(231, 76, 60, 0.15); color: #e74c3c; border: 1px solid rgba(231, 76, 60, 0.15); }
</style>

<div class="content-wrapper">

    <div class="page-header">
        <h2>Add New Staff</h2>
        <p>Create a new account for staff members to login to the system.</p>
    </div>

    <%
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

    <form action="StaffServlet" method="post">
        <input type="hidden" name="action" value="add">

        <div class="form-group">
            <label>Employee ID</label>
            <input type="text" name="employeeId" placeholder="e.g., EMP001" required>
        </div>

        <div class="form-group">
            <label>Employee Name</label>
            <input type="text" name="employeeName" placeholder="Enter full name" required>
        </div>

        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Enter username for login" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter password" required>
        </div>

        <button type="submit" class="btn-submit">Add Staff</button>
    </form>

</div>