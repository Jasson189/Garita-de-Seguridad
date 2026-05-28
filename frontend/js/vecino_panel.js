    // Control del panel visual del Vecino.
// Carga perfil, vivienda, historial de visitas,
// genera prerregistros y consulta placas usando JWT.

// URL base del backend FastAPI
const API_BASE = "http://127.0.0.1:8000";

// Token guardado desde el login
const token = localStorage.getItem("token");

    // ELEMENTOS DEL HTML
    // Mensajes y sesión
const mensajeSistema = document.getElementById("mensajeSistema");
const btnCerrarSesion = document.getElementById("btnCerrarSesion");

// Datos del vecino
const vecinoNombre = document.getElementById("vecinoNombre");
const vecinoCorreo = document.getElementById("vecinoCorreo");
const vecinoTelefono = document.getElementById("vecinoTelefono");
const vecinoCodigo = document.getElementById("vecinoCodigo");

// Datos de vivienda
const viviendaNumero = document.getElementById("viviendaNumero");
const viviendaSector = document.getElementById("viviendaSector");
const viviendaEstado = document.getElementById("viviendaEstado");

// Formulario prerregistro
const formPrerregistro = document.getElementById("formPrerregistro");
const nombreVisitante = document.getElementById("nombreVisitante");
const dpiVisitante = document.getElementById("dpiVisitante");
const placaVisitante = document.getElementById("placaVisitante");
const motivoVisita = document.getElementById("motivoVisita");

// Resultado QR
const resultadoQR = document.getElementById("resultadoQR");
const codigoQRGenerado = document.getElementById("codigoQRGenerado");
const contenedorImagenQR = document.getElementById("contenedorImagenQR");

// Historial
const tablaHistorial = document.getElementById("tablaHistorial");
const btnActualizarHistorial = document.getElementById("btnActualizarHistorial");

// Consulta placa
const formConsultarPlaca = document.getElementById("formConsultarPlaca");
const placaConsulta = document.getElementById("placaConsulta");
const resultadoPlaca = document.getElementById("resultadoPlaca");

    // VALIDACION INICIAL
    document.addEventListener("DOMContentLoaded", async () => {

    const rol = localStorage.getItem("rol");

    if (!token) {
        window.location.href = "login.html";
        return;
    }

    if (rol !== "Vecino") {
        alert("No tienes permiso para acceder al panel del vecino.");

        if (rol === "Administrador" || rol === "Agente") {
            window.location.href = "index.html";
        } else {
            window.location.href = "login.html";
        }

        return;
    }

    await cargarPanelVecino();

});

    // PETICION PROTEGIDA CON TOKEN
async function peticionProtegida(endpoint, opciones = {}) {

    const respuesta = await fetch(`${API_BASE}${endpoint}`, {
        ...opciones,
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`,
            ...(opciones.headers || {})
        }
    });

    let data = null;

    try {
        data = await respuesta.json();
    } catch (error) {
        data = null;
    }

    if (respuesta.status === 401 || respuesta.status === 403) {

        localStorage.removeItem("token");
        localStorage.removeItem("usuario");
        localStorage.removeItem("rol");

        mostrarMensaje("Sesión vencida o sin permisos. Inicia sesión nuevamente.", "error");

        setTimeout(() => {
            window.location.href = "login.html";
        }, 1200);

        throw new Error("No autorizado");
    }

    if (!respuesta.ok) {
        const detalle = data?.detail || "Ocurrió un error en la petición.";
        throw new Error(detalle);
    }

    return data;
}

    // CARGAR TODO EL PANEL
async function cargarPanelVecino() {

    try {
        mostrarMensaje("Cargando información del vecino...", "info");

        await cargarPerfilVecino();
        await cargarViviendaVecino();
        await cargarHistorialVisitas();

        ocultarMensaje();

    } catch (error) {
        mostrarMensaje(error.message, "error");
        console.error("Error al cargar panel:", error);
    }
}

    // PERFIL DEL VECINO
async function cargarPerfilVecino() {

    try {
        const data = await peticionProtegida("/vecino/perfil");

        vecinoNombre.textContent = data.nombre || "No registrado";
        vecinoCorreo.textContent = data.correo || "No registrado";
        vecinoTelefono.textContent = data.telefono || "No registrado";
        vecinoCodigo.textContent = data.codigo_unico || "Sin código";

    } catch (error) {
        vecinoNombre.textContent = "No disponible";
        vecinoCorreo.textContent = "No disponible";
        vecinoTelefono.textContent = "No disponible";
        vecinoCodigo.textContent = "No disponible";

        throw error;
    }
}

    // VIVIENDA DEL VECINO
    async function cargarViviendaVecino() {

    try {
        const data = await peticionProtegida("/vecino/vivienda");

        viviendaNumero.textContent = data.numero_vivienda || data.numero || "No registrada";
        viviendaSector.textContent = data.sector || "No registrado";
        viviendaEstado.textContent = data.estado ? "Activa" : "Inactiva";

    } catch (error) {
        viviendaNumero.textContent = "No disponible";
        viviendaSector.textContent = "No disponible";
        viviendaEstado.textContent = "No disponible";

        console.warn("No se pudo cargar vivienda:", error.message);
    }
}

    // HISTORIAL DE VISITAS
    async function cargarHistorialVisitas() {

    try {
        const visitas = await peticionProtegida("/vecino/visitas");

        renderizarHistorial(visitas);

    } catch (error) {
        tablaHistorial.innerHTML = `
            <tr>
                <td colspan="5">
                    No se pudo cargar el historial de visitas.
                </td>
            </tr>
        `;

        console.warn("No se pudo cargar historial:", error.message);
    }
}

function renderizarHistorial(visitas) {

    tablaHistorial.innerHTML = "";

    if (!Array.isArray(visitas) || visitas.length === 0) {
        tablaHistorial.innerHTML = `
            <tr>
                <td colspan="5">
                    No hay visitas registradas para tu vivienda.
                </td>
            </tr>
        `;
        return;
    }

    visitas.forEach((visita) => {

        const fila = document.createElement("tr");

        fila.innerHTML = `
            <td>${visita.nombre_visitante || "Sin nombre"}</td>
            <td>${visita.placa || "Sin placa"}</td>
            <td>${visita.motivo || "Sin motivo"}</td>
            <td>
                <span class="estado ${obtenerClaseEstado(visita.estado)}">
                    ${visita.estado || "Pendiente"}
                </span>
            </td>
            <td>${formatearFecha(visita.fecha)}</td>
        `;

        tablaHistorial.appendChild(fila);
    });
}

// Botón actualizar historial
btnActualizarHistorial.addEventListener("click", async () => {
    mostrarMensaje("Actualizando historial...", "info");
    await cargarHistorialVisitas();
    ocultarMensaje();
});

    // GENERAR PRERREGISTRO
formPrerregistro.addEventListener("submit", async (evento) => {
    evento.preventDefault();

    const datos = {
        nombre_visitante: nombreVisitante.value.trim(),
        dpi_visitante: dpiVisitante.value.trim() || null,
        correo_visitante: null,
        placa: placaVisitante.value.trim().toUpperCase() || null,
        motivo_visita: motivoVisita.value.trim() || null
    };

    if (!datos.nombre_visitante) {
        mostrarMensaje("El nombre del visitante es obligatorio.", "error");
        return;
    }

    if (!datos.motivo_visita) {
        mostrarMensaje("El motivo de visita es obligatorio.", "error");
        return;
    }

    try {
        mostrarMensaje("Generando prerregistro...", "info");

        const data = await peticionProtegida("/vecino/prerregistro", {
            method: "POST",
            body: JSON.stringify(datos)
        });

        mostrarMensaje("Prerregistro generado correctamente.", "exito");

        mostrarResultadoQR(data);

        formPrerregistro.reset();

        await cargarHistorialVisitas();

    } catch (error) {
        mostrarMensaje(error.message, "error");
        console.error("Error al generar prerregistro:", error);
    }
});

    // MOSTRAR RESULTADO QR
    function mostrarResultadoQR(data) {

    resultadoQR.classList.remove("oculto");

    const codigo = data.codigo_qr || data.codigo || "Código generado";

    codigoQRGenerado.textContent = codigo;

    contenedorImagenQR.innerHTML = `
        <p class="texto-ayuda">
            Código QR generado correctamente. 
            Código: <strong>${codigo}</strong>
        </p>
    `;

    // Si después el backend devuelve imagen QR en base64, esto ya queda preparado
    if (data.qr_base64) {
        contenedorImagenQR.innerHTML = "";

        const img = document.createElement("img");
        img.src = `data:image/png;base64,${data.qr_base64}`;
        img.alt = "Código QR";

        contenedorImagenQR.appendChild(img);
    }

    // Si después el backend devuelve una URL de QR, también queda preparado
    if (data.qr_url) {
        contenedorImagenQR.innerHTML = "";

        const img = document.createElement("img");
        img.src = data.qr_url;
        img.alt = "Código QR";

        contenedorImagenQR.appendChild(img);
    }
}

    // CONSULTAR PLACA
    formConsultarPlaca.addEventListener("submit", async (evento) => {
    evento.preventDefault();

    const placa = placaConsulta.value.trim().toUpperCase();

    if (!placa) {
        mostrarMensaje("Ingresa una placa para consultar.", "error");
        return;
    }

    try {
        mostrarMensaje("Consultando placa...", "info");

        const data = await peticionProtegida(`/vecino/consultar-placa/${placa}`);

        mostrarResultadoPlaca(data);

        ocultarMensaje();

    } catch (error) {
        resultadoPlaca.classList.remove("oculto");

        resultadoPlaca.innerHTML = `
            <h3>Resultado de consulta</h3>
            <p>No se pudo consultar la placa.</p>
        `;

        mostrarMensaje(error.message, "error");
        console.error("Error al consultar placa:", error);
    }
});

function mostrarResultadoPlaca(data) {

    resultadoPlaca.classList.remove("oculto");

    if (!data || data.encontrado === false) {
        resultadoPlaca.innerHTML = `
            <h3>Resultado de consulta</h3>
            <p><strong>Placa:</strong> ${data?.placa || "No registrada"}</p>
            <p>${data?.mensaje || "No se encontró información relacionada con esta placa."}</p>
        `;
        return;
    }

    resultadoPlaca.innerHTML = `
        <h3>Resultado de consulta</h3>

        <p>
            <strong>Placa:</strong>
            ${data.placa || "No registrada"}
        </p>

        <p>
            <strong>Visitante:</strong>
            ${data.nombre_visitante || "No registrado"}
        </p>

        <p>
            <strong>Estado:</strong>
            ${data.estado || "No registrado"}
        </p>

        <p>
            <strong>Motivo:</strong>
            ${data.motivo || "No registrado"}
        </p>

        <p>
            <strong>Vivienda relacionada:</strong>
            ${data.numero_vivienda || "No registrada"}
        </p>

        <p>
            <strong>Fecha:</strong>
            ${formatearFecha(data.fecha)}
        </p>
    `;
}

    // CERRAR SESION
btnCerrarSesion.addEventListener("click", () => {

    localStorage.removeItem("token");
    localStorage.removeItem("usuario");
    localStorage.removeItem("rol");
    localStorage.removeItem("id_usuario");

    window.location.href = "login.html";
});

// FUNCIONES AUXILIARES
    function mostrarMensaje(texto, tipo) {
    mensajeSistema.textContent = texto;
    mensajeSistema.className = `mensaje ${tipo}`;
}

function ocultarMensaje() {
    mensajeSistema.className = "mensaje oculto";
    mensajeSistema.textContent = "";
}

function formatearFecha(fecha) {

    if (!fecha) {
        return "Sin fecha";
    }

    const fechaObj = new Date(fecha);

    if (isNaN(fechaObj.getTime())) {
        return fecha;
    }

    return fechaObj.toLocaleString("es-GT", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit"
    });
}

function obtenerClaseEstado(estado) {

    const estadoLimpio = String(estado || "").toLowerCase();

    if (estadoLimpio.includes("autorizado")) {
        return "autorizado";
    }

    if (estadoLimpio.includes("ingresado")) {
        return "autorizado";
    }

    if (estadoLimpio.includes("pendiente")) {
        return "pendiente";
    }

    if (estadoLimpio.includes("denegado")) {
        return "denegado";
    }

    if (
        estadoLimpio.includes("salio") ||
        estadoLimpio.includes("salió") ||
        estadoLimpio.includes("finalizado")
    ) {
        return "finalizado";
    }

    return "pendiente";
}