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