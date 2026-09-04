package com.sunrise.test;

import com.sunrise.service.PatientService;
import org.junit.jupiter.api.*;

import static org.junit.jupiter.api.Assertions.*;

public class PatientServiceTest {

    private PatientService patientService;

    @BeforeEach
    void setUp() {
        patientService = new PatientService();
    }

    // TEST 1: Valid Patient Registration
    @Test
    @DisplayName("Should register patient with valid details")
    void testRegisterPatient_ValidDetails() {
        int patientId = patientService.registerPatient(
            "John Doe",
            "123 Main Street",
            "0712345678"
        );
        assertTrue(patientId > 0, "Patient ID should be greater than 0");
    }

    // TEST 2: Null Name
    @Test
    @DisplayName("Should throw exception when name is null")
    void testRegisterPatient_NullName() {
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            patientService.registerPatient(null, "123 Main St", "0712345678");
        });
        assertTrue(exception.getMessage().contains("Name is required"));
    }

    // TEST 3: Empty Name
    @Test
    @DisplayName("Should throw exception when name is empty")
    void testRegisterPatient_EmptyName() {
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            patientService.registerPatient("", "123 Main St", "0712345678");
        });
        assertTrue(exception.getMessage().contains("Name is required"));
    }

    // TEST 4: Invalid Contact (Too Short)
    @Test
    @DisplayName("Should throw exception when contact is less than 10 digits")
    void testRegisterPatient_InvalidContact_TooShort() {
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            patientService.registerPatient("John Doe", "123 Main St", "123");
        });
        assertTrue(exception.getMessage().contains("Contact must be 10-15 digits"));
    }

    // TEST 5: Invalid Contact (Contains Letters)
    @Test
    @DisplayName("Should throw exception when contact contains letters")
    void testRegisterPatient_InvalidContact_ContainsLetters() {
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            patientService.registerPatient("John Doe", "123 Main St", "071abc5678");
        });
        assertTrue(exception.getMessage().contains("Contact must be 10-15 digits"));
    }

    // TEST 6: Valid Contact with 10 digits
    @Test
    @DisplayName("Should accept valid 10-digit contact")
    void testRegisterPatient_ValidContact_10Digits() {
        int patientId = patientService.registerPatient(
            "Jane Smith",
            "456 Oak Road",
            "0776543210"
        );
        assertTrue(patientId > 0);
    }

    // TEST 7: Null Address
    @Test
    @DisplayName("Should throw exception when address is null")
    void testRegisterPatient_NullAddress() {
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            patientService.registerPatient("John Doe", null, "0712345678");
        });
        assertTrue(exception.getMessage().contains("Address is required"));
    }
}