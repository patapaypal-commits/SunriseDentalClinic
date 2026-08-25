package com.sunrise.servlet;

import com.sunrise.dao.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/StaffServlet")
public class StaffServlet extends HttpServlet {

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String employeeId = request.getParameter("employeeId");
        String employeeName = request.getParameter("employeeName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            
            PreparedStatement check = conn.prepareStatement("SELECT * FROM users WHERE username=?");
            check.setString(1, username);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                session.setAttribute("errorMsg", "Username already exists!");
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO users (employee_id, employee_name, username, password_hash, role) VALUES (?, ?, ?, ?, ?)"
                );
                ps.setString(1, employeeId);
                ps.setString(2, employeeName);
                ps.setString(3, username);
                ps.setString(4, password);
                ps.setString(5, "RECEPTIONIST");
                ps.executeUpdate();
                session.setAttribute("successMsg", "Staff added successfully!");
            }

            
            response.sendRedirect("LayoutServlet?page=add-staff");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database Error: " + e.getMessage());
            response.sendRedirect("LayoutServlet?page=add-staff");
        }
    }

  
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();

            if ("delete".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                
                
                PreparedStatement check = conn.prepareStatement("SELECT role FROM users WHERE user_id=?");
                check.setInt(1, id);
                ResultSet rs = check.executeQuery();
                
                if (rs.next() && !"ADMIN".equalsIgnoreCase(rs.getString("role"))) {
                    PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE user_id=?");
                    ps.setInt(1, id);
                    ps.executeUpdate();
                    session.setAttribute("successMsg", "Staff deleted successfully!");
                } else {
                    session.setAttribute("errorMsg", "Cannot delete admin account!");
                }
            }

            
            response.sendRedirect("LayoutServlet?page=view-staff");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database Error: " + e.getMessage());
            response.sendRedirect("LayoutServlet?page=view-staff");
        }
    }
}