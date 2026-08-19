package com.sunrise.service;

import com.sunrise.dao.PatientDAO;
import com.sunrise.model.Patient;

public class PatientService {
    private PatientDAO dao = new PatientDAO();

    public int registerPatient(String name, String address, String contact) {
        if (name == null || name.trim().isEmpty())
            throw new IllegalArgumentException("Name is required!");
        if (!contact.matches("\\d{10,15}"))
            throw new IllegalArgumentException("Contact must be 10-15 digits!");

        Patient p = new Patient();
        p.setName(name.trim());
        p.setAddress(address.trim());
        p.setContactNumber(contact.trim());
        return dao.savePatient(p);
    }
}