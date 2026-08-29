<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
%>

<style>
    .welcome-card {
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.08);
        color: white;
        border-radius: 18px;
        padding: 28px 32px;
        margin-bottom: 22px;
        min-height: 110px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .welcome-content h2 {
        font-size: 25px;
        font-weight: 650;
        margin-bottom: 5px;
        color: #FFFFFF;
    }

    .welcome-content p {
        color: rgba(255, 255, 255, 0.8);
        font-size: 14px;
        line-height: 1.6;
    }

    .welcome-content p strong {
        color: #FFFFFF;
    }

    .dashboard-grid {
        display: grid;
        grid-template-columns: 1.35fr 0.65fr;
        gap: 22px;
    }

    .card {
        background: rgba(255, 255, 255, 0.06);
        backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 18px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
    }

    .card-header {
        padding: 24px 26px 16px;
    }

    .card-header h3 {
        font-size: 18px;
        font-weight: 650;
        color: #FFFFFF;
    }

    .card-header p {
        margin-top: 5px;
        color: rgba(255, 255, 255, 0.4);
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
        background: rgba(255, 255, 255, 0.04);
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 14px;
        padding: 22px;
        text-decoration: none;
        color: #FFFFFF;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        transition: all 0.2s ease;
    }

    .quick-link:hover {
        transform: translateY(-3px);
        border-color: rgba(61, 131, 199, 0.4);
        background: rgba(255, 255, 255, 0.1);
        box-shadow: 0 8px 22px rgba(0, 0, 0, 0.2);
    }

    .quick-icon {
        width: 45px;
        height: 45px;
        border-radius: 12px;
        background: rgba(255, 255, 255, 0.08);
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
        color: #FFFFFF;
    }

    .quick-link small {
        color: rgba(255, 255, 255, 0.4);
        font-size: 12px;
        margin-top: 5px;
    }

    .info-card {
        padding-bottom: 20px;
    }

    .info-row {
        padding: 17px 26px;
        border-top: 1px solid rgba(255, 255, 255, 0.06);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .info-label {
        color: rgba(255, 255, 255, 0.5);
        font-size: 13px;
    }

    .info-value {
        color: #FFFFFF;
        font-size: 13px;
        font-weight: 600;
        text-align: right;
    }

    .role-value {
        background: rgba(61, 131, 199, 0.2);
        color: #3D83C7;
        padding: 5px 11px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 600;
        text-transform: uppercase;
    }

    @media (max-width: 900px) {
        .dashboard-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="welcome-card">
    <div class="welcome-content">
        <h2>Welcome, <%= username %>!</h2>
        <p>You are logged in as <strong><%= role %></strong>. Manage your daily tasks from here.</p>
    </div>
</div>

<div class="dashboard-grid">

    <div class="card">
        <div class="card-header">
            <h3>Quick Actions</h3>
            <p>Access your frequently used options</p>
        </div>
        <div class="quick-actions">
            <a href="UserLayoutServlet?page=book-appointment" class="quick-link">
                <div class="quick-icon">+</div>
                <div>
                    <span>Book an Appointment</span>
                    <small>Schedule a new patient appointment</small>
                </div>
            </a>
        </div>
    </div>

    <div class="card info-card">
        <div class="card-header">
            <h3>Account Information</h3>
            <p>Current session details</p>
        </div>
        <div class="info-row">
            <span class="info-label">Username</span>
            <span class="info-value"><%= username %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Role</span>
            <span class="role-value"><%= role %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Status</span>
            <span class="info-value">Active</span>
        </div>
    </div>

</div>