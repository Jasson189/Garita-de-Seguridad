// Validar QR manualmente y escanear QR con cámara
// VARIABLE GLOBAL PARA CONTROLAR EL LECTOR QR
let lectorQRActivo = null;

// OBTENER TOKEN
function obtenerTokenQR() {
    const token = localStorage.getItem("token");

    if (!token) {
        alert("Sesión expirada. Inicia sesión nuevamente.");
        window.location.replace("login.html");
        return null;
    }

    return token;
}

// VALIDAR CODIGO QR EN GARITA
async function validarQR() {
    const inputQR = document.getElementById("codigoQRValidar");
    const resultado = document.getElementById("resultadoQR");

    if (!inputQR || !resultado) {
        alert("No se encontró el formulario de validación QR.");
        return;
    }

    const codigoQR = inputQR.value.trim();

    if (codigoQR === "") {
        resultado.style.color = "red";
        resultado.textContent = "Ingrese o escanee un código QR.";
        return;
    }

    const token = obtenerTokenQR();

    if (!token) {
        return;
    }

    try {
        const res = await fetch(API + "/validar_qr/" + codigoQR, {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const data = await res.json();

        if (!res.ok) {
            resultado.style.color = "red";
            resultado.textContent = data.detail || "QR inválido.";
            return;
        }

        resultado.style.color = "green";
        resultado.textContent = data.mensaje || "QR válido.";

        try {
            await registrarVisitaDesdeQR(codigoQR);

            resultado.style.color = "green";
            resultado.textContent =
                (data.mensaje || "QR válido") + " - Visita registrada correctamente.";

            if (typeof cargarVisitas === "function") {
                await cargarVisitas();
            }

        } catch (error) {
            resultado.style.color = "red";
            resultado.textContent = error.message;
        }

    } catch (error) {
        console.error("Error validando QR:", error);

        resultado.style.color = "red";
        resultado.textContent = "Error al conectar con el servidor.";
    }
}

// REGISTRAR VISITA DESDE QR
async function registrarVisitaDesdeQR(codigoQR) {
    const token = obtenerTokenQR();

    if (!token) {
        return;
    }

    const res = await fetch(
        API + "/registrar_visita_qr/" + codigoQR,
        {
            method: "POST",
            headers: {
                "Authorization": "Bearer " + token
            }
        }
    );

    const data = await res.json();

    if (!res.ok) {
           throw new Error(
            data.detail || "No se pudo registrar la visita desde QR."
        );
    }

    console.log("Visita registrada desde QR:", data);

    return data;
    }

// ESCANEAR QR CON CAMARA
function iniciarEscanerQR() {
    const resultado = document.getElementById("resultadoQR");
    const contenedorQR = document.getElementById("lectorQR");

    if (!contenedorQR) {
        alert("No se encontró el contenedor del lector QR.");
        return;
    }

    if (typeof Html5Qrcode === "undefined") {
        alert("No se cargó la librería para escanear QR. Revisa index.html.");
        return;
    }

    // Evitar abrir dos cámaras
    if (lectorQRActivo !== null) {
        return;
    }

    if (resultado) {
        resultado.style.color = "#2563eb";
        resultado.textContent = "Activando cámara para escanear QR...";
    }

    lectorQRActivo = new Html5Qrcode("lectorQR");

    lectorQRActivo.start(
        { facingMode: "environment" },
        {
            fps: 10,
            qrbox: {
                width: 250,
                height: 250
            }
        },

        async function (codigoQR) {
            const inputQR = document.getElementById("codigoQRValidar");

            if (inputQR) {
                inputQR.value = codigoQR;
            }

            await detenerEscanerQR();

            await validarQR();
        },

        function () {
            // Los errores de lectura normales se ignoran para no llenar consola.
        }
    ).catch(function (error) {
        console.error("Error al iniciar lector QR:", error);

        lectorQRActivo = null;

        if (resultado) {
            resultado.style.color = "red";
            resultado.textContent =
                "No se pudo abrir la cámara para escanear QR. Revisa permisos del navegador.";
        }
    });
}

// DETENER ESCANER QR
async function detenerEscanerQR() {
    if (lectorQRActivo !== null) {
        try {
            await lectorQRActivo.stop();
            await lectorQRActivo.clear();
        } catch (error) {
            console.error("Error al detener lector QR:", error);
        }

        lectorQRActivo = null;
    }
}