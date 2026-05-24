/* Capturamos el formulario */
const form = document.getElementById("formPrerregistro");

/* Evento al enviar formulario */
form.addEventListener("submit", async function(evento) {

    evento.preventDefault();

    const nombre_visitante = document.getElementById("nombre_visitante").value;
    const dpi_visitante = document.getElementById("dpi_visitante").value;
    const correo_visitante = document.getElementById("correo_visitante").value;
    const placa = document.getElementById("placa").value;
    const motivo_visita = document.getElementById("motivo_visita").value;

    const id_vecino = 1;

    const respuesta = await fetch(API + "/prerregistros", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
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

    document.getElementById("mensaje").textContent = data.mensaje;

    document.getElementById("codigoQR").textContent =
        "Código QR: " + data.codigo_qr;

    document.getElementById("contenedorQR").innerHTML = "";

    QRCode.toCanvas(data.codigo_qr, function(error, canvas) {

        if (error) {
            console.error(error);
            return;
        }

        document.getElementById("contenedorQR").appendChild(canvas);
    });
});