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
        padding: 28px 32px;
        border: 1px solid rgba(255, 255, 255, 0.06);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
    }

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }

    .page-header h2 {
        color: #FFFFFF;
        font-size: 22px;
        font-weight: 600;
    }

    .page-header .count-badge {
        background: rgba(255, 255, 255, 0.08);
        color: #3D83C7;
        padding: 6px 16px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        border: 1px solid rgba(61, 131, 199, 0.2);
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    table thead th {
        background: rgba(255, 255, 255, 0.04);
        color: rgba(255, 255, 255, 0.7);
        padding: 14px 16px;
        text-align: left;
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }

    table tbody td {
        padding: 14px 16px;
        font-size: 14px;
        color: rgba(255, 255, 255, 0.8);
        border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        vertical-align: middle;
    }

    table tbody tr:hover {
        background: rgba(255, 255, 255, 0.04);
    }

    table tbody tr:last-child td {
        border-bottom: none;
    }

    .btn-delete {
        background: rgba(192, 57, 43, 0.8);
        color: white;
        padding: 6px 18px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 600;
        font-size: 12px;
        text-decoration: none;
        display: inline-block;
        transition: background 0.2s;
    }

    .btn-delete:hover {
        background: #C0392B;
    }

    .empty-state {
        text-align: center;
        padding: 40px 20px;
        color: rgba(255, 255, 255, 0.3);
    }

    .empty-state .icon {
        font-size: 48px;
        margin-bottom: 12px;
        display: block;
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

    td strong { color: #FFFFFF; }
</style>

<div class="content-wrapper">

    <div class="page-header">
        <h2>Patient Management</h2>
        <span class="count-badge">Total: <%
            Connection conn = DatabaseConnection.getInstance().getConnection();
            PreparedStatement countPs = conn.prepareStatement("SELECT COUNT(*) FROM patients");
            ResultSet countRs = countPs.executeQuery();
            countRs.next();
            out.print(countRs.getInt(1));
        %></span>
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

    <table>
        <thead>
            <tr>
                <th>Patient ID</th>
                <th>Name</th>
                <th>Address</th>
                <th>Contact</th>
                <th style="text-align:center;">Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                conn = DatabaseConnection.getInstance().getConnection();
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
                <td><strong>#<%= id %></strong></td>
                <td><%= name %></td>
                <td><%= address != null ? address : "-" %></td>
                <td><%= contact %></td>
                <td style="text-align:center;">
                    <a href="PatientServlet?action=delete&id=<%= id %>" class="btn-delete" onclick="return confirm('Delete this patient?')">Delete</a>
                </td>
            </tr>
            <%
                }
                if (!hasData) {
            %>
            <tr>
                <td colspan="5">
                    <div class="empty-state">
                        <span class="icon">📋</span>
                        No patients found. Start by registering a new patient.
                    </div>
                </td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

</div>