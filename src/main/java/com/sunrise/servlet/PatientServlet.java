package com.sunrise.servlet;

import com.sunrise.service.PatientService;
import com.sunrise.dao.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.HttpSession;

@WebServlet("/PatientServlet")
public class PatientServlet extends HttpServlet {

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        try {
            PatientService service = new PatientService();
            int newId = service.registerPatient(name, address, contact);
            request.setAttribute("msgType", "success");
            request.setAttribute("msg", "Patient Registered! ID: " + newId);
        } catch (Exception e) {
            request.setAttribute("msgType", "error");
            request.setAttribute("msg", "error" + e.getMessage());
        }
        request.getRequestDispatcher("register-patient.jsp").forward(request, response);
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
                PreparedStatement ps = conn.prepareStatement("DELETE FROM patients WHERE patient_id=?");
                ps.setInt(1, id);
                ps.executeUpdate();
                request.setAttribute("successMsg", "Patient deleted successfully!");
            }

            request.getRequestDispatcher("view-patients.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("view-patients.jsp").forward(request, response);
        }
    }
}