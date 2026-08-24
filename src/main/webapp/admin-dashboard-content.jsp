<%@ page import="java.sql.*" %>
<%@ page import="com.sunrise.dao.DatabaseConnection" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    Connection conn = DatabaseConnection.getInstance().getConnection();
    PreparedStatement psStaff = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role != 'ADMIN'");
    ResultSet rsStaff = psStaff.executeQuery();
    rsStaff.next();
    int totalStaff = rsStaff.getInt(1);

    PreparedStatement psPatients = conn.prepareStatement("SELECT COUNT(*) FROM patients");
    ResultSet rsPatients = psPatients.executeQuery();
    rsPatients.next();
    int totalPatients = rsPatients.getInt(1);
%>

<style>
    .welcome-card { 
        background: rgba(255, 255, 255, 0.12); 
        backdrop-filter: blur(12px); 
        border: 1px solid rgba(255, 255, 255, 0.08); 
        color: white; 
        border-radius: 18px; 
        padding: 28px 32px; 
        margin-bottom: 22px; 
    }
    .welcome-content h2 { 
        font-size: 25px; 
        font-weight: 650; 
        margin-bottom: 8px; 
        color: #FFFFFF; 
    }
    .welcome-content p { 
        color: rgba(255, 255, 255, 0.8); 
        font-size: 14px; 
        line-height: 1.6; 
    }
    .welcome-content p strong { color: #FFFFFF; }
    
    .stats-grid { 
        display: grid; 
        grid-template-columns: repeat(2, 1fr); 
        gap: 22px; 
        margin-bottom: 22px; 
    }
    .stat-card { 
        background: rgba(255, 255, 255, 0.10); 
        backdrop-filter: blur(12px); 
        border: 1px solid rgba(255, 255, 255, 0.08); 
        border-radius: 18px; 
        padding: 26px; 
        display: flex; 
        align-items: center; 
        gap: 20px; 
    }
    .stat-icon { 
        width: 55px; 
        height: 55px; 
        border-radius: 14px; 
        background: rgba(255, 255, 255, 0.12); 
        color: #3D83C7; 
        display: flex; 
        justify-content: center; 
        align-items: center; 
        font-size: 24px; 
        flex-shrink: 0; 
    }
    .stat-info .number { 
        font-size: 30px; 
        font-weight: 700; 
        color: #FFFFFF; 
    }
    .stat-info .label { 
        color: rgba(255, 255, 255, 0.6); 
        font-size: 14px; 
        margin-top: 4px; 
    }
    
    .quick-card { 
        background: rgba(255, 255, 255, 0.10); 
        backdrop-filter: blur(12px); 
        border: 1px solid rgba(255, 255, 255, 0.08); 
        border-radius: 18px; 
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
        color: rgba(255, 255, 255, 0.5); 
        font-size: 13px; 
    }
    .quick-links { 
        padding: 10px 26px 26px; 
        display: grid; 
        grid-template-columns: repeat(3, 1fr); 
        gap: 15px; 
    }
    .quick-link { 
        min-height: 145px; 
        background: rgba(255, 255, 255, 0.06); 
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
        background: rgba(255, 255, 255, 0.12); 
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
        color: rgba(255, 255, 255, 0.5); 
        font-size: 12px; 
        margin-top: 5px; 
        display: block; 
    }
    @media (max-width: 700px) { 
        .quick-links { grid-template-columns: 1fr; } 
        .stats-grid { grid-template-columns: 1fr; } 
    }
</style>

<div class="welcome-card">
    <div class="welcome-content">
        <h2>Welcome, <%= username %>!</h2>
        <p>You are logged in as <strong><%= role %></strong>. Manage your dashboard from here.</p>
    </div>
</div>

<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon"></div>
        <div class="stat-info">
            <div class="number"><%= totalStaff %></div>
            <div class="label">Total Staff</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon"></div>
        <div class="stat-info">
            <div class="number"><%= totalPatients %></div>
            <div class="label">Total Patients</div>
        </div>
    </div>
</div>

<div class="quick-card">
    <div class="card-header">
        <h3>Quick Actions</h3>
        <p>Access your frequently used options</p>
    </div>
    <div class="quick-links">
        <a href="LayoutServlet?page=view-patients" class="quick-link">
            <div class="quick-icon"></div>
            <div>
                <span>View Patients</span>
                <small>View registered patients</small>
            </div>
        </a>
        <a href="LayoutServlet?page=view-staff" class="quick-link">
            <div class="quick-icon"></div>
            <div>
                <span>View Staff</span>
                <small>View staff members</small>
            </div>
        </a>
        <a href="LayoutServlet?page=add-staff" class="quick-link">
            <div class="quick-icon"></div>
            <div>
                <span>Add Staff</span>
                <small>Add a new staff member</small>
            </div>
        </a>
    </div>
</div>