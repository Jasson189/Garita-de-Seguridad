CREATE TABLE viviendas (
    id_vivienda SERIAL PRIMARY KEY,
    numero_vivienda VARCHAR(20) NOT NULL,
    sector VARCHAR(50),
    direccion_referencia VARCHAR(150),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);