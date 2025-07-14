CREATE DATABASE IF NOT EXISTS db_informacion;
USE db_informacion;

CREATE TABLE IF NOT EXISTS datos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) NOT NULL,
    experiencia TEXT,
    formacion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
