package com.sunrise.servlet;

import com.sunrise.dao.AppointmentDAO;
import com.sunrise.service.AppointmentService;
import com.sunrise.model.Patient;
import com.sunrise.dao.PatientDAO;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String patientType = request.getParameter("patientType");
            int patientId = 0;

            
            if ("new".equals(patientType)) {
                String name = request.getParameter("newPatientName");
                String contact = request.getParameter("newPatientContact");
                String address = request.getParameter("newPatientAddress");

                if (name == null || name.trim().isEmpty()) {
                    session.setAttribute("errorMsg", "Please enter patient name.");
                    response.sendRedirect("UserLayoutServlet?page=book-appointment");
                    return;
                }

                Patient patient = new Patient();
                patient.setName(name.trim());
                patient.setContactNumber(contact != null ? contact.trim() : "");
                patient.setAddress(address != null ? address.trim() : "");

                PatientDAO patientDAO = new PatientDAO();
                patientId = patientDAO.savePatient(patient);
                if (patientId == -1) {
                    session.setAttribute("errorMsg", "Failed to save new patient!");
                    response.sendRedirect("UserLayoutServlet?page=book-appointment");
                    return;
                }
                session.setAttribute("successMsg", "New patient registered! ID: " + patientId);
            } else {
                
                String selectedId = request.getParameter("selectedPatientId");
                if (selectedId == null || selectedId.isEmpty()) {
                    session.setAttribute("errorMsg", "Please search and select a patient.");
                    response.sendRedirect("UserLayoutServlet?page=book-appointment");
                    return;
                }
                patientId = Integer.parseInt(selectedId);
            }

            
            int dentistId = Integer.parseInt(request.getParameter("dentistId"));
            int treatmentId = Integer.parseInt(request.getParameter("treatmentId"));
            Date date = Date.valueOf(request.getParameter("appointmentDate"));
            Time time = Time.valueOf(request.getParameter("appointmentTime") + ":00");
            String appointmentNumber = request.getParameter("appointmentNumber");

            
            AppointmentService service = new AppointmentService();
            String result = service.bookAppointment(patientId, dentistId, treatmentId, date, time);

            session.setAttribute("successMsg", "Appointment booked! Number: " + result);
            response.sendRedirect("UserLayoutServlet?page=book-appointment");

        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMsg", e.getMessage());
            response.sendRedirect("UserLayoutServlet?page=book-appointment");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database Error: " + e.getMessage());
            response.sendRedirect("UserLayoutServlet?page=book-appointment");
        }
    }
}