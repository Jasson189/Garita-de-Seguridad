-- ROLES
CREATE TABLE roles (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150),
    estado BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO roles (nombre_rol, descripcion)
VALUES 
('Administrador', 'Control total del sistema'),
('Agente', 'Encargado de registrar visitas'),
('Vecino', 'Residente de la vivienda');

-- USUARIOS
CREATE TABLE usuarios (
    id_usuarios SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena_hash TEXT NOT NULL,
    id_rol INT NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

INSERT INTO usuarios (nombre_usuario, correo, contrasena_hash, id_rol)
VALUES ('admin', 'admin@garita.com', '1234', 1);

-- VIVIENDAS
CREATE TABLE viviendas (
    id_vivienda SERIAL PRIMARY KEY,
    numero_vivienda VARCHAR(20) NOT NULL,
    sector VARCHAR(50),
    direccion_referencia VARCHAR(150),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO viviendas (numero_vivienda, sector, direccion_referencia)
VALUES 
('Casa 1', 'Sector A', 'Frente al parque'),
('Casa 2', 'Sector A', 'Cerca de la entrada');

-- VECINOS
CREATE TABLE vecinos (
    id_vecino SERIAL PRIMARY KEY,
    id_usuario INT,
    id_vivienda INT NOT NULL,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    dpi VARCHAR(20) UNIQUE,
    telefono VARCHAR(20),
    correo VARCHAR(100) NOT NULL,
    codigo_unico VARCHAR(30) NOT NULL UNIQUE,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuarios),
    FOREIGN KEY (id_vivienda) REFERENCES viviendas(id_vivienda)
);

INSERT INTO vecinos (id_usuario, id_vivienda, nombres, apellidos, dpi, telefono, correo, codigo_unico)
VALUES 
(1, 1, 'Juan', 'Pérez', '1234567890101', '55551234', 'juan@gmail.com', 'CASA1-ABC');

-- VISITANTES
CREATE TABLE visitantes (
    id_visitantes SERIAL PRIMARY KEY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    tipo_documento VARCHAR(20),
    numero_documento VARCHAR(30),
    telefono VARCHAR(20),
    observaciones TEXT,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO visitantes (nombres, apellidos, tipo_documento, numero_documento, telefono)
VALUES 
('Carlos', 'Méndez', 'DPI', '1234567890101', '55550000');

-- VISITAS
CREATE TABLE visitas (
    id_visita SERIAL PRIMARY KEY,
    id_visitante INT NOT NULL,
    id_vecino INT NOT NULL,
    id_vivienda INT NOT NULL,
    id_usuario_agente INT NOT NULL,
    tipo_ingreso VARCHAR(20) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    hora_ingreso TIME NOT NULL,
    estado_visita VARCHAR(20) NOT NULL DEFAULT 'activa',
    observaciones TEXT,
    FOREIGN KEY (id_visitante) REFERENCES visitantes(id_visitantes),
    FOREIGN KEY (id_vecino) REFERENCES vecinos(id_vecino),
    FOREIGN KEY (id_vivienda) REFERENCES viviendas(id_vivienda),
    FOREIGN KEY (id_usuario_agente) REFERENCES usuarios(id_usuarios)
);