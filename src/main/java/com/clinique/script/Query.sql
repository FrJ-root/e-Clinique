--CREATE EXTENSION IF NOT EXISTS "pgcrypto";
--
--DROP TABLE IF EXISTS availabilities CASCADE;
--DROP TABLE IF EXISTS medical_notes CASCADE;
--DROP TABLE IF EXISTS appointments CASCADE;
--DROP TABLE IF EXISTS specialties CASCADE;
--DROP TABLE IF EXISTS departments CASCADE;
--DROP TABLE IF EXISTS patients CASCADE;
--DROP TABLE IF EXISTS doctors CASCADE;
--DROP TABLE IF EXISTS staffs CASCADE;
--DROP TABLE IF EXISTS users CASCADE;
--
--CREATE TABLE users (
--    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--    nom VARCHAR(100),
--    email VARCHAR(100) UNIQUE NOT NULL,
--    role VARCHAR(50) NOT NULL,
--    actif BOOLEAN DEFAULT TRUE,
--    password VARCHAR(255) NOT NULL
--);
--
--CREATE TABLE departments (
--    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--    nom VARCHAR(100) NOT NULL,
--    description TEXT
--);
--
--ALTER TABLE departments ADD COLUMN code VARCHAR(50) NOT NULL UNIQUE;
--
--CREATE TABLE specialties (
--    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--    nom VARCHAR(100) NOT NULL,
--    description TEXT,
--    department_id UUID,
--    CONSTRAINT fk_specialty_department FOREIGN KEY (department_id)
--        REFERENCES departments(id) ON DELETE SET NULL
--);
--
--CREATE TABLE patients (
--    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
--    cin VARCHAR(20) UNIQUE NOT NULL,
--    sang VARCHAR(10),
--    sexe VARCHAR(10),
--    adresse VARCHAR(255),
--    telephone VARCHAR(20),
--    naissance DATE
--);
--
--CREATE TABLE doctors (
--    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
--    matricule VARCHAR(50) UNIQUE NOT NULL,
--    titre VARCHAR(100),
--    specialty_id UUID,
--    CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id)
--        REFERENCES specialties(id) ON DELETE SET NULL
--);
--
--ALTER TABLE doctors ADD COLUMN telephone VARCHAR(50);
--ALTER TABLE doctors ADD COLUMN presentation TEXT;
--ALTER TABLE doctors ADD COLUMN experience TEXT;
--ALTER TABLE doctors ADD COLUMN formation TEXT;
--ALTER TABLE doctors ADD COLUMN actif BOOLEAN NOT NULL DEFAULT TRUE;
--
--CREATE TABLE staffs (
--    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
--    matricule VARCHAR(50) UNIQUE NOT NULL,
--    poste VARCHAR(100),
--    bureau VARCHAR(100)
--);
--
--CREATE TABLE availabilities (
--    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--    jour VARCHAR(20) NOT NULL,
--    statut VARCHAR(20),
--    doctor_id UUID NOT NULL,
--    CONSTRAINT fk_availability_doctor FOREIGN KEY (doctor_id)
--        REFERENCES doctors(id) ON DELETE CASCADE
--);
--
--
---- Add columns to support the enhanced availability functionality
--ALTER TABLE availabilities ADD COLUMN IF NOT EXISTS jour_semaine VARCHAR(20);
--ALTER TABLE availabilities ADD COLUMN IF NOT EXISTS type VARCHAR(20) DEFAULT 'REGULAR' NOT NULL;
--ALTER TABLE availabilities ADD COLUMN IF NOT EXISTS raison TEXT;
---- Update existing records to use the new type field
--UPDATE availabilities SET type = 'REGULAR' WHERE type IS NULL;
---- Create an index for faster lookups
--CREATE INDEX IF NOT EXISTS idx_availabilities_doctor_type ON availabilities(doctor_id, type);
--
--
--CREATE TABLE appointments (
--    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--    date DATE NOT NULL,
--    heure TIME NOT NULL,
--    statut VARCHAR(20) NOT NULL,
--    patient_id UUID,
--    doctor_id UUID,
--    type VARCHAR(20),
--    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id)
--        REFERENCES patients(id) ON DELETE SET NULL,
--    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id)
--        REFERENCES doctors(id) ON DELETE SET NULL
--);
--
--CREATE TABLE medical_notes (
--    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--    contenu TEXT,
--    appointment_id UUID UNIQUE,
--    CONSTRAINT fk_note_appointment FOREIGN KEY (appointment_id)
--        REFERENCES appointments(id) ON DELETE CASCADE
--);
--
--CREATE INDEX idx_users_email ON users(email);
--CREATE INDEX idx_patients_cin ON patients(cin);
--CREATE INDEX idx_doctors_matricule ON doctors(matricule);
--CREATE INDEX idx_appointments_date ON appointments(date);
--CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
--CREATE INDEX idx_availabilities_doctor ON availabilities(doctor_id);
--
--INSERT INTO users (nom, email, role, actif, password) VALUES
--    ('Administrateur', 'admin@clinique.com', 'ADMIN', TRUE, 'pass123'),
--    ('Dr. Karim El Mansouri', 'karim@clinique.com', 'DOCTOR', TRUE, 'pass123'),
--    ('Dr. Sofia Haddad', 'sofia@clinique.com', 'DOCTOR', TRUE, 'pass123'),
--    ('Dr. Youssef Benaissa', 'youssef@clinique.com', 'DOCTOR', TRUE, 'pass123'),
--    ('Amine Rafiq', 'amine@clinique.com', 'PATIENT', TRUE, 'pass123'),
--    ('Sara El Fassi', 'sara@clinique.com', 'PATIENT', TRUE, 'pass123'),
--    ('Omar Benali', 'omar@clinique.com', 'PATIENT', TRUE, 'pass123'),
--    ('Nadia Lamrani', 'nadia@clinique.com', 'STAFF', TRUE, 'pass123'),
--    ('Reda Kabbaj', 'reda@clinique.com', 'STAFF', TRUE, 'pass123');





-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.appointments
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    date date NOT NULL,
    heure time without time zone NOT NULL,
    statut character varying(20) COLLATE pg_catalog."default" NOT NULL,
    patient_id uuid,
    doctor_id uuid,
    type character varying(20) COLLATE pg_catalog."default",
    heuredebut time(6) without time zone NOT NULL,
    heurefin time(6) without time zone NOT NULL,
    motif character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT appointments_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.availabilities
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    jour date,
    heure_debut time without time zone NOT NULL,
    heure_fin time without time zone NOT NULL,
    statut character varying(20) COLLATE pg_catalog."default",
    doctor_id uuid NOT NULL,
    jour_semaine character varying(20) COLLATE pg_catalog."default",
    type character varying(20) COLLATE pg_catalog."default" NOT NULL DEFAULT 'REGULAR'::character varying,
    raison text COLLATE pg_catalog."default",
    CONSTRAINT availabilities_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.departments
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    nom character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    code character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT departments_pkey PRIMARY KEY (id),
    CONSTRAINT uk_l7tivi5261wxdnvo6cct9gg6t UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS public.doctors
(
    id uuid NOT NULL,
    matricule character varying(50) COLLATE pg_catalog."default" NOT NULL,
    titre character varying(100) COLLATE pg_catalog."default",
    specialty_id uuid,
    telephone character varying(50) COLLATE pg_catalog."default",
    presentation text COLLATE pg_catalog."default",
    experience text COLLATE pg_catalog."default",
    formation text COLLATE pg_catalog."default",
    CONSTRAINT doctors_pkey PRIMARY KEY (id),
    CONSTRAINT doctors_matricule_key UNIQUE (matricule)
);

CREATE TABLE IF NOT EXISTS public.holidays
(
    id uuid NOT NULL,
    date date NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    nom character varying(255) COLLATE pg_catalog."default" NOT NULL,
    recurring boolean,
    CONSTRAINT holidays_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.medical_notes
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    contenu text COLLATE pg_catalog."default",
    appointment_id uuid,
    createdat timestamp(6) without time zone NOT NULL,
    valide boolean NOT NULL,
    author_id uuid NOT NULL,
    confidential boolean,
    content text COLLATE pg_catalog."default" NOT NULL,
    doctor_id uuid,
    created_at timestamp(6) without time zone,
    note text COLLATE pg_catalog."default",
    updated_at timestamp(6) without time zone,
    CONSTRAINT medical_notes_pkey PRIMARY KEY (id),
    CONSTRAINT medical_notes_appointment_id_key UNIQUE (appointment_id)
);

CREATE TABLE IF NOT EXISTS public.patients
(
    id uuid NOT NULL,
    cin character varying(20) COLLATE pg_catalog."default" NOT NULL,
    sang character varying(10) COLLATE pg_catalog."default",
    sexe character varying(10) COLLATE pg_catalog."default",
    adresse character varying(255) COLLATE pg_catalog."default",
    telephone character varying(20) COLLATE pg_catalog."default",
    naissance date,
    CONSTRAINT patients_pkey PRIMARY KEY (id),
    CONSTRAINT patients_cin_key UNIQUE (cin)
);

CREATE TABLE IF NOT EXISTS public.settings
(
    id uuid NOT NULL,
    description text COLLATE pg_catalog."default",
    setting_key character varying(255) COLLATE pg_catalog."default" NOT NULL,
    updatedat timestamp(6) without time zone,
    value character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT settings_pkey PRIMARY KEY (id),
    CONSTRAINT uk_swd05dvj4ukvw5q135bpbbfae UNIQUE (setting_key)
);

CREATE TABLE IF NOT EXISTS public.specialties
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    nom character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    department_id uuid,
    code character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT specialties_pkey PRIMARY KEY (id),
    CONSTRAINT uk_8hq46e4ylgbhk67ke0u9y52i3 UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS public.staffs
(
    id uuid NOT NULL,
    matricule character varying(50) COLLATE pg_catalog."default" NOT NULL,
    poste character varying(100) COLLATE pg_catalog."default",
    bureau character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT staffs_pkey PRIMARY KEY (id),
    CONSTRAINT staffs_matricule_key UNIQUE (matricule)
);

CREATE TABLE IF NOT EXISTS public.system_settings
(
    id uuid NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    settingkey character varying(255) COLLATE pg_catalog."default" NOT NULL,
    settingvalue character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT system_settings_pkey PRIMARY KEY (id),
    CONSTRAINT uk_s8ql0yedo92vt558avbpe8xig UNIQUE (settingkey)
);

CREATE TABLE IF NOT EXISTS public.users
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    nom character varying(100) COLLATE pg_catalog."default",
    email character varying(100) COLLATE pg_catalog."default" NOT NULL,
    role character varying(50) COLLATE pg_catalog."default" NOT NULL,
    actif boolean DEFAULT true,
    password character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email)
);

ALTER TABLE IF EXISTS public.appointments
    ADD CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id)
    REFERENCES public.doctors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_appointments_doctor
    ON public.appointments(doctor_id);


ALTER TABLE IF EXISTS public.appointments
    ADD CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id)
    REFERENCES public.patients (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL;


ALTER TABLE IF EXISTS public.availabilities
    ADD CONSTRAINT fk_availability_doctor FOREIGN KEY (doctor_id)
    REFERENCES public.doctors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_availabilities_doctor
    ON public.availabilities(doctor_id);


ALTER TABLE IF EXISTS public.doctors
    ADD CONSTRAINT doctors_id_fkey FOREIGN KEY (id)
    REFERENCES public.users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS doctors_pkey
    ON public.doctors(id);


ALTER TABLE IF EXISTS public.doctors
    ADD CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id)
    REFERENCES public.specialties (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL;


ALTER TABLE IF EXISTS public.medical_notes
    ADD CONSTRAINT fk_note_appointment FOREIGN KEY (appointment_id)
    REFERENCES public.appointments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS medical_notes_appointment_id_key
    ON public.medical_notes(appointment_id);


ALTER TABLE IF EXISTS public.medical_notes
    ADD CONSTRAINT fkdm6gqaqpb6olswr473d1i4agc FOREIGN KEY (doctor_id)
    REFERENCES public.doctors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.medical_notes
    ADD CONSTRAINT fki4iuhplx7yp336gdp2wylco1p FOREIGN KEY (author_id)
    REFERENCES public.users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.patients
    ADD CONSTRAINT patients_id_fkey FOREIGN KEY (id)
    REFERENCES public.users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS patients_pkey
    ON public.patients(id);


ALTER TABLE IF EXISTS public.specialties
    ADD CONSTRAINT fk_specialty_department FOREIGN KEY (department_id)
    REFERENCES public.departments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL;


ALTER TABLE IF EXISTS public.staffs
    ADD CONSTRAINT staffs_id_fkey FOREIGN KEY (id)
    REFERENCES public.users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS staffs_pkey
    ON public.staffs(id);

END;
