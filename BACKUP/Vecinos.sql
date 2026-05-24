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
    CONSTRAINT fk_vecino_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuarios),
    CONSTRAINT fk_vecino_vivienda
        FOREIGN KEY (id_vivienda) REFERENCES viviendas(id_vivienda)
);