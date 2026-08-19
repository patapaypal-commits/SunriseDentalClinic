package com.sunrise.dao;

import com.sunrise.model.Patient;
import java.sql.*;

public class PatientDAO {
    private Connection connection = DatabaseConnection.getInstance().getConnection();

    public int savePatient(Patient patient) {
        String query = "INSERT INTO patients (name, address, contact_number) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, patient.getName());
            ps.setString(2, patient.getAddress());
            ps.setString(3, patient.getContactNumber());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }
}