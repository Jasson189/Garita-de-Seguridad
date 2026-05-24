/*<!-- JAVASCRIPT DEL LOGIN -->
*<!-- Conecta el formulario con el backend FastAPI -->*/


/* CAPTURAR ELEMENTOS DEL HTML */
const loginForm = document.getElementById("loginForm");
const mensaje = document.getElementById("mensaje");


/* EVENTO AL ENVIAR FORMULARIO */
loginForm.addEventListener("submit", async function (evento) {

    // Evita que la pagina se recargue
    evento.preventDefault();

    // Obtener valores escritos por el usuario
    const usuario = document.getElementById("usuario").value;
    const contrasena = document.getElementById("contrasena").value;

    try {

        /* PETICION AL BACKEND */
        const response = await fetch(API + "/login", {
            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                nombre_usuario: usuario,
                contrasena: contrasena
            })
        });

        const data = await response.json();

        /* SI EL LOGIN ES CORRECTO */
        if (response.ok) {

            mensaje.style.color = "green";
            mensaje.textContent = "Login correcto. Redirigiendo...";

            // Guardar usuario en el navegador
            localStorage.setItem("usuario", JSON.stringify(data.usuario));

            // Preparado para cuando el backend devuelva token/JWT
            if (data.access_token) {
                localStorage.setItem("token", data.access_token);
            }

            // Redirigir al sistema principal
            setTimeout(() => {
                window.location.replace("index.html");
            }, 1000);
        }

        /* SI EL LOGIN FALLA */
        else {
            mensaje.style.color = "red";
            mensaje.textContent =
                data.detail || "Usuario o contraseña incorrectos";
        }

    } catch (error) {

        /* ERROR DE CONEXION */
        mensaje.style.color = "red";
        mensaje.textContent = "No se pudo conectar con el servidor";

        console.log(error);
    }
});