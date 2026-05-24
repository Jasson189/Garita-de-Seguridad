from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from database import engine
from sqlalchemy import text
import base64
import os
import time
import uuid
from datetime import datetime, timedelta
import smtplib
from email.message import EmailMessage
from jose import jwt, JWTError
app = FastAPI()

# CONFIGURACION JWT
SECRET_KEY = "garita_seguridad_clave_secreta_2026"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60
# Esquema de seguridad para Swagger
seguridad_bearer = HTTPBearer()

# CREAR TOKEN JWT
# =========================================
def crear_token_acceso(datos: dict):

    datos_token = datos.copy()

    expiracion = datetime.utcnow() + timedelta(
        minutes=ACCESS_TOKEN_EXPIRE_MINUTES
    )

    datos_token.update({
        "exp": expiracion
    })

    token = jwt.encode(
        datos_token,
        SECRET_KEY,
        algorithm=ALGORITHM
    )

    return token

# OBTENER USUARIO ACTUAL DESDE TOKEN
def obtener_usuario_actual(
    credenciales: HTTPAuthorizationCredentials = Depends(seguridad_bearer)
):

    token = credenciales.credentials

    try:
        payload = jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM]
        )

        id_usuario = payload.get("sub")
        nombre_usuario = payload.get("nombre_usuario")
        rol = payload.get("rol")

        if id_usuario is None:
            raise HTTPException(
                status_code=401,
                detail="Token invalido"
            )

        return {
            "id": id_usuario,
            "nombre_usuario": nombre_usuario,
            "rol": rol
        }

    except JWTError:
        raise HTTPException(
            status_code=401,
            detail="Token invalido o expirado"
        )

# Crear carpeta fotos si no existe
if not os.path.exists("fotos"):
    os.makedirs("fotos")

# Servir imágenes
app.mount("/fotos", StaticFiles(directory="fotos"), name="fotos")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://127.0.0.1:5500",
        "http://localhost:5500"
    ],
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

    # Modelo para recibir datos del login
class LoginRequest(BaseModel):
    nombre_usuario: str
    contrasena: str

# modelo crear visitante
class VisitanteCreate(BaseModel):
    nombres: str
    apellidos: str


# modelo actualizar visitante
class VisitanteUpdate(BaseModel):
    nombres: str
    apellidos: str

# MODELO PARA REGISTRAR VECINOS
class VecinoCreate(BaseModel):
            id_usuario: int | None = None
            id_vivienda: int
            nombres: str
            apellidos: str
            dpi: str | None = None
            telefono: str | None = None
            correo: str


    #Actulizar vecino
class VecinoUpdate(BaseModel):
    id_vivienda: int
    nombres: str
    apellidos: str
    dpi: str | None = None
    telefono: str | None = None
    correo: str
    estado: bool

# MODELO PARA CREAR VIVIENDAS
class ViviendaCreate(BaseModel):
    numero_vivienda: str
    sector: str | None = None
    direccion_referencia: str | None = None

# MODELO PARA ACTUALIZAR VIVIENDAS
class ViviendaUpdate(BaseModel):
    numero_vivienda: str
    sector: str | None = None
    direccion_referencia: str | None = None
    estado: bool

    # MODELO PARA VEHICULOS

class VehiculoCreate(BaseModel):
    id_vecino: int
    placa: str
    marca: str | None = None
    color: str | None = None
    modelo: str | None = None

# MODELO PARA CREAR PRERREGISTRO
class PrerregistroCreate(BaseModel):
    id_vecino: int
    nombre_visitante: str
    dpi_visitante: str | None = None
    # Correo donde se enviará el QR
    correo_visitante: str | None = None
    placa: str | None = None
    motivo_visita: str | None = None

  # Endpoint para iniciar sesion
@app.post("/login")
def login(datos: LoginRequest):

    # Buscar usuario en base de datos
    with engine.connect() as conexion:
        resultado = conexion.execute(text("""
            SELECT 
                u.id_usuarios,
                u.nombre_usuario,
                u.correo,
                u.contrasena_hash,
                u.estado,
                r.nombre_rol
            FROM usuarios u
            INNER JOIN roles r ON u.id_rol = r.id_rol
            WHERE u.nombre_usuario = :nombre_usuario
        """), {
            "nombre_usuario": datos.nombre_usuario
        }).mappings().first()

    # Validar si existe el usuario
    if not resultado:
        raise HTTPException(
            status_code=401,
            detail="Usuario o contraseña incorrectos"
        )

    # Validar si el usuario esta activo
    if not resultado["estado"]:
        raise HTTPException(
            status_code=403,
            detail="Usuario inactivo"
        )

    # Validar contraseña
    # En este proyecto la contraseña esta guardada simple como 1234
    if resultado["contrasena_hash"] != datos.contrasena:
        raise HTTPException(
            status_code=401,
            detail="Usuario o contraseña incorrectos"
        )

    # Datos del usuario
    usuario = {
        "id": resultado["id_usuarios"],
        "nombre_usuario": resultado["nombre_usuario"],
        "correo": resultado["correo"],
        "rol": resultado["nombre_rol"]
    }

    # Crear token JWT
    access_token = crear_token_acceso({
        "sub": str(resultado["id_usuarios"]),
        "nombre_usuario": resultado["nombre_usuario"],
        "rol": resultado["nombre_rol"]
    })

    # Respuesta del login
    return {
        "mensaje": "Login correcto",
        "access_token": access_token,
        "token_type": "bearer",
        "usuario": usuario
    }

# ------------------- RUTAS -------------------

@app.get("/")
def inicio():
    return {"mensaje": "API funcionando"}

# REGISTRAR VECINOS
# GENERA CODIGO AUTOMATICO
@app.post("/vecinos")
def crear_vecino(
    vecino: VecinoCreate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):

    with engine.begin() as conexion:
        # OBTENER ULTIMO ID DE VECINO
        ultimo = conexion.execute(text("""
            SELECT MAX(id_vecino) AS ultimo_id
            FROM vecinos
        """)).mappings().first()

        nuevo_numero = 1

        if ultimo["ultimo_id"]:
            nuevo_numero = ultimo["ultimo_id"] + 1

        codigo_unico = f"VEC-{nuevo_numero:04}"

        # INSERTAR VECINO
        conexion.execute(text("""
            INSERT INTO vecinos (
                id_usuario,
                id_vivienda,
                nombres,
                apellidos,
                dpi,
                telefono,
                correo,
                codigo_unico,
                estado
            )
            VALUES (
                :id_usuario,
                :id_vivienda,
                :nombres,
                :apellidos,
                :dpi,
                :telefono,
                :correo,
                :codigo_unico,
                true
            )
        """), {
            "id_usuario": vecino.id_usuario,
            "id_vivienda": vecino.id_vivienda,
            "nombres": vecino.nombres,
            "apellidos": vecino.apellidos,
            "dpi": vecino.dpi,
            "telefono": vecino.telefono,
            "correo": vecino.correo,
            "codigo_unico": codigo_unico
        })

    return {
        "mensaje": "Vecino registrado correctamente",
        "codigo_vecino": codigo_unico
    }

# OBTENER VECINO POR ID
@app.get("/vecinos/{id_vecino}")
def obtener_vecino(
    id_vecino: int,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.connect() as conexion:
        resultado = conexion.execute(text("""
            SELECT *
            FROM vecinos
            WHERE id_vecino = :id_vecino
        """), {
            "id_vecino": id_vecino
        })

        vecino = resultado.mappings().first()

    if not vecino:
        raise HTTPException(
            status_code=404,
            detail="Vecino no encontrado"
        )

    return dict(vecino)

# ACTUALIZAR VECINO
@app.put("/vecinos/{id_vecino}")
def actualizar_vecino(
    id_vecino: int,
    vecino: VecinoUpdate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):

    with engine.begin() as conexion:

        conexion.execute(text("""
            UPDATE vecinos
            SET
                id_vivienda = :id_vivienda,
                nombres = :nombres,
                apellidos = :apellidos,
                dpi = :dpi,
                telefono = :telefono,
                correo = :correo,
                estado = :estado
            WHERE id_vecino = :id_vecino
        """), {
            "id_vivienda": vecino.id_vivienda,
            "nombres": vecino.nombres,
            "apellidos": vecino.apellidos,
            "dpi": vecino.dpi,
            "telefono": vecino.telefono,
            "correo": vecino.correo,
            "estado": vecino.estado,
            "id_vecino": id_vecino
        })

    return {
        "mensaje": "Vecino actualizado correctamente"
    }
# CAMBIAR ESTADO VECINO
@app.put("/vecinos/{id_vecino}/estado")
def cambiar_estado_vecino(
    id_vecino: int,
    estado: bool,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):

    with engine.begin() as conexion:

        conexion.execute(text("""
            UPDATE vecinos
            SET estado = :estado
            WHERE id_vecino = :id_vecino
        """), {
            "estado": estado,
            "id_vecino": id_vecino
        })

    return {
        "mensaje": "Estado actualizado correctamente"
    }

# REGISTRAR VEHICULO
@app.post("/vehiculos")
def crear_vehiculo(
    vehiculo: VehiculoCreate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.begin() as conexion:
        conexion.execute(text("""
            INSERT INTO vehiculos (
                id_vecino, placa, marca, color, modelo
            )
            VALUES (
                :id_vecino, :placa, :marca, :color, :modelo
            )
        """), {
            "id_vecino": vehiculo.id_vecino,
            "placa": vehiculo.placa.upper(),
            "marca": vehiculo.marca,
            "color": vehiculo.color,
            "modelo": vehiculo.modelo
        })

    return {
        "mensaje": "Vehiculo registrado correctamente"
    }

# CONSULTAR PLACA
@app.get("/vehiculos/placa/{placa}")
def consultar_placa(placa: str):

    with engine.connect() as conexion:

        resultado = conexion.execute(text("""

            SELECT
                v.placa,
                v.marca,
                v.color,
                v.modelo,

                ve.nombres,
                ve.apellidos,
                ve.codigo_unico

            FROM vehiculos v

            INNER JOIN vecinos ve
            ON v.id_vecino = ve.id_vecino

            WHERE UPPER(v.placa) = UPPER(:placa)

        """), {
            "placa": placa
        }).mappings().first()

        # SI NO EXISTE
        if not resultado:

            return {
                "mensaje": "Placa no registrada"
            }
        # RESPUESTA
        return {

            "placa": resultado["placa"],

            "marca": resultado["marca"],

            "color": resultado["color"],

            "modelo": resultado["modelo"],

            "vecino":
                resultado["nombres"] + " " +
                resultado["apellidos"],

            "codigo_vecino":
                resultado["codigo_unico"],

            "autorizado": True
        }

@app.post("/visitas")
def crear_visita(
    visita: VisitaCreate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    nombre_archivo = None

    # Guardar foto de la visita
    if visita.foto:

        # Crear nombre único para la imagen
        nombre_archivo = f"fotos/visita_{visita.id_visitante}_{int(time.time())}.png"

        # Verificar si la imagen viene en formato base64 completo
        if "," in visita.foto:
            imagen = visita.foto.split(",")[1]
        else:
            imagen = visita.foto

        # Guardar imagen en carpeta fotos
        with open(nombre_archivo, "wb") as f:
            f.write(base64.b64decode(imagen))

    # Registrar la visita en la base de datos
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
# listar vecinos
@app.get("/vecinos")
def listar_vecinos(usuario_actual: dict = Depends(obtener_usuario_actual)):
    with engine.connect() as conexion:

        resultado = conexion.execute(text("""
            SELECT
                id_vecino,
                nombres,
                apellidos,
                id_vivienda,
                codigo_unico,
                correo,
                telefono,
                estado
            FROM vecinos
            ORDER BY id_vecino
        """))

        return [dict(fila._mapping) for fila in resultado]


# listar visitantes
@app.get("/visitantes")
def listar_visitantes(
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.connect() as conexion:

        resultado = conexion.execute(text("""
            SELECT
                id_visitantes,
                nombres,
                apellidos
            FROM visitantes
            ORDER BY id_visitantes
        """))

        return [dict(fila._mapping) for fila in resultado]


# listar visitas
@app.get("/visitas")
def listar_visitas(
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.connect() as conexion:

        resultado = conexion.execute(text("""
            SELECT *
            FROM visitas
            ORDER BY id_visita DESC
        """))

        return [dict(fila._mapping) for fila in resultado]
    
# CRUD DE VIVIENDAS
# ==========================================================
# CRUD DE VIVIENDAS
# ==========================================================

# LISTAR VIVIENDAS
@app.get("/viviendas")
def listar_viviendas(
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.connect() as conexion:

        resultado = conexion.execute(text("""
            SELECT
                id_vivienda,
                numero_vivienda,
                sector,
                direccion_referencia,
                estado,
                fecha_registro
            FROM viviendas
            ORDER BY id_vivienda
        """))

        return [dict(fila._mapping) for fila in resultado]


# OBTENER VIVIENDA POR ID
@app.get("/viviendas/{id_vivienda}")
def obtener_vivienda(
    id_vivienda: int,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.connect() as conexion:

        vivienda = conexion.execute(text("""
            SELECT
                id_vivienda,
                numero_vivienda,
                sector,
                direccion_referencia,
                estado,
                fecha_registro
            FROM viviendas
            WHERE id_vivienda = :id_vivienda
        """), {
            "id_vivienda": id_vivienda
        }).mappings().first()

    if not vivienda:
        raise HTTPException(
            status_code=404,
            detail="Vivienda no encontrada"
        )

    return dict(vivienda)


# CREAR VIVIENDA
@app.post("/viviendas")
def crear_vivienda(
    vivienda: ViviendaCreate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.begin() as conexion:

        # VALIDAR QUE NO SE REPITA EL NUMERO DE VIVIENDA
        existe = conexion.execute(text("""
            SELECT id_vivienda
            FROM viviendas
            WHERE numero_vivienda = :numero_vivienda
        """), {
            "numero_vivienda": vivienda.numero_vivienda
        }).mappings().first()

        if existe:
            raise HTTPException(
                status_code=400,
                detail="Ya existe una vivienda con ese numero"
            )

        # INSERTAR VIVIENDA
        conexion.execute(text("""
            INSERT INTO viviendas (
                numero_vivienda,
                sector,
                direccion_referencia,
                estado
            )
            VALUES (
                :numero_vivienda,
                :sector,
                :direccion_referencia,
                true
            )
        """), {
            "numero_vivienda": vivienda.numero_vivienda,
            "sector": vivienda.sector,
            "direccion_referencia": vivienda.direccion_referencia
        })

    return {
        "mensaje": "Vivienda creada correctamente"
    }

# ACTUALIZAR VIVIENDA
@app.put("/viviendas/{id_vivienda}")
def actualizar_vivienda(
    id_vivienda: int,
    vivienda: ViviendaUpdate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):

    with engine.begin() as conexion:

        # VALIDAR QUE LA VIVIENDA EXISTA
        existe = conexion.execute(text("""
            SELECT id_vivienda
            FROM viviendas
            WHERE id_vivienda = :id_vivienda
        """), {
            "id_vivienda": id_vivienda
        }).mappings().first()

        if not existe:
            raise HTTPException(
                status_code=404,
                detail="Vivienda no encontrada"
            )

        # VALIDAR QUE EL NUMERO NO SE REPITA EN OTRA VIVIENDA
        repetida = conexion.execute(text("""
            SELECT id_vivienda
            FROM viviendas
            WHERE numero_vivienda = :numero_vivienda
            AND id_vivienda != :id_vivienda
        """), {
            "numero_vivienda": vivienda.numero_vivienda,
            "id_vivienda": id_vivienda
        }).mappings().first()

        if repetida:
            raise HTTPException(
                status_code=400,
                detail="Ya existe otra vivienda con ese numero"
            )

        # ACTUALIZAR VIVIENDA
        conexion.execute(text("""
            UPDATE viviendas
            SET
                numero_vivienda = :numero_vivienda,
                sector = :sector,
                direccion_referencia = :direccion_referencia,
                estado = :estado
            WHERE id_vivienda = :id_vivienda
        """), {
            "numero_vivienda": vivienda.numero_vivienda,
            "sector": vivienda.sector,
            "direccion_referencia": vivienda.direccion_referencia,
            "estado": vivienda.estado,
            "id_vivienda": id_vivienda
        })

    return {
        "mensaje": "Vivienda actualizada correctamente"
    }


# CAMBIAR ESTADO DE VIVIENDA
@app.put("/viviendas/{id_vivienda}/estado")
def cambiar_estado_vivienda(
    id_vivienda: int,
    estado: bool,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):

    with engine.begin() as conexion:

        # VALIDAR QUE LA VIVIENDA EXISTA
        existe = conexion.execute(text("""
            SELECT id_vivienda
            FROM viviendas
            WHERE id_vivienda = :id_vivienda
        """), {
            "id_vivienda": id_vivienda
        }).mappings().first()

        if not existe:
            raise HTTPException(
                status_code=404,
                detail="Vivienda no encontrada"
            )

        # CAMBIAR ESTADO
        conexion.execute(text("""
            UPDATE viviendas
            SET estado = :estado
            WHERE id_vivienda = :id_vivienda
        """), {
            "estado": estado,
            "id_vivienda": id_vivienda
        })

    return {
        "mensaje": "Estado de vivienda actualizado correctamente"
    }
    

    # crear visitante
@app.post("/visitantes")
def crear_visitante(
    visitante: VisitanteCreate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.begin() as conexion:

        conexion.execute(text("""
            INSERT INTO visitantes (
                nombres,
                apellidos
            )
            VALUES (
                :nombres,
                :apellidos
            )
        """), {
            "nombres": visitante.nombres,
            "apellidos": visitante.apellidos
        })

    return {
        "mensaje": "Visitante creado correctamente"
    }


# actualizar visitante
@app.put("/visitantes/{id_visitante}")
def actualizar_visitante(
    id_visitante: int,
    visitante: VisitanteUpdate,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):

    with engine.begin() as conexion:

        conexion.execute(text("""
            UPDATE visitantes
            SET
                nombres = :nombres,
                apellidos = :apellidos
            WHERE id_visitantes = :id_visitante
        """), {
            "nombres": visitante.nombres,
            "apellidos": visitante.apellidos,
            "id_visitante": id_visitante
        })

    return {
        "mensaje": "Visitante actualizado correctamente"
    }


# FUNCION PARA ENVIAR CORREO CON QR

def enviar_correo_qr(correo_destino, nombre_visitante, codigo_qr):

    import smtplib
    import qrcode
    from email.message import EmailMessage
    from io import BytesIO
    # DATOS DEL CORREO EMISOR

    correo_emisor = "garitas041@gmail.com"
    password_app = "yjlj iafz bxny djdl"

    # GENERAR IMAGEN QR
    qr = qrcode.make(codigo_qr)

    buffer = BytesIO()
    qr.save(buffer, format="PNG")

    imagen_qr = buffer.getvalue()

    # CREAR MENSAJE
    mensaje = EmailMessage()

    mensaje["Subject"] = "Codigo QR de visita"
    mensaje["From"] = correo_emisor
    mensaje["To"] = correo_destino

    mensaje.set_content(f"""
Hola.

Tu prerregistro fue creado correctamente.

Codigo QR:
{codigo_qr}

Presenta este QR en la garita.
""")
    # ADJUNTAR IMAGEN QR
    mensaje.add_attachment(
        imagen_qr,
        maintype="image",
        subtype="png",
        filename="codigo_qr.png"
    )
    # ENVIAR CORREO
    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:

        smtp.login(correo_emisor, password_app)

        smtp.send_message(mensaje)

# CREAR PRERREGISTRO
# Guarda una visita autorizada previamente
# y genera un token único para usarlo como QR
@app.post("/prerregistros")
def crear_prerregistro(datos: PrerregistroCreate):

    # Generar código único para el QR
    codigo_qr = str(uuid.uuid4())

    # Guardar prerregistro en la base de datos
    with engine.begin() as conexion:
        resultado = conexion.execute(text("""
        INSERT INTO prerregistros (

            id_vecino,
            nombre_visitante,
            dpi_visitante,
            correo_visitante,
            placa,
            motivo,

            fecha_visita,
            hora_visita,

            codigo_qr,
            estado_qr,
            fecha_creacion

        )

        VALUES (

            :id_vecino,
            :nombre_visitante,
            :dpi_visitante,
            :correo_visitante,
            :placa,
            :motivo,

            CURRENT_DATE,
            CURRENT_TIME,

            :codigo_qr,
            'pendiente',
            CURRENT_TIMESTAMP

        )

        RETURNING id_prerregistro
    """), {
            "id_vecino": datos.id_vecino,
            "nombre_visitante": datos.nombre_visitante,
            "dpi_visitante": datos.dpi_visitante,
            # Guardar correo del visitante
            "correo_visitante": datos.correo_visitante,
            "placa": datos.placa.upper() if datos.placa else None,
            "motivo": datos.motivo_visita,
            "codigo_qr": codigo_qr
        }).mappings().first()


   # ENVIAR CORREO AL VISITANTE
    # Solo se intenta enviar si escribió correo
    if datos.correo_visitante:

        enviar_correo_qr(
            datos.correo_visitante,
            datos.nombre_visitante,
            codigo_qr
        )
    return {
        "mensaje": "Prerregistro creado correctamente",
        "id_prerregistro": resultado["id_prerregistro"],
        "codigo_qr": codigo_qr
    }
# VALIDAR QR EN GARITA
# Busca el código QR y verifica si está pendiente
# NO lo marca como usado aquí

@app.get("/validar_qr/{codigo_qr}")
def validar_qr(codigo_qr: str):

    with engine.begin() as conexion:

        prerregistro = conexion.execute(text("""
            SELECT *
            FROM prerregistros
            WHERE codigo_qr = :codigo_qr
        """), {
            "codigo_qr": codigo_qr
        }).mappings().first()

        # SI NO EXISTE EL QR
        if not prerregistro:
            raise HTTPException(
                status_code=404,
                detail="QR inválido o no encontrado"
            )

        # SI YA FUE UTILIZADO
        if prerregistro["estado_qr"] != "pendiente":
            raise HTTPException(
                status_code=400,
                detail="Este QR ya fue utilizado"
            )

        # RESPUESTA CORRECTA
        return {
            "mensaje": "Acceso autorizado",
            "nombre_visitante": prerregistro["nombre_visitante"],
            "placa": prerregistro["placa"],
            "motivo": prerregistro["motivo"]
        }
# REGISTRAR VISITA AUTOMATICA DESDE QR
@app.post("/registrar_visita_qr/{codigo_qr}")
def registrar_visita_qr(codigo_qr: str):

    with engine.begin() as conexion:

        # Buscar prerregistro por codigo QR
        prerregistro = conexion.execute(text("""
            SELECT 
                p.*,
                v.id_vivienda
            FROM prerregistros p
            INNER JOIN vecinos v
                ON p.id_vecino = v.id_vecino
            WHERE p.codigo_qr = :codigo_qr
        """), {
            "codigo_qr": codigo_qr
        }).mappings().first()

        if not prerregistro:
            raise HTTPException(
                status_code=404,
                detail="QR invalido o no encontrado"
            )

        if prerregistro["estado_qr"] != "pendiente":
            raise HTTPException(
                status_code=400,
                detail="Este QR ya fue utilizado"
            )

        # Buscar si el visitante ya existe para no duplicarlo
        visitante = conexion.execute(text("""
            SELECT id_visitantes
            FROM visitantes
            WHERE LOWER(TRIM(nombres)) = LOWER(TRIM(:nombres))
            LIMIT 1
        """), {
            "nombres": prerregistro["nombre_visitante"]
        }).mappings().first()

        # Si no existe, se crea automaticamente
        if not visitante:
            visitante = conexion.execute(text("""
                INSERT INTO visitantes (
                    nombres,
                    apellidos,
                    telefono
                )
                VALUES (
                    :nombres,
                    '',
                    ''
                )
                RETURNING id_visitantes
            """), {
                "nombres": prerregistro["nombre_visitante"]
            }).mappings().first()


        # Registrar visita automaticamente
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
                1,
                'QR',
                CURRENT_DATE,
                CURRENT_TIME,
                'activa',
                :observaciones,
                NULL,
                :placa
            )
        """), {
            "id_visitante": visitante["id_visitantes"],
            "id_vecino": prerregistro["id_vecino"],
            "id_vivienda": prerregistro["id_vivienda"],
            "observaciones": prerregistro["motivo"],
            "placa": prerregistro["placa"]
        })

        # Ahora si marcar QR como usado
        conexion.execute(text("""
            UPDATE prerregistros
            SET estado_qr = 'usado'
            WHERE codigo_qr = :codigo_qr
        """), {
            "codigo_qr": codigo_qr
        })

    return {
        "mensaje": "Visita registrada automaticamente desde QR"
    }
# registrar salida de visita
@app.put("/visitas/{id_visita}/salida")
def registrar_salida(
    id_visita: int,
    usuario_actual: dict = Depends(obtener_usuario_actual)
):
    with engine.begin() as conexion:

        visita = conexion.execute(text("""
            SELECT *
            FROM visitas
            WHERE id_visita = :id_visita
        """), {
            "id_visita": id_visita
        }).mappings().first()

        if not visita:
            raise HTTPException(
                status_code=404,
                detail="Visita no encontrada"
            )

        conexion.execute(text("""
            UPDATE visitas
            SET
                fecha_salida = CURRENT_DATE,
                hora_salida = CURRENT_TIME,
                estado_visita = 'finalizada'
            WHERE id_visita = :id_visita
        """), {
            "id_visita": id_visita
        })

    return {
        "mensaje": "Salida registrada correctamente"
    }