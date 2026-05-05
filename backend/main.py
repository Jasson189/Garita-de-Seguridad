from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from database import engine
from sqlalchemy import text
import base64
import os
import time

app = FastAPI()

# Crear carpeta fotos si no existe
if not os.path.exists("fotos"):
    os.makedirs("fotos")

# Servir imágenes
app.mount("/fotos", StaticFiles(directory="fotos"), name="fotos")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelo
class VisitaCreate(BaseModel):
    id_visitante: int
    id_vecino: int
    id_vivienda: int
    id_usuario_agente: int
    tipo_ingreso: str
    observaciones: str | None = None
    foto: str | None = None
    placa: str | None = None


# ------------------- RUTAS -------------------

@app.get("/")
def inicio():
    return {"mensaje": "API funcionando"}


@app.get("/visitantes")
def listar_visitantes():
    with engine.connect() as conexion:
        resultado = conexion.execute(text("""
            SELECT id_visitantes, nombres, apellidos
            FROM visitantes
        """))

        return [{
            "id_visitante": fila.id_visitantes,
            "nombres": fila.nombres,
            "apellidos": fila.apellidos
        } for fila in resultado]


@app.get("/vecinos")
def listar_vecinos():
    with engine.connect() as conexion:
        resultado = conexion.execute(text("""
            SELECT id_vecino, nombres, apellidos, id_vivienda
            FROM vecinos
        """))

        return [{
            "id_vecino": fila.id_vecino,
            "nombres": fila.nombres,
            "apellidos": fila.apellidos,
            "id_vivienda": fila.id_vivienda
        } for fila in resultado]


# 🔥 VISITAS (IMPORTANTE CON PLACA)
@app.get("/visitas")
def listar_visitas():
    with engine.connect() as conexion:
        resultado = conexion.execute(text("""
            SELECT id_visita, id_visitante, id_vecino, id_vivienda,
                   tipo_ingreso, fecha_ingreso, hora_ingreso,
                   fecha_salida, hora_salida, estado_visita,
                   observaciones, foto, placa
            FROM visitas
            ORDER BY id_visita;
        """))

        visitas = []
        for fila in resultado:
            visitas.append({
                "id_visita": fila.id_visita,
                "id_visitante": fila.id_visitante,
                "id_vecino": fila.id_vecino,
                "id_vivienda": fila.id_vivienda,
                "tipo_ingreso": fila.tipo_ingreso,
                "fecha_ingreso": str(fila.fecha_ingreso),
                "hora_ingreso": str(fila.hora_ingreso),
                "fecha_salida": str(fila.fecha_salida) if fila.fecha_salida else "",
                "hora_salida": str(fila.hora_salida) if fila.hora_salida else "",
                "estado_visita": fila.estado_visita,
                "observaciones": fila.observaciones,
                "foto": fila.foto,
                "placa": fila.placa
            })

    return visitas


@app.post("/visitas")
def crear_visita(visita: VisitaCreate):

    nombre_archivo = None

    # Guardar foto
    if visita.foto:
        nombre_archivo = f"fotos/visita_{visita.id_visitante}_{int(time.time())}.png"
        imagen = visita.foto.split(",")[1]

        with open(nombre_archivo, "wb") as f:
            f.write(base64.b64decode(imagen))

    with engine.begin() as conexion:
        conexion.execute(text("""
            INSERT INTO visitas (
                id_visitante,
                id_vecino,
                id_vivienda,
                id_usuario_agente,
                tipo_ingreso,
                fecha_ingreso,
                hora_ingreso,
                estado_visita,
                observaciones,
                foto,
                placa
            )
            VALUES (
                :id_visitante,
                :id_vecino,
                :id_vivienda,
                :id_usuario_agente,
                :tipo_ingreso,
                CURRENT_DATE,
                CURRENT_TIME,
                'activa',
                :observaciones,
                :foto,
                :placa
            )
        """), {
            "id_visitante": visita.id_visitante,
            "id_vecino": visita.id_vecino,
            "id_vivienda": visita.id_vivienda,
            "id_usuario_agente": visita.id_usuario_agente,
            "tipo_ingreso": visita.tipo_ingreso,
            "observaciones": visita.observaciones,
            "foto": nombre_archivo,
            "placa": visita.placa
        })

    return {"mensaje": "Visita registrada correctamente"}


@app.put("/visitas/{id_visita}/salida")
def registrar_salida(id_visita: int):
    with engine.begin() as conexion:
        conexion.execute(text("""
            UPDATE visitas
            SET fecha_salida = CURRENT_DATE,
                hora_salida = CURRENT_TIME,
                estado_visita = 'finalizada'
            WHERE id_visita = :id_visita
        """), {"id_visita": id_visita})

    return {"mensaje": "Salida registrada correctamente"}