CREATE DATABASE HealthSys;
USE HealthSys;

CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    documento VARCHAR(50) UNIQUE,
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    direccion VARCHAR(150),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    tipo_sangre VARCHAR(5),
    alergias TEXT,
    antecedentes_familiares TEXT,
    seguro_medico VARCHAR(100)
);

CREATE TABLE Especialidad (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    requisitos_formacion TEXT,
    equipamiento TEXT
);

CREATE TABLE Departamento (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100), NOT NULL
    responsable VARCHAR(100),
    ubicacion VARCHAR(100),
    extension VARCHAR(20),
    horario VARCHAR(100)
);

CREATE TABLE Consultorio (
    id_consultorio INT AUTO_INCREMENT PRIMARY KEY,
    ubicacion VARCHAR(100),
    id_departamento INT,
    capacidad INT,
    equipamiento TEXT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

CREATE TABLE Personal_Medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100), NOT NULL
    apellidos VARCHAR(100), NOT NULL
    id_especialidad INT,
    subespecialidad VARCHAR(100),
    grado_academico VARCHAR(100),
    universidad VARCHAR(100),
    años_experiencia INT,
    horario VARCHAR(100),
    id_consultorio INT,
    estado VARCHAR(20),
    FOREIGN KEY (id_especialidad) REFERENCES Especialidad(id_especialidad),
    FOREIGN KEY (id_consultorio) REFERENCES Consultorio(id_consultorio)
);

CREATE TABLE Historial_Medico (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    fecha_consulta DATE,
    id_medico INT,
    motivo_consulta TEXT,
    sintomas TEXT,
    presion_arterial VARCHAR(20),
    temperatura DECIMAL(4,2),
    frecuencia_cardiaca INT,
    saturacion_oxigeno INT,
    diagnostico TEXT,
    tratamiento TEXT,
    observaciones TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Personal_Medico(id_medico)
);

CREATE TABLE Cita_Medica (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    hora TIME,
    duracion INT,
    id_paciente INT,
    id_medico INT,
    id_consultorio INT,
    id_especialidad INT,
    tipo_cita VARCHAR(50),
    estado VARCHAR(50),
    observaciones TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Personal_Medico(id_medico),
    FOREIGN KEY (id_consultorio) REFERENCES Consultorio(id_consultorio),
    FOREIGN KEY (id_especialidad) REFERENCES Especialidad(id_especialidad)
);

CREATE TABLE Hospitalizacion (
    id_hospitalizacion INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    fecha_ingreso DATETIME,
    motivo TEXT,
    id_medico INT,
    diagnostico_ingreso TEXT,
    habitacion VARCHAR(50),
    fecha_alta DATETIME,
    observaciones TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Personal_Medico(id_medico)
);

CREATE TABLE Cama (
    id_cama INT AUTO_INCREMENT PRIMARY KEY,
    habitacion VARCHAR(50),
    tipo VARCHAR(50),
    estado VARCHAR(50),
    caracteristicas TEXT
);

CREATE TABLE Diagnostico (
    codigo_cie10 VARCHAR(10) PRIMARY KEY,
    descripcion TEXT,
    categoria VARCHAR(100),
    sintomas TEXT,
    tratamientos TEXT
);

CREATE TABLE Tratamiento (
    id_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50),
    descripcion TEXT,
    duracion VARCHAR(50),
    contraindicaciones TEXT,
    precauciones TEXT
);

CREATE TABLE Medicamento (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_comercial VARCHAR(100),
    principio_activo VARCHAR(100),
    presentacion VARCHAR(100),
    concentracion VARCHAR(50),
    forma_farmaceutica VARCHAR(100),
    via_administracion VARCHAR(100),
    laboratorio VARCHAR(100),
    indicaciones TEXT,
    contraindicaciones TEXT
);

CREATE TABLE Inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_medicamento INT,
    lote VARCHAR(50),
    fecha_vencimiento DATE,
    cantidad INT,
    ubicacion VARCHAR(100),
    precio DECIMAL(10,2),
    FOREIGN KEY (id_medicamento) REFERENCES Medicamento(id_medicamento)
);

SHOW TABLES;

DESCRIBE Paciente;

SELECT * FROM Paciente;

SELECT *
FROM Historial_Medico
WHERE id_paciente = 1;

SELECT pm.*
FROM Personal_Medico pm
JOIN Especialidad e ON pm.id_especialidad = e.id_especialidad
WHERE e.nombre <> 'Pediatría';

SELECT *
FROM Cita_Medica
WHERE id_medico = 1
AND fecha = '2024-01-15';

SELECT *
FROM Paciente
WHERE alergias LIKE '%penicilina%'
   OR alergias LIKE '%lactosa%';
   
SELECT *
FROM Hospitalizacion
WHERE fecha_ingreso BETWEEN '2024-01-01' AND '2024-01-31';

SELECT *
FROM Diagnostico
WHERE categoria IN ('Respiratorio', 'Cardiovascular', 'Infeccioso');

SELECT *
FROM Medicamento
WHERE principio_activo LIKE '%amoxicilina%';

SELECT *
FROM Hospitalizacion
WHERE fecha_alta IS NOT NULL;

SELECT *
FROM Personal_Medico
ORDER BY id_especialidad, años_experiencia DESC;

SELECT 
    diagnostico_ingreso,
    AVG(DATEDIFF(fecha_alta, fecha_ingreso)) AS promedio_dias
FROM Hospitalizacion
WHERE fecha_alta IS NOT NULL
GROUP BY diagnostico_ingreso;

