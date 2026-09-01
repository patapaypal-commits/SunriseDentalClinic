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

@WebServlet("/PayBillServlet")
public class PayBillServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String appointmentNo = request.getParameter("appointmentNo");
        String action = request.getParameter("action");

        if (appointmentNo == null || appointmentNo.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Invalid appointment number!");
            response.sendRedirect("UserLayoutServlet?page=view-bills");
            return;
        }

        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();

           
            PreparedStatement ps = conn.prepareStatement(
                "SELECT a.appointment_number, a.appointment_date, a.appointment_time, " +
                "a.consultation_fee, a.payment_status, " +
                "p.name AS patient_name, p.address, p.contact_number, " +
                "d.name AS dentist_name, " +
                "t.type AS treatment_name, t.base_cost AS treatment_cost " +
                "FROM appointments a " +
                "JOIN patients p ON a.patient_id = p.patient_id " +
                "JOIN dentists d ON a.dentist_id = d.dentist_id " +
                "JOIN treatments t ON a.treatment_id = t.treatment_id " +
                "WHERE a.appointment_number = ?"
            );
            ps.setString(1, appointmentNo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                
                String patientName = rs.getString("patient_name");
                String address = rs.getString("address");
                String contact = rs.getString("contact_number");
                String dentist = rs.getString("dentist_name");
                String treatment = rs.getString("treatment_name");
                double treatmentCost = rs.getDouble("treatment_cost");
                double consultationFee = rs.getDouble("consultation_fee");
                double total = treatmentCost + consultationFee;
                String date = rs.getString("appointment_date");
                String time = rs.getString("appointment_time");
                String paymentStatus = rs.getString("payment_status");

                
                if ("pay".equalsIgnoreCase(action) && "UNPAID".equalsIgnoreCase(paymentStatus)) {
                    PreparedStatement psUpdate = conn.prepareStatement(
                        "UPDATE appointments SET payment_status = 'PAID' WHERE appointment_number = ?"
                    );
                    psUpdate.setString(1, appointmentNo);
                    psUpdate.executeUpdate();
                    
                   
                    paymentStatus = "PAID";
                    
                    session.setAttribute("successMsg", "Payment successful for appointment " + appointmentNo);
                }

                
                session.setAttribute("receiptAppNo", appointmentNo);
                session.setAttribute("receiptPatient", patientName);
                session.setAttribute("receiptAddress", address);
                session.setAttribute("receiptContact", contact);
                session.setAttribute("receiptDentist", dentist);
                session.setAttribute("receiptTreatment", treatment);
                session.setAttribute("receiptCost", String.format("%.2f", treatmentCost));
                session.setAttribute("receiptConsultation", String.format("%.2f", consultationFee));
                session.setAttribute("receiptTotal", String.format("%.2f", total));
                session.setAttribute("receiptDate", date);
                session.setAttribute("receiptTime", time);
                session.setAttribute("receiptStatus", paymentStatus);

                
                response.sendRedirect("receipt-page.jsp");

            } else {
                session.setAttribute("errorMsg", "Appointment not found!");
                response.sendRedirect("UserLayoutServlet?page=view-bills");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database Error: " + e.getMessage());
            response.sendRedirect("UserLayoutServlet?page=view-bills");
        }
    }
}