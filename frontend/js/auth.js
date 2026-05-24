// =========================================
// AUTH.JS
// Sistema Garita de Seguridad
// Validacion de sesion, usuario logueado,
// fecha/hora, cierre de sesion y roles
// =========================================


// VALIDAR SESION
const usuarioGuardado = localStorage.getItem("usuario");

let usuarioSesion = null;

if (!usuarioGuardado) {

    // Si no hay sesion, enviar al login
    window.location.replace("login.html");

} else {

    usuarioSesion = JSON.parse(usuarioGuardado);


    // =========================================
    // MOSTRAR USUARIO LOGUEADO
    // =========================================
    const nombreUsuario = document.getElementById("nombreUsuario");

    if (nombreUsuario) {
        nombreUsuario.textContent =
            "Usuario: " + usuarioSesion.nombre_usuario;
    }


    // =========================================
    // MOSTRAR FECHA Y HORA
    // =========================================
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


    // =========================================
    // CERRAR SESION
    // =========================================
    const btnCerrarSesion = document.getElementById("btnCerrarSesion");

    if (btnCerrarSesion) {

        btnCerrarSesion.addEventListener("click", function () {

            // Eliminar datos de sesion
            localStorage.removeItem("usuario");

            // Preparado para cuando usemos token/JWT
            localStorage.removeItem("token");

            // Redirigir al login y evitar volver con atras
            window.location.replace("login.html");
        });
    }


    // INICIAR FECHA Y HORA
    mostrarFecha();
}


// =========================================
// VALIDAR ROL
// =========================================
function validarRol(rolesPermitidos) {

    // Si no hay usuario cargado, enviar al login
    if (!usuarioSesion) {
        window.location.replace("login.html");
        return;
    }

    // Obtener rol del usuario
    const rolUsuario = usuarioSesion.rol;

    // Validar si el rol esta permitido
    if (!rolesPermitidos.includes(rolUsuario)) {

        alert("No tienes permiso para acceder a esta pagina.");

        window.location.replace("index.html");
    }
}