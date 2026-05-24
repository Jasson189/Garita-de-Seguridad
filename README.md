# Sistema Garita de Seguridad

Proyecto base para el control de ingreso y salida de visitantes en una garita residencial.

## Descripción

Este sistema permite administrar viviendas, vecinos, visitantes, vehículos, visitas y prerregistros con código QR.

Incluye autenticación con JWT, protección de rutas privadas y validación de acceso por QR.

## Tecnologías utilizadas

- Python
- FastAPI
- PostgreSQL
- SQLAlchemy
- HTML
- CSS
- JavaScript
- JWT
- Swagger UI
- pgAdmin
- Visual Studio Code
- Extensión Live Server
- Git

## Funcionalidades principales

- Inicio de sesión con usuario y contraseña.
- Generación de token JWT.
- Protección de rutas privadas.
- Administración de viviendas.
- Administración de vecinos.
- Administración de visitantes.
- Registro de visitas.
- Registro de salida de visitas.
- Captura fotográfica de visitas.
- Prerregistro de visitantes.
- Generación de código QR.
- Validación de código QR.
- Consulta de placas autorizadas.

## Estructura del proyecto

```text
Garita_de_Seguridad_actualizada/
├── backend/
│   ├── main.py
│   ├── database.py
│   └── fotos/
│
├── frontend/
│   ├── index.html
│   ├── login.html
│   ├── admin_vecinos.html
│   ├── admin_viviendas.html
│   ├── admin_visitantes.html
│   ├── preregistro.html
│   ├── css/
│   └── js/
│
├── database/
│   ├── script_actualizado.sql
│   └── garita_entidad_relacion.md
│
├── README.md
├── .gitignore
└── .gitattributes
```

## Requisitos para ejecutar el proyecto

Tener instalado:

- Python 3
- PostgreSQL
- pgAdmin
- Visual Studio Code
- Extensión Live Server en Visual Studio Code
- Git

## Instalación del backend

Entrar a la carpeta del backend:
en la consola poner los siguentes comandos 

```bash
cd backend
```

Instalar las dependencias necesarias:

```bash
pip install fastapi uvicorn sqlalchemy psycopg2-binary python-jose[cryptography] qrcode
```

Ejecutar el servidor:

```bash
uvicorn main:app --reload
```

El backend se ejecutará en:

```text
http://127.0.0.1:8000
```

La documentación Swagger se puede abrir en:

```text
http://127.0.0.1:8000/docs
```

## Configuración de la base de datos

Crear una base de datos en PostgreSQL llamada:

```text
garita_seguridad
```

Luego ejecutar el script SQL ubicado en:

```text
database/script_actualizado.sql
```

Después revisar la conexión en el archivo:

```text
backend/database.py
```

## Ejecución del frontend

Abrir la carpeta del proyecto en Visual Studio Code.

Luego abrir el archivo:

```text
frontend/login.html
```

Dar clic derecho y seleccionar:

```text
Open with Live Server
```

La extensión necesaria para esto es:

```text
Live Server
```

El frontend normalmente se abrirá en una ruta parecida a:

```text
http://127.0.0.1:5500/frontend/login.html
```

## Usuario de prueba

```text
Usuario: admin
Contraseña: 1234
```

## Rutas protegidas

Las siguientes rutas están protegidas con JWT:

```text
/vecinos
/viviendas
/visitantes
/visitas
```

Para probarlas desde Swagger se debe usar el botón **Authorize** y colocar el token generado en el login.

## Rutas públicas

Algunas rutas se dejaron públicas por funcionamiento operativo del sistema:

```text
/login
/vehiculos/placa/{placa}
/validar_qr/{codigo_qr}
/registrar_visita_qr/{codigo_qr}
```

## Estado del proyecto

El proyecto se encuentra funcional para entrega base.

Cuenta con autenticación, rutas protegidas, CRUD principal, registro de visitas, prerregistro y validación QR.

## Notas adicionales

- El backend debe estar ejecutándose antes de usar el frontend.
- La base de datos debe estar creada y configurada antes de iniciar el sistema.
- Para que el envío de correo con QR funcione, se debe configurar correctamente el correo emisor y la contraseña de aplicación de Gmail en el backend.
- Las imágenes o fotos de prueba generadas por el sistema se guardan en la carpeta `backend/fotos/`.
- para pate de valir qr en parte main donde esta correo probar con un correo nuevo o de prueba para el funcionamiento.