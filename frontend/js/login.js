/* Login conectado a FastAPI.
   Guarda token JWT y redirige segun el rol del usuario.
*/


// URL del backend desde config.js
const URL_BACKEND_LOGIN =   
    typeof API !== "undefined"
        ? API
        : "http://127.0.0.1:8000";

    // Capturar elementos
const loginForm = document.getElementById("loginForm");
const inputUsuario = document.getElementById("usuario");
const inputContrasena = document.getElementById("contrasena");
const mensaje = document.getElementById("mensaje");

    // Evento del formulario
loginForm.addEventListener("submit", async function (evento) {

       evento.preventDefault();

    const nombreUsuario = inputUsuario.value.trim();
    const contrasena = inputContrasena.value.trim();

    if (!nombreUsuario || !contrasena) {
        mostrarMensaje("Ingresa usuario y contraseña.", "error");
        return;
    }

    try {

        mostrarMensaje("Iniciando sesión...", "info");

        const respuesta = await fetch(URL_BACKEND_LOGIN + "/login", {
            method: "POST",
           headers: {
                "Content-Type": "application/json"
          },
            body: JSON.stringify({
                nombre_usuario: nombreUsuario,
                contrasena: contrasena
            })
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            mostrarMensaje(
                data.detail || "Usuario o contraseña incorrectos.",
                "error"
            );
            return;
        }

        if (!data.access_token) {
            mostrarMensaje("El backend no devolvió token.", "error");
            return;
        }

        // Guardar token
        localStorage.setItem("token", data.access_token);

        // Decodificar token
        const datosToken = decodificarToken(data.access_token);

        /*
           Compatibilidad:
           - Si backend devuelve data.rol
           - Si backend devuelve data.usuario.rol
           - Si backend devuelve data.usuario.nombre_rol
           - Si el token trae rol
        */
        const rol =
            data.rol ||
            data.nombre_rol ||
            data.usuario?.rol ||
            data.usuario?.nombre_rol ||
            datosToken.rol ||
            "";

        const usuario =
            data.nombre_usuario ||
            data.usuario?.nombre_usuario ||
            datosToken.nombre_usuario ||
            nombreUsuario;

        const idUsuario =
            data.id_usuario ||
            data.usuario?.id_usuario ||
            data.usuario?.id_usuarios ||
            datosToken.sub ||
            "";

        // Guardar datos de sesión
        localStorage.setItem("rol", rol);
        localStorage.setItem("usuario", usuario);
        localStorage.setItem("id_usuario", idUsuario);

        mostrarMensaje("Login correcto. Redirigiendo...", "exito");

        setTimeout(() => {
            redirigirSegunRol(rol);
        }, 600);

    } catch (error) {

        console.error("Error en login:", error);

        mostrarMensaje(
            "No se pudo conectar con el servidor. Verifica que FastAPI esté encendido.",
            "error"
        );
    }
});

    // Redirigir según rol
function redirigirSegunRol(rol) {

    console.log("ROL DETECTADO:", rol);

    if (rol === "Vecino") {
        window.location.replace("vecino_panel.html");
        return;
    }

    if (rol === "Administrador") {
        window.location.replace("index.html");
        return;
    }

    if (rol === "Agente") {
        window.location.replace("index.html");
        return;
    }

    mostrarMensaje("No se pudo identificar el rol del usuario.", "error");

    localStorage.removeItem("token");
    localStorage.removeItem("usuario");
    localStorage.removeItem("rol");
    localStorage.removeItem("id_usuario");
}

    // Mostrar mensajes
function mostrarMensaje(texto, tipo) {

    mensaje.textContent = texto;
    mensaje.className = "mensaje";

    if (tipo === "error") {
        mensaje.style.color = "#dc2626";
    } else if (tipo === "exito") {
        mensaje.style.color = "#16a34a";
    } else {
        mensaje.style.color = "#2563eb";
    }
}

    // Decodificar JWT
function decodificarToken(token) {

    try {

        const payload = token.split(".")[1];

        const base64 = payload
            .replace(/-/g, "+")
            .replace(/_/g, "/");

        const payloadDecodificado = atob(base64);

        return JSON.parse(payloadDecodificado);

    } catch (error) {

        console.log("No se pudo decodificar el token:", error);
        return {};
    }
}