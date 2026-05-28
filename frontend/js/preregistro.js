// Generacion de prerregistro con QR
// Capturamos el formulario
const form = document.getElementById("formPrerregistro");

// FUNCION PARA OBTENER TOKEN
function obtenerTokenPrerregistro() {
    const token = localStorage.getItem("token");

    if (!token) {
        localStorage.removeItem("usuario");
        localStorage.removeItem("token");
        localStorage.removeItem("rol");
        window.location.replace("login.html");
        return null;
    }

    return token;
}

// EVENTO AL ENVIAR FORMULARIO
form.addEventListener("submit", async function (evento) {
    evento.preventDefault();

    const token = obtenerTokenPrerregistro();

    if (!token) {
        return;
    }

    const nombre_visitante = document.getElementById("nombre_visitante").value.trim();
    const dpi_visitante = document.getElementById("dpi_visitante").value.trim();
    const correo_visitante = document.getElementById("correo_visitante").value.trim();
    const placa = document.getElementById("placa").value.trim();
    const motivo_visita = document.getElementById("motivo_visita").value.trim();

    // Se mantiene como estaba para no romper la logica actual
    const id_vecino = 1;

    try {
        const respuesta = await fetch(API + "/prerregistros", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            },
            body: JSON.stringify({
                id_vecino,
                nombre_visitante,
                dpi_visitante,
                correo_visitante,
                placa,
                motivo_visita
            })
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            document.getElementById("mensaje").textContent =
                data.detail || "Error al crear prerregistro.";
            return;
        }

        document.getElementById("mensaje").textContent =
            data.mensaje || "Prerregistro creado correctamente.";

        document.getElementById("codigoQR").textContent =
            "Código QR: " + data.codigo_qr;

        document.getElementById("contenedorQR").innerHTML = "";

        QRCode.toCanvas(data.codigo_qr, function (error, canvas) {
            if (error) {
                console.error(error);
                document.getElementById("mensaje").textContent =
                    "Prerregistro creado, pero no se pudo generar el QR visual.";
                return;
            }

            document.getElementById("contenedorQR").appendChild(canvas);
        });

        form.reset();

    } catch (error) {
        console.error("Error creando prerregistro:", error);

        document.getElementById("mensaje").textContent =
            "Error al conectar con el servidor.";
    }
});