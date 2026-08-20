package com.sunrise.servlet;

import com.sunrise.dao.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE username=? AND password_hash=?");
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", rs.getString("role"));
                
                
                String role = rs.getString("role");
                if (role.equalsIgnoreCase("ADMIN")) {
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    response.sendRedirect("register-patient.jsp");
                }
            } else {
                request.setAttribute("errorMessage", "Invalid Credentials!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database Error!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}