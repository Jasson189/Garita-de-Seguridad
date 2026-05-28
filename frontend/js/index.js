// Panel principal: registro de visitas,
// ingresos, salidas, métricas, fotos,
// QR y usuario logueado

// VARIABLES GLOBALES
let mapaVisitantes = {};
let mapaVecinos = {};
let mapaViviendasVecino = {};
let mapaFotosVisitas = {};
let imagenBase64 = "";
let todasLasVisitas = [];

// ELEMENTOS DEL HTML
const selectsPanel = document.querySelectorAll("select");

const selectVisitante =
    document.getElementById("selectVisitante") ||
    document.getElementById("visitante") ||
    document.getElementById("id_visitante") ||
    document.getElementById("idVisitante") ||
    document.getElementById("visitanteSelect") ||
    document.getElementById("selectVisitantes") ||
    selectsPanel[0];

const selectVecino =
    document.getElementById("selectVecino") ||
    document.getElementById("vecino") ||
    document.getElementById("id_vecino") ||
    document.getElementById("idVecino") ||
    document.getElementById("vecinoSelect") ||
    document.getElementById("selectVecinos") ||
    selectsPanel[1];

const inputPlaca =
    document.getElementById("placaVehiculo") ||
    document.getElementById("placa_vehiculo") ||
    document.getElementById("placa") ||
    document.getElementById("placaVehiculoInput") ||
    document.querySelector('input[placeholder="P123ABC"]') ||
    document.querySelector('input[placeholder*="placa"]') ||
    document.querySelector('input[placeholder*="Placa"]');

const inputObservaciones =
    document.getElementById("observaciones") ||
    document.getElementById("motivo_visita") ||
    document.getElementById("observacionesVisita");

const tablaVisitas =
    document.getElementById("tablaVisitas") ||
    document.getElementById("tbodyVisitas") ||
    document.querySelector("tbody");

const mensajeSistema =
    document.getElementById("mensaje") ||
    document.getElementById("mensajeSistema") ||
    document.querySelector(".mensaje") ||
    document.querySelector(".alerta");

const buscadorHistorial =
    document.getElementById("buscador") ||
    document.getElementById("buscarHistorial") ||
    document.querySelector(".search-wrap input");

// MOSTRAR USUARIO LOGUEADO
function mostrarUsuarioLogueado() {
    const nombreUsuarioHeader = document.getElementById("nombreUsuario");
    const usuarioLogueado = localStorage.getItem("usuario");

    if (nombreUsuarioHeader) {
        nombreUsuarioHeader.textContent =
            "Usuario: " + (usuarioLogueado || "No identificado");
    }
}

// MOSTRAR FECHA Y HORA
function mostrarFecha() {
    const fechaTurno = document.getElementById("fecha-turno");

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

// OBTENER TOKEN
function obtenerTokenIndex() {
    const token = localStorage.getItem("token");

    if (!token) {
        limpiarSesionIndex();
        window.location.replace("login.html");
        return null;
    }

    return token;
}

// OBTENER ID DEL USUARIO LOGUEADO
function obtenerIdUsuarioLogueado() {
    const idUsuario =
        localStorage.getItem("id_usuario") ||
        localStorage.getItem("id_usuarios") ||
        localStorage.getItem("usuario_id");

    if (!idUsuario || idUsuario === "undefined" || idUsuario === "null") {
        mostrarMensaje("No se encontró el ID del usuario logueado.", "error");
        return null;
    }

    return Number(idUsuario);
}

// LIMPIAR SESION
function limpiarSesionIndex() {
    localStorage.removeItem("token");
    localStorage.removeItem("usuario");
    localStorage.removeItem("rol");
    localStorage.removeItem("id_usuario");
}

// MOSTRAR MENSAJES
function mostrarMensaje(texto, tipo = "info") {
    if (!mensajeSistema) {
        alert(texto);
        return;
    }

    mensajeSistema.textContent = texto;

    if (tipo === "error") {
        mensajeSistema.style.color = "#dc2626";
    } else if (tipo === "exito") {
        mensajeSistema.style.color = "#15803d";
    } else {
        mensajeSistema.style.color = "#2563eb";
    }
}

// FORMATEAR FECHA
function formatearFecha(fecha) {
    if (!fecha) {
        return "";
    }

    const fechaObj = new Date(fecha);

    if (isNaN(fechaObj.getTime())) {
        return fecha;
    }

    return fechaObj.toLocaleDateString("es-GT", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit"
    });
}

// FORMATEAR HORA
function formatearHora(fecha) {
    if (!fecha) {
        return "";
    }

    const fechaObj = new Date(fecha);

    if (isNaN(fechaObj.getTime())) {
        return "";
    }

    return fechaObj.toLocaleTimeString("es-GT", {
        hour: "2-digit",
        minute: "2-digit"
    });
}

// ANIMAR NUMEROS DE METRICAS
function animarNumero(id, nuevoValor) {
    const el = document.getElementById(id);

    if (!el) {
        return;
    }

    el.style.transition = "transform .2s, opacity .2s";
    el.style.transform = "scale(1.3)";
    el.style.opacity = "0.3";

    setTimeout(function () {
        el.textContent = nuevoValor;
        el.style.transform = "scale(1)";
        el.style.opacity = "1";
    }, 200);
}

// ACTUALIZAR METRICAS
function actualizarMetricas(visitas) {
    if (!Array.isArray(visitas)) {
        return;
    }

    const hoy = new Date().toISOString().slice(0, 10);

    const ingresosHoy = visitas.filter(function (visita) {
        const fecha =
            visita.fecha_entrada ||
            visita.hora_entrada ||
            visita.fecha_ingreso ||
            visita.creado_en ||
            visita.fecha_registro ||
            "";

        return String(fecha).slice(0, 10) === hoy;
    }).length;

    const salidasHoy = visitas.filter(function (visita) {
        const fecha =
            visita.fecha_salida ||
            visita.hora_salida ||
            "";

        return String(fecha).slice(0, 10) === hoy;
    }).length;

    const activas = visitas.filter(function (visita) {
        return !(
            visita.fecha_salida ||
            visita.hora_salida ||
            visita.estado_visita === "finalizada" ||
            visita.estado_visita === "Finalizada"
        );
    }).length;

    const sinFoto = visitas.filter(function (visita) {
        return !visita.foto &&
               !visita.foto_url &&
               !visita.foto_base64 &&
               !visita.imagen_base64;
    }).length;

    const conPlaca = visitas.filter(function (visita) {
        return visita.placa || visita.placa_vehiculo;
    }).length;

        const total = visitas.length;

    animarNumero("cnt-activas", activas);
    animarNumero("cnt-ingresos", ingresosHoy);
    animarNumero("cnt-salidas", salidasHoy);
    animarNumero("cnt-sinfoto", sinFoto);

     const pctOcup = total > 0 ? Math.round((activas / total) * 100) : 0;
    const pctVeh = total > 0 ? Math.round((conPlaca / total) * 100) : 0;

    const pctOcupacion = document.getElementById("pct-ocupacion");
    const pctVehiculos = document.getElementById("pct-vehiculos");
    const barOcupacion = document.getElementById("bar-ocupacion");
    const barVehiculos = document.getElementById("bar-vehiculos");

    if (pctOcupacion) {
        pctOcupacion.textContent = pctOcup + "%";
    }

    if (pctVehiculos) {
        pctVehiculos.textContent = pctVeh + "%";
    }

    if (barOcupacion) {
        barOcupacion.style.setProperty("--w", pctOcup + "%");
        barOcupacion.style.width = pctOcup + "%";
    }

    if (barVehiculos) {
        barVehiculos.style.setProperty("--w", pctVeh + "%");
        barVehiculos.style.width = pctVeh + "%";
    }
}

// CARGAR VISITANTES
async function cargarVisitantes() {
    try {
        const token = obtenerTokenIndex();

        if (!token || !selectVisitante) {
            return;
        }

        const respuesta = await fetch(`${API}/visitantes`, {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error cargando visitantes:", data);
            mostrarMensaje(data.detail || "Error al cargar visitantes.", "error");
            return;
        }

        selectVisitante.innerHTML =
            `<option value="">Seleccione un visitante</option>`;

        mapaVisitantes = {};

        data.forEach(function (visitante) {
            const idVisitante =
                visitante.id_visitante ||
                visitante.id_visitantes;

            if (!idVisitante) {
                return;
            }

            const nombreVisitante =
                `${visitante.nombres || ""} ${visitante.apellidos || ""}`.trim();

            mapaVisitantes[idVisitante] = nombreVisitante;

            const option = document.createElement("option");
            option.value = idVisitante;
            option.textContent = nombreVisitante || "Visitante sin nombre";

            selectVisitante.appendChild(option);
        });

    } catch (error) {
        console.error("Error cargando visitantes:", error);
        mostrarMensaje("Error al cargar visitantes.", "error");
    }
}

// CARGAR VECINOS
async function cargarVecinos() {
    try {
        const token = obtenerTokenIndex();

        if (!token || !selectVecino) {
            return;
        }

        const respuesta = await fetch(`${API}/vecinos`, {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error cargando vecinos:", data);
            mostrarMensaje(data.detail || "Error al cargar vecinos.", "error");
            return;
        }

        selectVecino.innerHTML =
            `<option value="">Seleccione un vecino</option>`;

        mapaVecinos = {};
        mapaViviendasVecino = {};

        data.forEach(function (vecino) {
            const idVecino = vecino.id_vecino;

            if (!idVecino) {
                return;
            }

            const nombreVecino =
                `${vecino.nombres || ""} ${vecino.apellidos || ""}`.trim();

            mapaVecinos[idVecino] = nombreVecino;
            mapaViviendasVecino[idVecino] = vecino.id_vivienda;

            const option = document.createElement("option");
            option.value = idVecino;
            option.textContent =
                `${nombreVecino || "Vecino sin nombre"} - Código: ${vecino.codigo_unico || "Sin código"}`;

            selectVecino.appendChild(option);
        });

    } catch (error) {
        console.error("Error cargando vecinos:", error);
        mostrarMensaje("Error al cargar vecinos.", "error");
    }
}

// CARGAR VISITAS
async function cargarVisitas() {
    try {
        const token = obtenerTokenIndex();

        if (!token) {
            return;
        }

        const respuesta = await fetch(`${API}/visitas`, {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error cargando visitas:", data);
            mostrarMensaje(data.detail || "Error al cargar visitas.", "error");
            return;
        }

        todasLasVisitas = data;
        mapaFotosVisitas = {};

        renderTabla(data);
        actualizarMetricas(data);

    } catch (error) {
        console.error("Error cargando visitas:", error);
        mostrarMensaje("Error al cargar visitas.", "error");
    }
}

// RENDERIZAR TABLA DE VISITAS
function renderTabla(data) {
    if (!tablaVisitas) {
        return;
    }

    tablaVisitas.innerHTML = "";

    if (!data || data.length === 0) {
        tablaVisitas.innerHTML = `
            <tr>
                <td colspan="10" style="text-align:center;">
                    No hay visitas registradas
                </td>
            </tr>
        `;
        return;
    }

    data.forEach(function (visita, indice) {
        const fila = document.createElement("tr");

        fila.style.animation = "rowIn .4s ease both";
        fila.style.animationDelay = (indice * 0.04) + "s";

        const idVisita =
            visita.id_visita ||
            visita.id_visitas;

        const nombreVisitante =
            visita.visitante_nombre ||
            visita.nombre_visitante ||
            visita.visitante ||
            mapaVisitantes[visita.id_visitante] ||
            "";

        const nombreVecino =
            visita.vecino_nombre ||
            visita.nombre_vecino ||
            visita.vecino ||
            mapaVecinos[visita.id_vecino] ||
            "";

        const iniciales =
            nombreVisitante
                .split(" ")
                .filter(Boolean)
                .map(function (n) {
                    return n[0];
                })
                .join("")
                .toUpperCase()
                .slice(0, 2) || "V";

        const placa =
            visita.placa ||
            visita.placa_vehiculo ||
            "Sin placa";

        const fechaEntrada =
            visita.fecha_entrada ||
            visita.hora_entrada ||
            visita.fecha_ingreso ||
            visita.creado_en ||
            visita.fecha_registro;

        const fechaSalida =
            visita.fecha_salida ||
            visita.hora_salida ||
            "";

        const fotoValor =
            visita.foto ||
            visita.foto_url ||
            visita.foto_base64 ||
            visita.imagen_base64 ||
            "";

        if (fotoValor && idVisita) {
            mapaFotosVisitas[idVisita] = fotoValor;
        }

        const foto = fotoValor
            ? `<button type="button" class="btn-ver-foto" onclick="verFotoVisita(${idVisita})">
                    Ver foto
               </button>`
            : `<span class="sin-foto">Sin foto</span>`;

        const observaciones =
            visita.observaciones ||
            visita.motivo_visita ||
            visita.tipo_ingreso ||
            "";

        const estaActiva = !(
            fechaSalida ||
            visita.estado_visita === "finalizada" ||
            visita.estado_visita === "Finalizada"
        );

        fila.innerHTML = `
            <td class="muted">${idVisita || ""}</td>

            <td>
                <span class="av">${iniciales}</span>
                ${nombreVisitante || "Sin nombre"}
            </td>

            <td class="muted">${nombreVecino || "—"}</td>

            <td class="${placa !== "Sin placa" ? "placa" : "muted"}">
                ${placa}
            </td>

            <td>${foto}</td>

            <td class="muted">${formatearFecha(fechaEntrada)}</td>

            <td class="muted">${formatearHora(fechaEntrada)}</td>

            <td class="muted">${observaciones}</td>

            <td>
                <span class="badge ${estaActiva ? "badge-on" : "badge-off"}">
                    <span class="bdot ${estaActiva ? "bdot-on" : "bdot-off"}"></span>
                    ${estaActiva ? "Activa" : "Finalizada"}
                </span>
            </td>

            <td>
                ${
                    estaActiva
                        ? `<button type="button" class="btn-salida" onclick="registrarSalida(${idVisita})">
                            Registrar salida
                           </button>`
                        : `<span class="muted">—</span>`
                }
            </td>
        `;

        tablaVisitas.appendChild(fila);
    });
}

// FILTRAR TABLA
function filtrarTabla() {
    if (!buscadorHistorial) {
        return;
    }

    const q = buscadorHistorial.value.toLowerCase().trim();

    const filtradas = todasLasVisitas.filter(function (visita) {
        const nombreVisitante =
            (
                visita.visitante_nombre ||
                visita.nombre_visitante ||
                visita.visitante ||
                mapaVisitantes[visita.id_visitante] ||
                ""
            ).toLowerCase();

        const nombreVecino =
            (
                visita.vecino_nombre ||
                visita.nombre_vecino ||
                visita.vecino ||
                mapaVecinos[visita.id_vecino] ||
                ""
            ).toLowerCase();

        const placa =
            (
                visita.placa ||
                visita.placa_vehiculo ||
                ""
            ).toLowerCase();

        const observaciones =
            (
                visita.observaciones ||
                visita.motivo_visita ||
                visita.tipo_ingreso ||
                ""
            ).toLowerCase();

        return nombreVisitante.includes(q) ||
               nombreVecino.includes(q) ||
               placa.includes(q) ||
               observaciones.includes(q);
    });

    renderTabla(filtradas);
}

// REGISTRAR VISITA NORMAL
async function registrarVisita() {
    const token = obtenerTokenIndex();

    if (!token) {
        return;
    }

    const idUsuario = obtenerIdUsuarioLogueado();

    if (!idUsuario) {
        return;
    }

    const idVisitante = Number(selectVisitante?.value);
    const idVecino = Number(selectVecino?.value);
    const placaVehiculo = inputPlaca ? inputPlaca.value.trim() : "";

    const observacionesVisita = inputObservaciones
        ? inputObservaciones.value.trim()
        : "";

    if (!idVisitante) {
        mostrarMensaje("Seleccione un visitante.", "error");
        return;
    }

    if (!idVecino) {
        mostrarMensaje("Seleccione un vecino.", "error");
        return;
    }

    const idVivienda = mapaViviendasVecino[idVecino];

    if (!idVivienda) {
        mostrarMensaje("No se encontró la vivienda del vecino seleccionado.", "error");
        return;
    }

    const datos = {
        id_visitante: idVisitante,
        id_vecino: idVecino,
        id_vivienda: idVivienda,
        id_usuario_agente: idUsuario,
        tipo_ingreso: "normal",
        observaciones: observacionesVisita || "Registrado desde web",
        foto: imagenBase64 || null,
        placa: placaVehiculo || null
    };

    try {
        const respuesta = await fetch(`${API}/visitas`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            },
            body: JSON.stringify(datos)
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error registrando ingreso:", resultado);
            mostrarMensaje(resultado.detail || "No se pudo registrar el ingreso.", "error");
            return;
        }

        mostrarMensaje(resultado.mensaje || "Ingreso registrado correctamente.", "exito");

        if (inputPlaca) {
            inputPlaca.value = "";
        }

        if (inputObservaciones) {
            inputObservaciones.value = "";
        }

        imagenBase64 = "";

        await cargarVisitas();

    } catch (error) {
        console.error("Error registrando ingreso:", error);
        mostrarMensaje("Error al conectar con el servidor.", "error");
    }
}

// REGISTRAR SALIDA
async function registrarSalida(idVisita) {
    const token = obtenerTokenIndex();

    if (!token) {
        return;
    }

    if (!idVisita) {
        mostrarMensaje("No se encontró la visita seleccionada.", "error");
        return;
    }

    const confirmar = confirm("¿Deseas registrar la salida de esta visita?");

    if (!confirmar) {
        return;
    }

    try {
        const respuesta = await fetch(`${API}/visitas/${idVisita}/salida`, {
            method: "PUT",
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error registrando salida:", resultado);
            mostrarMensaje(resultado.detail || "No se pudo registrar la salida.", "error");
            return;
        }

        mostrarMensaje(resultado.mensaje || "Salida registrada correctamente.", "exito");

        await cargarVisitas();

    } catch (error) {
        console.error("Error registrando salida:", error);
        mostrarMensaje("Error al registrar salida.", "error");
    }
}

// RECIBIR FOTO DESDE camara.js
function guardarFotoBase64(base64) {
    imagenBase64 = base64;
}

// VER FOTO DE VISITA
function verFotoVisita(idVisita) {
    let fotoGuardada = mapaFotosVisitas[idVisita];

    if (!fotoGuardada) {
        alert("No se encontró la foto de esta visita.");
        return;
    }

    fotoGuardada = String(fotoGuardada).trim();
    fotoGuardada = fotoGuardada.replace(/\\/g, "/");

    let modal = document.getElementById("modalFotoVisita");

    if (!modal) {
        modal = document.createElement("div");
        modal.id = "modalFotoVisita";
        modal.className = "modal-foto";

        modal.innerHTML = `
            <div class="modal-foto-contenido">
                <div class="modal-foto-header">
                    <h3>Foto de la visita</h3>

                    <button type="button" class="btn-cerrar-foto" onclick="cerrarFotoVisita()">
                        ×
                    </button>
                </div>

                <img id="imagenFotoVisita" src="" alt="Foto de la visita">
            </div>
        `;

        document.body.appendChild(modal);

        modal.addEventListener("click", function (evento) {
            if (evento.target === modal) {
                cerrarFotoVisita();
            }
        });
    }

    const imagen = document.getElementById("imagenFotoVisita");

    let srcFoto = "";

    if (fotoGuardada.startsWith("http://") || fotoGuardada.startsWith("https://")) {
        srcFoto = fotoGuardada;
    } else if (fotoGuardada.startsWith("/fotos/")) {
        srcFoto = API + fotoGuardada;
    } else if (fotoGuardada.startsWith("fotos/")) {
        srcFoto = API + "/" + fotoGuardada;
    } else if (
        fotoGuardada.endsWith(".png") ||
        fotoGuardada.endsWith(".jpg") ||
        fotoGuardada.endsWith(".jpeg") ||
        fotoGuardada.endsWith(".webp")
    ) {
        srcFoto = API + "/fotos/" + fotoGuardada;
    } else if (fotoGuardada.startsWith("data:image")) {
        srcFoto = fotoGuardada;
    } else {
        srcFoto = "data:image/png;base64," + fotoGuardada.replace(/\s/g, "");
    }

    imagen.src = srcFoto;

    modal.classList.add("activo");
}

function cerrarFotoVisita() {
    const modal = document.getElementById("modalFotoVisita");

    if (modal) {
        modal.classList.remove("activo");
    }
}

// INICIAR PANEL
document.addEventListener("DOMContentLoaded", async function () {
    mostrarUsuarioLogueado();
    mostrarFecha();

    await cargarVisitantes();
    await cargarVecinos();
    await cargarVisitas();

    if (buscadorHistorial) {
        buscadorHistorial.addEventListener("input", filtrarTabla);
    }
});