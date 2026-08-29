package com.sunrise.dao;

import com.sunrise.model.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    private Connection connection = DatabaseConnection.getInstance().getConnection();

    
    public String generateAppointmentNumber() {
        String query = "SELECT MAX(appointment_number) FROM appointments";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next() && rs.getString(1) != null) {
                String last = rs.getString(1);
                int num = Integer.parseInt(last.replace("APP-", "")) + 1;
                return String.format("APP-%03d", num);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "APP-001";
    }

   
    public boolean isDentistAvailable(int dentistId, Date date, Time time) {
        String query = "SELECT COUNT(*) FROM appointments WHERE dentist_id=? AND appointment_date=? AND appointment_time=? AND status != 'CANCELLED'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, dentistId);
            ps.setDate(2, date);
            ps.setTime(3, time);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

   
    public boolean saveAppointment(Appointment appointment) {
        String query = "INSERT INTO appointments (appointment_number, patient_id, dentist_id, treatment_id, appointment_date, appointment_time, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, appointment.getAppointmentNumber());
            ps.setInt(2, appointment.getPatientId());
            ps.setInt(3, appointment.getDentistId());
            ps.setInt(4, appointment.getTreatmentId());
            ps.setDate(5, appointment.getAppointmentDate());
            ps.setTime(6, appointment.getAppointmentTime());
            ps.setString(7, "SCHEDULED");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}