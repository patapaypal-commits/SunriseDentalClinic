package com.sunrise.servlet;

import com.sunrise.service.PatientService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

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
}