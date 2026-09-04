package com.sunrise.test;

import com.sunrise.service.AppointmentService;
import com.sunrise.dao.DatabaseConnection;
import org.junit.jupiter.api.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;

public class AppointmentServiceTest {

    private AppointmentService appointmentService;
    private int testPatientId;
    private int testDentistId;
    private int testTreatmentId;

    @BeforeEach
    void setUp() {
        appointmentService = new AppointmentService();

        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();

            // ===== GET OR CREATE A VALID PATIENT =====
            PreparedStatement ps = conn.prepareStatement(
                "SELECT patient_id FROM patients LIMIT 1"
            );
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                testPatientId = rs.getInt("patient_id");
                System.out.println("Using existing patient ID: " + testPatientId);
            } else {
                // Create a new patient if none exists
                ps = conn.prepareStatement(
                    "INSERT INTO patients (name, address, contact_number) VALUES (?, ?, ?)",
                    PreparedStatement.RETURN_GENERATED_KEYS
                );
                ps.setString(1, "Test Patient");
                ps.setString(2, "Test Address");
                ps.setString(3, "071" + String.format("%07d", System.currentTimeMillis() % 10000000));
                ps.executeUpdate();
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    testPatientId = rs.getInt(1);
                    System.out.println("Created new patient ID: " + testPatientId);
                }
            }

            // ===== GET OR CREATE A VALID DENTIST =====
            ps = conn.prepareStatement(
                "SELECT dentist_id FROM dentists LIMIT 1"
            );
            rs = ps.executeQuery();
            if (rs.next()) {
                testDentistId = rs.getInt("dentist_id");
                System.out.println("Using existing dentist ID: " + testDentistId);
            } else {
                ps = conn.prepareStatement(
                    "INSERT INTO dentists (name, specialization) VALUES (?, ?)",
                    PreparedStatement.RETURN_GENERATED_KEYS
                );
                ps.setString(1, "Dr. Test Dentist");
                ps.setString(2, "General Dentistry");
                ps.executeUpdate();
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    testDentistId = rs.getInt(1);
                    System.out.println("Created new dentist ID: " + testDentistId);
                }
            }

            // ===== GET OR CREATE A VALID TREATMENT =====
            ps = conn.prepareStatement(
                "SELECT treatment_id FROM treatments LIMIT 1"
            );
            rs = ps.executeQuery();
            if (rs.next()) {
                testTreatmentId = rs.getInt("treatment_id");
                System.out.println("Using existing treatment ID: " + testTreatmentId);
            } else {
                ps = conn.prepareStatement(
                    "INSERT INTO treatments (type, base_cost) VALUES (?, ?)",
                    PreparedStatement.RETURN_GENERATED_KEYS
                );
                ps.setString(1, "Test Treatment");
                ps.setDouble(2, 5000.00);
                ps.executeUpdate();
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    testTreatmentId = rs.getInt(1);
                    System.out.println("Created new treatment ID: " + testTreatmentId);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            fail("Database setup failed: " + e.getMessage());
        }
    }

    // ===== TEST 1: Valid Appointment Booking =====
    @Test
    @DisplayName("Should book appointment with valid details")
    void testBookAppointment_ValidDetails() {
        Date date = Date.valueOf(LocalDate.now().plusDays(1));
        Time time = Time.valueOf(LocalTime.of(10, 0));

        String result = appointmentService.bookAppointment(
            testPatientId,
            testDentistId,
            testTreatmentId,
            date,
            time
        );

        assertNotNull(result);
        assertTrue(result.startsWith("APP-"));
        System.out.println("Appointment booked: " + result);
    }

    // ===== TEST 2: Invalid Patient ID =====
    @Test
    @DisplayName("Should throw exception for invalid patient ID")
    void testBookAppointment_InvalidPatientId() {
        Date date = Date.valueOf(LocalDate.now().plusDays(1));
        Time time = Time.valueOf(LocalTime.of(10, 0));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            appointmentService.bookAppointment(0, testDentistId, testTreatmentId, date, time);
        });
        assertTrue(exception.getMessage().contains("Please select a patient"));
    }

    // ===== TEST 3: Invalid Dentist ID =====
    @Test
    @DisplayName("Should throw exception for invalid dentist ID")
    void testBookAppointment_InvalidDentistId() {
        Date date = Date.valueOf(LocalDate.now().plusDays(1));
        Time time = Time.valueOf(LocalTime.of(10, 0));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            appointmentService.bookAppointment(testPatientId, 0, testTreatmentId, date, time);
        });
        assertTrue(exception.getMessage().contains("Please select a dentist"));
    }

    // ===== TEST 4: Invalid Treatment ID =====
    @Test
    @DisplayName("Should throw exception for invalid treatment ID")
    void testBookAppointment_InvalidTreatmentId() {
        Date date = Date.valueOf(LocalDate.now().plusDays(1));
        Time time = Time.valueOf(LocalTime.of(10, 0));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            appointmentService.bookAppointment(testPatientId, testDentistId, 0, date, time);
        });
        assertTrue(exception.getMessage().contains("Please select a treatment"));
    }

    // ===== TEST 5: Null Date =====
    @Test
    @DisplayName("Should throw exception for null date")
    void testBookAppointment_NullDate() {
        Time time = Time.valueOf(LocalTime.of(10, 0));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            appointmentService.bookAppointment(testPatientId, testDentistId, testTreatmentId, null, time);
        });
        assertTrue(exception.getMessage().contains("Please select a date"));
    }

    // ===== TEST 6: Null Time =====
    @Test
    @DisplayName("Should throw exception for null time")
    void testBookAppointment_NullTime() {
        Date date = Date.valueOf(LocalDate.now().plusDays(1));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            appointmentService.bookAppointment(testPatientId, testDentistId, testTreatmentId, date, null);
        });
        assertTrue(exception.getMessage().contains("Please select a time"));
    }
}