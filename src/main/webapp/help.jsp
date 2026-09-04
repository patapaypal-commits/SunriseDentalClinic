<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
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

    .help-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .help-card {
        background: rgba(255, 255, 255, 0.04);
        border-radius: 14px;
        padding: 22px 24px;
        border: 1px solid rgba(255, 255, 255, 0.04);
        transition: all 0.2s ease;
    }

    .help-card:hover {
        background: rgba(255, 255, 255, 0.06);
        border-color: rgba(61, 131, 199, 0.2);
        transform: translateY(-2px);
    }

    .help-card .step-number {
        display: inline-block;
        background: rgba(61, 131, 199, 0.2);
        color: #3D83C7;
        font-size: 12px;
        font-weight: 700;
        padding: 2px 12px;
        border-radius: 20px;
        margin-bottom: 10px;
        letter-spacing: 0.5px;
    }

    .help-card h3 {
        color: #FFFFFF;
        font-size: 17px;
        font-weight: 600;
        margin-bottom: 8px;
    }

    .help-card p {
        color: rgba(255, 255, 255, 0.5);
        font-size: 14px;
        line-height: 1.6;
        margin-bottom: 6px;
    }

    .help-card ul {
        list-style: none;
        padding: 0;
        margin-top: 8px;
    }

    .help-card ul li {
        color: rgba(255, 255, 255, 0.4);
        font-size: 13px;
        padding: 4px 0 4px 20px;
        position: relative;
        line-height: 1.5;
    }

    .help-card ul li::before {
        content: "▸";
        position: absolute;
        left: 0;
        color: #3D83C7;
        font-weight: 700;
    }

    .help-card .icon {
        font-size: 28px;
        margin-bottom: 8px;
        display: block;
    }

    .help-card .highlight {
        color: #3D83C7;
        font-weight: 600;
    }

    @media (max-width: 768px) {
        .help-grid {
            grid-template-columns: 1fr;
        }
        .content-wrapper {
            padding: 20px;
        }
    }
</style>

<div class="content-wrapper">

    <div class="page-header">
        <h2>📖 Help & User Guide</h2>
        <p>Step-by-step instructions for using the Sunrise Dental Clinic System</p>
    </div>

    <div class="help-grid">

        
        <div class="help-card">
            <span class="step-number">Step 1</span>
            <span class="icon">🔑</span>
            <h3>Login to the System</h3>
            <p>Access your account to start managing clinic operations.</p>
            <ul>
                <li>Open the <span class="highlight">Login Page</span></li>
                <li>Enter your <span class="highlight">Username</span> and <span class="highlight">Password</span></li>
                <li>Click the <span class="highlight">Login</span> button</li>
                <li>You will be redirected to your Dashboard</li>
            </ul>
        </div>

       
        <div class="help-card">
            <span class="step-number">Step 2</span>
            <span class="icon">📊</span>
            <h3>Dashboard Overview</h3>
            <p>View your dashboard and access all features from one place.</p>
            <ul>
                <li><span class="highlight">Quick Actions</span> - Access frequently used features</li>
                <li><span class="highlight">Sidebar Menu</span> - Navigate to all system features</li>
                <li>Click <span class="highlight">Logout</span> to safely exit the system</li>
            </ul>
        </div>

        
        <div class="help-card">
            <span class="step-number">Step 3</span>
            <span class="icon">📅</span>
            <h3>Book an Appointment</h3>
            <p>Schedule a new patient appointment quickly and easily.</p>
            <ul>
                <li>Click <span class="highlight">Book Appointment</span> from the sidebar</li>
                <li>Select <span class="highlight">Existing Patient</span> or <span class="highlight">New Patient</span></li>
                <li>For existing patient, <span class="highlight">search by contact number</span></li>
                <li>Select <span class="highlight">Dentist</span>, <span class="highlight">Treatment</span>, <span class="highlight">Date</span> and <span class="highlight">Time</span></li>
                <li>Click <span class="highlight">Book Appointment</span> to confirm</li>
                <li>Appointment number will be automatically generated</li>
            </ul>
        </div>

        
        <div class="help-card">
            <span class="step-number">Step 4</span>
            <span class="icon">📋</span>
            <h3>View Appointments</h3>
            <p>View appointment history for any patient.</p>
            <ul>
                <li>Click <span class="highlight">View Appointments</span> from the sidebar</li>
                <li>Enter the patient's <span class="highlight">Contact Number</span></li>
                <li>Click <span class="highlight">Search</span> to view all appointments</li>
                <li>See appointment details: <span class="highlight">Date, Time, Dentist, Treatment, Status</span></li>
                <li>Status indicates <span class="highlight">Scheduled, Completed, or Cancelled</span></li>
            </ul>
        </div>

        
        <div class="help-card">
            <span class="step-number">Step 5</span>
            <span class="icon">🧾</span>
            <h3>View & Pay Bills</h3>
            <p>Manage patient bills and process payments.</p>
            <ul>
                <li>Click <span class="highlight">View Bills</span> from the sidebar</li>
                <li>Search by <span class="highlight">Appointment Number</span></li>
                <li>View bill details: <span class="highlight">Patient, Treatment, Dentist, Total Amount</span></li>
                <li>For unpaid bills, click <span class="highlight">Pay Now</span> to process payment</li>
                <li>After payment, click <span class="highlight">View Bill</span> to see paid receipt</li>
                <li>Click <span class="highlight">Print Receipt</span> to download or print</li>
            </ul>
        </div>

        
        <div class="help-card">
            <span class="step-number">Step 6</span>
            <span class="icon">🚪</span>
            <h3>Logout & Security</h3>
            <p>Always logout securely after your session.</p>
            <ul>
                <li>Click <span class="highlight">Log Out</span> from the sidebar</li>
                <li>Always logout when you finish your work</li>
                <li>Close your browser to end the session completely</li>
                <li>Contact your administrator if you forget your password</li>
            </ul>
        </div>

    </div>

    
    <div style="margin-top: 25px; padding: 16px 20px; background: rgba(61, 131, 199, 0.08); border-radius: 12px; border: 1px solid rgba(61, 131, 199, 0.1);">
        <p style="color: rgba(255, 255, 255, 0.4); font-size: 13px; text-align: center;">
            💡 <strong style="color: #3D83C7;">Need more help?</strong> Contact your system administrator for further assistance.
        </p>
    </div>

</div>