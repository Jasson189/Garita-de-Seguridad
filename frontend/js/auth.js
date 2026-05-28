// Validacion de sesion, token JWT,
// usuario logueado, fecha/hora,
// cierre de sesion y roles

// OBTENER DATOS DE SESION
const tokenSesion = localStorage.getItem("token");
const usuarioSesion = localStorage.getItem("usuario");
const rolSesion = localStorage.getItem("rol");

    // LIMPIAR SESION
function limpiarSesion() {
    localStorage.removeItem("token");
    localStorage.removeItem("usuario");
    localStorage.removeItem("rol");
    localStorage.removeItem("id_usuario");
}

// VALIDAR SESION GENERAL
if (!tokenSesion) {

    // Si no hay token, enviar al login
    window.location.replace("login.html");

} else {

// MOSTRAR USUARIO LOGUEADO
    const nombreUsuario = document.getElementById("nombreUsuario");

    if (nombreUsuario) {
        nombreUsuario.textContent =
            "Usuario: " + (usuarioSesion || "No identificado");
    }

 // MOSTRAR FECHA Y HORA
 function mostrarFecha() {
        const fechaTurno = document.getElementById("fecha-turno");

        // Si la pagina no tiene este elemento, no hace nada
        if (!fechaTurno) {
            return;
        }

    function actualizarHora() {
            const ahora = new Date();

            fechaTurno.textContent =
                "Fecha y hora: " + ahora.toLocaleString("es-GT");
        }

        actualizarHora();

        setInterval(actualizarHora, 1000);
    }
// CERRAR SESION
    const btnCerrarSesion = document.getElementById("btnCerrarSesion");

if (btnCerrarSesion) {
        btnCerrarSesion.addEventListener("click", function () {
            limpiarSesion();

            // Redirigir al login y evitar volver con atras
            window.location.replace("login.html");
        });
    }


    // INICIAR FECHA Y HORA
    mostrarFecha();
}

    // VALIDAR ROL
function validarRol(rolesPermitidos) {

    // Si no hay token, enviar al login
    if (!tokenSesion) {
        window.location.replace("login.html");
        return;
    }

    // Si no hay rol, cerrar sesion por seguridad
    if (!rolSesion) {
        alert("No se pudo identificar el rol del usuario.");
        limpiarSesion();
        window.location.replace("login.html");
        return;
    }

    // Validar si el rol esta permitido
    if (!rolesPermitidos.includes(rolSesion)) {

        alert("No tienes permiso para acceder a esta pagina.");

        if (rolSesion === "Vecino") {
            window.location.replace("vecino_panel.html");
            return;
        }

        window.location.replace("index.html");
    }
}