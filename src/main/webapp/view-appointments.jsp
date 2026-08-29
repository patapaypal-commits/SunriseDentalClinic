<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sunrise.dao.DatabaseConnection" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String errorMsg = (String) session.getAttribute("errorMsg");
    String successMsg = (String) session.getAttribute("successMsg");
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }
    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }

    String searchContact = request.getParameter("searchContact");
    List<Map<String, String>> appointments = new ArrayList<>();
    String patientName = "";
    String patientContact = "";

    if (searchContact != null && !searchContact.trim().isEmpty()) {
        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            
            
            PreparedStatement psPatient = conn.prepareStatement(
                "SELECT patient_id, name, contact_number FROM patients WHERE contact_number LIKE ?"
            );
            psPatient.setString(1, "%" + searchContact.trim() + "%");
            ResultSet rsPatient = psPatient.executeQuery();
            
            if (rsPatient.next()) {
                int patientId = rsPatient.getInt("patient_id");
                patientName = rsPatient.getString("name");
                patientContact = rsPatient.getString("contact_number");
                
                
                PreparedStatement psApp = conn.prepareStatement(
                    "SELECT a.appointment_number, a.appointment_date, a.appointment_time, a.status, " +
                    "d.name AS dentist_name, t.type AS treatment_name " +
                    "FROM appointments a " +
                    "JOIN dentists d ON a.dentist_id = d.dentist_id " +
                    "JOIN treatments t ON a.treatment_id = t.treatment_id " +
                    "WHERE a.patient_id = ? " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC"
                );
                psApp.setInt(1, patientId);
                ResultSet rsApp = psApp.executeQuery();
                
                while (rsApp.next()) {
                    Map<String, String> app = new HashMap<>();
                    app.put("number", rsApp.getString("appointment_number"));
                    app.put("date", rsApp.getString("appointment_date"));
                    app.put("time", rsApp.getString("appointment_time"));
                    app.put("dentist", rsApp.getString("dentist_name"));
                    app.put("treatment", rsApp.getString("treatment_name"));
                    app.put("status", rsApp.getString("status"));
                    appointments.add(app);
                }
            } else {
                errorMsg = "No patient found with that contact number.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "Database Error: " + e.getMessage();
        }
    }
%>

<style>
    .content-wrapper {
        background: rgba(255, 255, 255, 0.06);
        backdrop-filter: blur(16px);
        border-radius: 18px;
        padding: 32px 36px;
        border: 1px solid rgba(255, 255, 255, 0.06);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        max-width: 100%;
        margin: 0;
    }

    .page-header {
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }

    .page-header h2 {
        color: #FFFFFF;
        font-size: 24px;
        font-weight: 600;
    }

    .page-header p {
        color: rgba(255, 255, 255, 0.4);
        font-size: 14px;
        margin-top: 6px;
    }

    .search-box {
        display: flex;
        gap: 10px;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
    }

    .search-box input {
        flex: 1;
        min-width: 250px;
        padding: 12px 16px;
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 10px;
        background: rgba(255, 255, 255, 0.04);
        color: #FFFFFF;
        font-size: 15px;
        font-family: 'Times New Roman', Times, serif;
    }

    .search-box input:focus {
        outline: none;
        border-color: #3D83C7;
        box-shadow: 0 0 0 3px rgba(61, 131, 199, 0.15);
        background: rgba(255, 255, 255, 0.06);
    }

    .search-box input::placeholder {
        color: rgba(255, 255, 255, 0.25);
    }

    .btn-search {
        background: rgba(61, 131, 199, 0.8);
        color: white;
        padding: 12px 28px;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
        font-size: 15px;
        font-family: 'Times New Roman', Times, serif;
        transition: background 0.3s;
        white-space: nowrap;
    }

    .btn-search:hover {
        background: #3D83C7;
    }

    .patient-info {
        background: rgba(255, 255, 255, 0.04);
        border-radius: 10px;
        padding: 16px 20px;
        margin-bottom: 20px;
        display: flex;
        gap: 30px;
        flex-wrap: wrap;
    }

    .patient-info .label {
        color: rgba(255, 255, 255, 0.5);
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .patient-info .value {
        color: #FFFFFF;
        font-size: 16px;
        font-weight: 600;
    }

    .table-container {
        overflow-x: auto;
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

    .status-badge {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        color: white;
        display: inline-block;
    }
    .status-SCHEDULED { background: #3D83C7; }
    .status-COMPLETED { background: #27AE60; }
    .status-CANCELLED { background: #C0392B; }
    .status-NO-SHOW { background: #E67E22; }

    .msg {
        padding: 14px 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        font-weight: 500;
        text-align: center;
    }
    .msg-success { background: rgba(46, 204, 113, 0.15); color: #2ecc71; border: 1px solid rgba(46, 204, 113, 0.15); }
    .msg-error { background: rgba(231, 76, 60, 0.15); color: #e74c3c; border: 1px solid rgba(231, 76, 60, 0.15); }
    .msg-info { background: rgba(61, 131, 199, 0.15); color: #3D83C7; border: 1px solid rgba(61, 131, 199, 0.15); }

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

    @media (max-width: 768px) {
        .content-wrapper { padding: 20px; }
        .search-box { flex-direction: column; align-items: stretch; }
        .search-box input { min-width: auto; }
        .patient-info { flex-direction: column; gap: 10px; }
    }
</style>

<div class="content-wrapper">

    <div class="page-header">
        <h2> View Appointments</h2>
        <p>Search patient by contact number to view their appointment history</p>
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

    
    <form action="UserLayoutServlet" method="get">
        <input type="hidden" name="page" value="view-appointments">
        <div class="search-box">
            <input type="text" name="searchContact" placeholder="Enter patient contact number..." value="<%= searchContact != null ? searchContact : "" %>">
            <button type="submit" class="btn-search"> Search</button>
        </div>
    </form>

    <%
        if (searchContact != null && !searchContact.trim().isEmpty()) {
            if (!appointments.isEmpty()) {
    %>
        
        <div class="patient-info">
            <div>
                <div class="label">Patient Name</div>
                <div class="value"><%= patientName %></div>
            </div>
            <div>
                <div class="label">Contact Number</div>
                <div class="value"><%= patientContact %></div>
            </div>
            <div>
                <div class="label">Total Appointments</div>
                <div class="value"><%= appointments.size() %></div>
            </div>
        </div>

        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Appointment No</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Dentist</th>
                        <th>Treatment</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Map<String, String> app : appointments) {
                            String status = app.get("status");
                            String badgeClass = "status-" + status.toUpperCase();
                    %>
                    <tr>
                        <td><strong><%= app.get("number") %></strong></td>
                        <td><%= app.get("date") %></td>
                        <td><%= app.get("time") %></td>
                        <td><%= app.get("dentist") %></td>
                        <td><%= app.get("treatment") %></td>
                        <td><span class="status-badge <%= badgeClass %>"><%= status %></span></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    <%
            } else {
    %>
        <div class="msg msg-info">
            No appointments found for this patient.
        </div>
    <%
            }
        } else {
    %>
        <div class="empty-state">
            <span class="icon"></span>
            Enter a patient's contact number above to view their appointment history.
        </div>
    <%
        }
    %>

</div>