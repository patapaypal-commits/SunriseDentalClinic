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

    String searchAppNo = request.getParameter("searchAppNo");
    List<Map<String, String>> bills = new ArrayList<>();
    String errorMsg = (String) session.getAttribute("errorMsg");
    String successMsg = (String) session.getAttribute("successMsg");
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }
    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }

    if (searchAppNo != null && !searchAppNo.trim().isEmpty()) {
        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT a.appointment_number, a.appointment_date, a.appointment_time, " +
                "a.status, a.payment_status, a.consultation_fee, " +
                "p.name AS patient_name, p.contact_number, " +
                "d.name AS dentist_name, t.type AS treatment_name, t.base_cost AS treatment_cost " +
                "FROM appointments a " +
                "JOIN patients p ON a.patient_id = p.patient_id " +
                "JOIN dentists d ON a.dentist_id = d.dentist_id " +
                "JOIN treatments t ON a.treatment_id = t.treatment_id " +
                "WHERE a.appointment_number LIKE ?"
            );
            ps.setString(1, "%" + searchAppNo.trim() + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> bill = new HashMap<>();
                bill.put("appointmentNo", rs.getString("appointment_number"));
                bill.put("patientName", rs.getString("patient_name"));
                bill.put("contact", rs.getString("contact_number"));
                bill.put("dentist", rs.getString("dentist_name"));
                bill.put("treatment", rs.getString("treatment_name"));
                bill.put("treatmentCost", String.valueOf(rs.getDouble("treatment_cost")));
                bill.put("consultationFee", String.valueOf(rs.getDouble("consultation_fee")));
                double total = rs.getDouble("treatment_cost") + rs.getDouble("consultation_fee");
                bill.put("total", String.format("%.2f", total));
                bill.put("date", rs.getString("appointment_date"));
                bill.put("time", rs.getString("appointment_time"));
                bill.put("status", rs.getString("status"));
                bill.put("paymentStatus", rs.getString("payment_status"));
                bills.add(bill);
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

    .btn-pay {
        background: rgba(46, 204, 113, 0.8);
        color: white;
        padding: 6px 18px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 600;
        font-size: 13px;
        font-family: 'Times New Roman', Times, serif;
        transition: background 0.3s;
        text-decoration: none;
        display: inline-block;
    }

    .btn-pay:hover {
        background: #27AE60;
    }

    .btn-view {
        background: rgba(61, 131, 199, 0.6);
        color: white;
        padding: 6px 18px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 600;
        font-size: 13px;
        font-family: 'Times New Roman', Times, serif;
        transition: background 0.3s;
        text-decoration: none;
        display: inline-block;
    }

    .btn-view:hover {
        background: rgba(61, 131, 199, 0.9);
    }

    .btn-paid {
        background: rgba(255, 255, 255, 0.06);
        color: rgba(255, 255, 255, 0.3);
        padding: 6px 18px;
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 6px;
        font-weight: 600;
        font-size: 13px;
        display: inline-block;
        cursor: default;
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

    .payment-badge {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        color: white;
        display: inline-block;
    }
    .payment-PAID { background: #27AE60; }
    .payment-UNPAID { background: #E67E22; }

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

    .amount {
        color: #2ecc71;
        font-weight: 600;
    }

    @media (max-width: 768px) {
        .content-wrapper { padding: 20px; }
        .search-box { flex-direction: column; align-items: stretch; }
        .search-box input { min-width: auto; }
    }
</style>

<div class="content-wrapper">

    <div class="page-header">
        <h2> View Bills</h2>
        <p>Search by appointment number to view and pay bills</p>
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
        <input type="hidden" name="page" value="view-bills">
        <div class="search-box">
            <input type="text" name="searchAppNo" placeholder="Enter appointment number (e.g., APP-001)..." value="<%= searchAppNo != null ? searchAppNo : "" %>">
            <button type="submit" class="btn-search">Search</button>
        </div>
    </form>

    <%
        if (searchAppNo != null && !searchAppNo.trim().isEmpty()) {
            if (!bills.isEmpty()) {
    %>

   
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Appointment No</th>
                    <th>Patient</th>
                    <th>Treatment</th>
                    <th>Dentist</th>
                    <th>Date</th>
                    <th>Total (Rs.)</th>
                    <th>Status</th>
                    <th>Payment</th>
                    <th style="text-align:center;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Map<String, String> bill : bills) {
                        String paymentStatus = bill.get("paymentStatus");
                        String appointmentNo = bill.get("appointmentNo");
                %>
                <tr>
                    <td><strong><%= appointmentNo %></strong></td>
                    <td><%= bill.get("patientName") %></td>
                    <td><%= bill.get("treatment") %></td>
                    <td><%= bill.get("dentist") %></td>
                    <td><%= bill.get("date") %></td>
                    <td class="amount">Rs. <%= bill.get("total") %></td>
                    <td><span class="status-badge status-<%= bill.get("status") %>"><%= bill.get("status") %></span></td>
                    <td><span class="payment-badge payment-<%= paymentStatus %>"><%= paymentStatus %></span></td>
                    <td style="text-align:center;">
                        <%
                            if ("UNPAID".equalsIgnoreCase(paymentStatus)) {
                        %>
                            <a href="PayBillServlet?appointmentNo=<%= appointmentNo %>&action=pay" class="btn-pay" onclick="return confirm('Process payment for appointment <%= appointmentNo %>?')">💳 Pay Now</a>
                        <%
                            } else {
                        %>
                            <a href="PayBillServlet?appointmentNo=<%= appointmentNo %>&action=view" class="btn-view"> View Bill</a>
                        <%
                            }
                        %>
                    </td>
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
            No bills found for appointment number: <strong><%= searchAppNo %></strong>
        </div>
    <%
            }
        } else {
    %>
        <div class="empty-state">
            <span class="icon"></span>
            Enter an appointment number above to view the bill.
        </div>
    <%
        }
    %>

</div>