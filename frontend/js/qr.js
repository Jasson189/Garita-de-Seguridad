// VALIDAR CODIGO QR EN GARITA
async function validarQR() {

    const codigoQR =
        document.getElementById("codigoQRValidar").value.trim();

    const resultado =
        document.getElementById("resultadoQR");

    if (codigoQR === "") {

        resultado.style.color = "red";

        resultado.textContent =
            "Ingrese o escanee un código QR.";

        return;
    }

    const res =
        await fetch(API + "/validar_qr/" + codigoQR);

    const data =
            await res.json();



            if (res.ok) {

                resultado.style.color = "green";
            
                resultado.textContent =
                    data.mensaje;
            
                try {
            
                    // REGISTRAR VISITA AUTOMATICAMENTE
                    await registrarVisitaDesdeQR(codigoQR);
            
                    resultado.textContent =
                        data.mensaje + " - Visita registrada correctamente.";
            
                } catch (error) {
            
                    resultado.style.color = "red";
            
                    resultado.textContent =
                        error.message;
                }
            
            } else {

        resultado.style.color = "red";

        resultado.textContent =
            data.detail || "QR inválido.";
    }
}

// FUNCION PARA REGISTRAR VISITA DESDE QR
async function registrarVisitaDesdeQR(codigoQR) {

    const res = await fetch(
        API + "/registrar_visita_qr/" + codigoQR,
        {
            method: "POST"
        }
    );

    const data = await res.json();

    if (!res.ok) {

        throw new Error(
            data.detail || "No se pudo registrar la visita"
        );
    }

    console.log(data);

}
// VARIABLE GLOBAL PARA CONTROLAR EL LECTOR QR
let lectorQRActivo = null;


// ESCANEAR QR CON CAMARA
function iniciarEscanerQR() {

    // EVITAR ABRIR DOS CAMARAS
    if (lectorQRActivo !== null) {
        return;
    }

    lectorQRActivo =
        new Html5Qrcode("lectorQR");

    lectorQRActivo.start(
        { facingMode: "environment" },
        {
            fps: 10,
            qrbox: 250
        },

        async function(codigoQR) {

            // PONER CODIGO EN INPUT
            document.getElementById("codigoQRValidar").value =
                codigoQR;

            // DETENER CAMARA
            await lectorQRActivo.stop();

            lectorQRActivo = null;

            // VALIDAR QR AUTOMATICAMENTE
            await validarQR();
        },

        function(error) {

            // IGNORAR ERRORES NORMALES
        }
    );
}