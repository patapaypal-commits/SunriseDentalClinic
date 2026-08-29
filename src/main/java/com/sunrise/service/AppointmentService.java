package com.sunrise.service;

import com.sunrise.dao.AppointmentDAO;
import com.sunrise.model.Appointment;
import java.sql.Date;
import java.sql.Time;

public class AppointmentService {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    public String bookAppointment(int patientId, int dentistId, int treatmentId, Date date, Time time) {
        
        
        if (patientId <= 0) {
            throw new IllegalArgumentException("Please select a patient.");
        }
        if (dentistId <= 0) {
            throw new IllegalArgumentException("Please select a dentist.");
        }
        if (treatmentId <= 0) {
            throw new IllegalArgumentException("Please select a treatment.");
        }
        if (date == null) {
            throw new IllegalArgumentException("Please select a date.");
        }
        if (time == null) {
            throw new IllegalArgumentException("Please select a time.");
        }

        
        if (!appointmentDAO.isDentistAvailable(dentistId, date, time)) {
            throw new IllegalArgumentException("Dentist is already booked at this time!");
        }

       
        String appointmentNumber = appointmentDAO.generateAppointmentNumber();

        
        Appointment appointment = new Appointment();
        appointment.setAppointmentNumber(appointmentNumber);
        appointment.setPatientId(patientId);
        appointment.setDentistId(dentistId);
        appointment.setTreatmentId(treatmentId);
        appointment.setAppointmentDate(date);
        appointment.setAppointmentTime(time);

        
        boolean saved = appointmentDAO.saveAppointment(appointment);
        if (!saved) {
            throw new RuntimeException("Failed to save appointment!");
        }

        return appointmentNumber;
    }
}