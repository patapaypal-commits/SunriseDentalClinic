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

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }

    // SEARCH BY CONTACT NUMBER ONLY
    String searchQuery = request.getParameter("searchQuery");
    List<Map<String, String>> patientResults = new ArrayList<>();
    String selectedPatientId = request.getParameter("selectedPatientId");
    String selectedPatientName = "";
    String selectedPatientContact = "";

    // Search for patients - CONTACT NUMBER ONLY
    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT patient_id, name, contact_number FROM patients WHERE contact_number LIKE ? LIMIT 10"
            );
            ps.setString(1, "%" + searchQuery.trim() + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> patient = new HashMap<>();
                patient.put("id", String.valueOf(rs.getInt("patient_id")));
                patient.put("name", rs.getString("name"));
                patient.put("contact", rs.getString("contact_number"));
                patientResults.add(patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // If patient selected, get details
    if (selectedPatientId != null && !selectedPatientId.isEmpty()) {
        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT name, contact_number FROM patients WHERE patient_id=?"
            );
            ps.setInt(1, Integer.parseInt(selectedPatientId));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                selectedPatientName = rs.getString("name");
                selectedPatientContact = rs.getString("contact_number");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Generate appointment number
    String appointmentNumber = "APP-001";
    try {
        Connection conn = DatabaseConnection.getInstance().getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT MAX(appointment_number) FROM appointments");
        if (rs.next() && rs.getString(1) != null) {
            String last = rs.getString(1);
            int num = Integer.parseInt(last.replace("APP-", "")) + 1;
            appointmentNumber = String.format("APP-%03d", num);
        }
    } catch (Exception e) {
        e.printStackTrace();
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

    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group.full-width {
        grid-column: 1 / -1;
    }

    .form-group label {
        color: rgba(255, 255, 255, 0.7);
        font-weight: 600;
        font-size: 14px;
        display: block;
        margin-bottom: 6px;
    }

    .form-group input, .form-group select {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 10px;
        font-size: 15px;
        transition: border-color 0.3s, box-shadow 0.3s;
        background: rgba(255, 255, 255, 0.04);
        color: #FFFFFF;
        font-family: 'Times New Roman', Times, serif;
    }

    .form-group input:focus, .form-group select:focus {
        outline: none;
        border-color: #3D83C7;
        box-shadow: 0 0 0 3px rgba(61, 131, 199, 0.15);
        background: rgba(255, 255, 255, 0.06);
    }

    .form-group input::placeholder {
        color: rgba(255, 255, 255, 0.25);
    }

    .form-group select option {
        background-color: #1A1A2E;
        color: #FFFFFF;
    }

    .form-group input:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    .patient-type-group {
        display: flex;
        gap: 20px;
        margin-bottom: 10px;
    }

    .patient-type-group label {
        color: rgba(255, 255, 255, 0.6);
        font-weight: 400;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .patient-type-group input[type="radio"] {
        width: 16px;
        height: 16px;
        accent-color: #3D83C7;
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
        transition: background 0.3s;
        width: 100%;
        margin-top: 4px;
    }

    .btn-submit:hover {
        background: #3D83C7;
    }

    .btn-secondary {
        background: rgba(255, 255, 255, 0.06);
        color: white;
        padding: 10px 20px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        transition: background 0.3s;
    }

    .btn-secondary:hover {
        background: rgba(255, 255, 255, 0.12);
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

    .search-results {
        background: rgba(255, 255, 255, 0.04);
        border-radius: 10px;
        max-height: 150px;
        overflow-y: auto;
        margin-top: 8px;
        border: 1px solid rgba(255, 255, 255, 0.04);
    }

    .search-result-item {
        padding: 10px 16px;
        color: rgba(255, 255, 255, 0.8);
        border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .search-result-item:hover {
        background: rgba(61, 131, 199, 0.15);
        color: #FFFFFF;
    }

    .search-result-item .select-btn {
        background: rgba(61, 131, 199, 0.2);
        color: #3D83C7;
        padding: 4px 14px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        border: none;
        cursor: pointer;
    }

    .search-result-item .select-btn:hover {
        background: #3D83C7;
        color: white;
    }

    .readonly-display {
        background: rgba(61, 131, 199, 0.08) !important;
        border-color: rgba(61, 131, 199, 0.15) !important;
        color: #3D83C7 !important;
        font-weight: 600 !important;
        cursor: default !important;
    }

    .hidden {
        display: none !important;
    }

    .patient-search-box {
        display: flex;
        gap: 10px;
        align-items: center;
    }

    .patient-search-box input {
        flex: 1;
    }

    /* NEW: Container for search section to hide/show */
    #searchSection {
        transition: all 0.3s ease;
    }

    @media (max-width: 768px) {
        .form-grid {
            grid-template-columns: 1fr;
        }
        .content-wrapper {
            padding: 20px;
        }
        .patient-type-group {
            flex-wrap: wrap;
        }
        .patient-search-box {
            flex-wrap: wrap;
        }
    }
</style>

<div class="content-wrapper">

    <div class="page-header">
        <h2>Book an Appointment</h2>
        <p>Schedule a new patient appointment</p>
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

    <!-- SEARCH FORM - WRAPPED IN DIV WITH ID -->
    <div id="searchSection">
        <form action="UserLayoutServlet" method="get">
            <input type="hidden" name="page" value="book-appointment">
            <div class="form-group">
                <label>Search Patient (by Contact Number)</label>
                <div class="patient-search-box">
                    <input type="text" name="searchQuery" placeholder="Type contact number..." value="<%= searchQuery != null ? searchQuery : "" %>">
                    <button type="submit" class="btn-secondary">Search</button>
                </div>
            </div>
        </form>

        <!-- SEARCH RESULTS -->
        <%
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        %>
            <div class="search-results" style="display: block;">
                <%
                    if (patientResults.isEmpty()) {
                %>
                    <div class="search-result-item" style="color: rgba(255,255,255,0.4); justify-content: center;">No patients found. Please register a new patient.</div>
                <%
                    } else {
                        for (Map<String, String> p : patientResults) {
                %>
                    <div class="search-result-item">
                        <span><strong><%= p.get("name") %></strong> (ID: <%= p.get("id") %>) - <%= p.get("contact") %></span>
                        <form action="UserLayoutServlet" method="get" style="margin: 0;">
                            <input type="hidden" name="page" value="book-appointment">
                            <input type="hidden" name="selectedPatientId" value="<%= p.get("id") %>">
                            <button type="submit" class="select-btn">Select</button>
                        </form>
                    </div>
                <%
                        }
                    }
                %>
            </div>
        <%
            }
        %>
    </div>

    <!-- MAIN BOOKING FORM -->
    <form action="AppointmentServlet" method="post">

        <!-- Appointment Number -->
        <div class="form-group">
            <label>Appointment Number</label>
            <input type="text" value="<%= appointmentNumber %>" disabled class="readonly-display">
            <input type="hidden" name="appointmentNumber" value="<%= appointmentNumber %>">
        </div>

        <!-- Patient Type -->
        <div class="form-group">
            <label>Patient Type</label>
            <div class="patient-type-group">
                <label>
                    <input type="radio" name="patientType" value="existing" checked onclick="togglePatientType('existing')"> Existing Patient
                </label>
                <label>
                    <input type="radio" name="patientType" value="new" onclick="togglePatientType('new')"> New Patient
                </label>
            </div>
        </div>

        <!-- Existing Patient Section -->
        <div id="existingSection">
            <input type="hidden" name="selectedPatientId" id="selectedPatientId" value="<%= selectedPatientId != null ? selectedPatientId : "" %>">
            <div class="form-grid">
                <div class="form-group">
                    <label>Patient Name</label>
                    <input type="text" id="patientNameDisplay" value="<%= selectedPatientName %>" placeholder="Search and select patient" readonly style="background: rgba(255,255,255,0.02); cursor: default;">
                </div>
                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="text" id="patientContactDisplay" value="<%= selectedPatientContact %>" placeholder="Contact will appear here" readonly style="background: rgba(255,255,255,0.02); cursor: default;">
                </div>
            </div>
        </div>

        <!-- New Patient Section -->
        <div id="newSection" class="hidden">
            <div class="form-grid">
                <div class="form-group">
                    <label>Patient Name</label>
                    <input type="text" name="newPatientName" id="newPatientName" placeholder="Enter patient name">
                </div>
                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="text" name="newPatientContact" id="newPatientContact" placeholder="Enter contact number">
                </div>
            </div>
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="newPatientAddress" id="newPatientAddress" placeholder="Enter address">
            </div>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label>Dentist</label>
                <select name="dentistId" required>
                    <option value="">-- Select Dentist --</option>
                    <%
                        Connection conn = DatabaseConnection.getInstance().getConnection();
                        PreparedStatement ps2 = conn.prepareStatement("SELECT dentist_id, name, specialization FROM dentists");
                        ResultSet rs2 = ps2.executeQuery();
                        while (rs2.next()) {
                    %>
                        <option value="<%= rs2.getInt("dentist_id") %>">
                            <%= rs2.getString("name") %> - <%= rs2.getString("specialization") %>
                        </option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label>Treatment</label>
                <select name="treatmentId" required>
                    <option value="">-- Select Treatment --</option>
                    <%
                        PreparedStatement ps3 = conn.prepareStatement("SELECT treatment_id, type, base_cost FROM treatments");
                        ResultSet rs3 = ps3.executeQuery();
                        while (rs3.next()) {
                    %>
                        <option value="<%= rs3.getInt("treatment_id") %>">
                            <%= rs3.getString("type") %> - Rs. <%= rs3.getDouble("base_cost") %>
                        </option>
                    <%
                        }
                    %>
                </select>
            </div>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label>Appointment Date</label>
                <input type="date" name="appointmentDate" required min="<%= java.time.LocalDate.now() %>">
            </div>
            <div class="form-group">
                <label>Appointment Time</label>
                <input type="time" name="appointmentTime" required>
            </div>
        </div>

        <button type="submit" class="btn-submit">Book Appointment</button>

    </form>

</div>

<script>
    function togglePatientType(type) {
        const existingSection = document.getElementById('existingSection');
        const newSection = document.getElementById('newSection');
        const searchSection = document.getElementById('searchSection');

        if (type === 'existing') {
            existingSection.classList.remove('hidden');
            newSection.classList.add('hidden');
            searchSection.style.display = 'block';
            document.getElementById('newPatientName').required = false;
            document.getElementById('newPatientContact').required = false;
            document.getElementById('newPatientAddress').required = false;
        } else {
            existingSection.classList.add('hidden');
            newSection.classList.remove('hidden');
            searchSection.style.display = 'none';
            document.getElementById('newPatientName').required = true;
            document.getElementById('newPatientContact').required = true;
            document.getElementById('newPatientAddress').required = true;
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const radios = document.querySelectorAll('input[name="patientType"]');
        radios.forEach(function(radio) {
            if (radio.checked) {
                togglePatientType(radio.value);
            }
        });
    });
</script>