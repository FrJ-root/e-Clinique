CREATE EXTENSION IF NOT EXISTS "pgcrypto";

DROP TABLE IF EXISTS availabilities CASCADE;
DROP TABLE IF EXISTS medical_notes CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS specialties CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS staffs CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL,
    actif BOOLEAN DEFAULT TRUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE specialties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    department_id UUID,
    CONSTRAINT fk_specialty_department FOREIGN KEY (department_id)
        REFERENCES departments(id) ON DELETE SET NULL
);

CREATE TABLE patients (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    cin VARCHAR(20) UNIQUE NOT NULL,
    sang VARCHAR(10),
    sexe VARCHAR(10),
    adresse VARCHAR(255),
    telephone VARCHAR(20),
    naissance DATE
);

CREATE TABLE doctors (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    matricule VARCHAR(50) UNIQUE NOT NULL,
    titre VARCHAR(100),
    specialty_id UUID,
    CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id)
        REFERENCES specialties(id) ON DELETE SET NULL
);

CREATE TABLE staffs (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    matricule VARCHAR(50) UNIQUE NOT NULL,
    poste VARCHAR(100),
    bureau VARCHAR(100)
);

CREATE TABLE availabilities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    jour VARCHAR(20) NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    statut VARCHAR(20),
    validite BOOLEAN DEFAULT TRUE,
    doctor_id UUID NOT NULL,
    CONSTRAINT fk_availability_doctor FOREIGN KEY (doctor_id)
        REFERENCES doctors(id) ON DELETE CASCADE
);

CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    date DATE NOT NULL,
    heure TIME NOT NULL,
    statut VARCHAR(20) NOT NULL,
    patient_id UUID,
    doctor_id UUID,
    type VARCHAR(20),
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id)
        REFERENCES patients(id) ON DELETE SET NULL,
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id)
        REFERENCES doctors(id) ON DELETE SET NULL
);

CREATE TABLE medical_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contenu TEXT,
    appointment_id UUID UNIQUE,
    CONSTRAINT fk_note_appointment FOREIGN KEY (appointment_id)
        REFERENCES appointments(id) ON DELETE CASCADE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_patients_cin ON patients(cin);
CREATE INDEX idx_doctors_matricule ON doctors(matricule);
CREATE INDEX idx_appointments_date ON appointments(date);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_availabilities_doctor ON availabilities(doctor_id);

INSERT INTO users (nom, email, role, actif, password) VALUES
    ('Administrateur', 'admin@clinique.com', 'ADMIN', TRUE, 'pass123'),
    ('Dr. Karim El Mansouri', 'karim@clinique.com', 'DOCTOR', TRUE, 'pass123'),
    ('Dr. Sofia Haddad', 'sofia@clinique.com', 'DOCTOR', TRUE, 'pass123'),
    ('Dr. Youssef Benaissa', 'youssef@clinique.com', 'DOCTOR', TRUE, 'pass123'),
    ('Amine Rafiq', 'amine@clinique.com', 'PATIENT', TRUE, 'pass123'),
    ('Sara El Fassi', 'sara@clinique.com', 'PATIENT', TRUE, 'pass123'),
    ('Omar Benali', 'omar@clinique.com', 'PATIENT', TRUE, 'pass123'),
    ('Nadia Lamrani', 'nadia@clinique.com', 'STAFF', TRUE, 'pass123'),
    ('Reda Kabbaj', 'reda@clinique.com', 'STAFF', TRUE, 'pass123');