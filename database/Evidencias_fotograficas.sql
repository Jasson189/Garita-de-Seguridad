CREATE TABLE evidencias_fotograficas (
    id_evidencia SERIAL PRIMARY KEY,
    id_visita INT NOT NULL,
    tipo_evidencia VARCHAR(20) NOT NULL,
    ruta_archivo TEXT NOT NULL,
    nombre_archivo VARCHAR(150),
    origen_captura VARCHAR(20) NOT NULL,
    fecha_captura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (id_visita) REFERENCES visitas(id_visita)
);