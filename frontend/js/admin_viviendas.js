// URL del backend desde config.js
const API_VIVIENDAS = API;

// VARIABLES GLOBALES
let viviendas = [];

// ELEMENTOS DEL HTML
const tablaViviendas = document.getElementById("tablaViviendas");
const txtBuscar = document.getElementById("txtBuscar");

const modalVivienda = document.getElementById("modalVivienda");
const tituloModal = document.getElementById("tituloModal");

const formVivienda = document.getElementById("formVivienda");

const inputIdVivienda = document.getElementById("id_vivienda");
const inputNumeroVivienda = document.getElementById("numero_vivienda");
const inputSector = document.getElementById("sector");
const inputDireccionReferencia = document.getElementById("direccion_referencia");
const selectEstado = document.getElementById("estado");
const grupoEstado = document.getElementById("grupoEstado");

const btnNuevaVivienda = document.getElementById("btnNuevaVivienda");
const btnCerrarModal = document.getElementById("btnCerrarModal");
const btnCancelar = document.getElementById("btnCancelar");

// FUNCION PARA OBTENER TOKEN
function obtenerTokenAdminViviendas() {
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

// CARGAR VIVIENDAS AL INICIAR
document.addEventListener("DOMContentLoaded", function () {
    cargarViviendas();
});

    // LISTAR VIVIENDAS
async function cargarViviendas() {
   try {
        const token = obtenerTokenAdminViviendas();
     if (!token) {
     return;
    }

        const respuesta = await fetch(`${API_VIVIENDAS}/viviendas`, {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error al cargar viviendas:", data);

            if (respuesta.status === 401) {
                localStorage.removeItem("usuario");
                localStorage.removeItem("token");
                localStorage.removeItem("rol");
                window.location.replace("login.html");
                return;
            }

            alert(data.detail || "No se pudieron cargar las viviendas");
            return;
        }

        viviendas = data;

        renderizarViviendas(viviendas);

  } catch (error) {
        console.error("Error al cargar viviendas:", error);
        alert("Error al cargar viviendas. Revisa que el backend esté encendido.");
  }
}

    // RENDERIZAR TABLA
function renderizarViviendas(lista) {
        tablaViviendas.innerHTML = "";

    if (lista.length === 0) {
    tablaViviendas.innerHTML = `
            <tr>
                <td colspan="7" class="sin-datos">
                    No hay viviendas registradas
                </td>
            </tr>
        `;

        return;
    }

 lista.forEach(function (vivienda) {
        const fila = document.createElement("tr");

        const estadoTexto = vivienda.estado ? "Activa" : "Inactiva";
        const estadoClase = vivienda.estado ? "estado-activo" : "estado-inactivo";

        fila.innerHTML = `
            <td>${vivienda.id_vivienda}</td>

            <td>${vivienda.numero_vivienda || ""}</td>

            <td>${vivienda.sector || ""}</td>

            <td>${vivienda.direccion_referencia || ""}</td>

            <td>
                <span class="badge ${estadoClase}">
                    ${estadoTexto}
                </span>
            </td>

            <td>${formatearFecha(vivienda.fecha_registro)}</td>

            <td class="acciones">
                <button class="btn-tabla btn-editar"
                        onclick="abrirModalEditar(${vivienda.id_vivienda})">
                    Editar
                </button>

                <button class="btn-tabla ${vivienda.estado ? "btn-desactivar" : "btn-activar"}"
                        onclick="cambiarEstadoVivienda(${vivienda.id_vivienda}, ${!vivienda.estado})">
                    ${vivienda.estado ? "Desactivar" : "Activar"}
                </button>
            </td>
        `;

        tablaViviendas.appendChild(fila);
 });
}

    // BUSCADOR
txtBuscar.addEventListener("input", function () {
 const texto = txtBuscar.value.toLowerCase().trim();

    const filtradas = viviendas.filter(function (vivienda) {
       const numero = String(vivienda.numero_vivienda || "").toLowerCase();
        const sector = String(vivienda.sector || "").toLowerCase();
        const referencia = String(vivienda.direccion_referencia || "").toLowerCase();

        return (
            numero.includes(texto) ||
            sector.includes(texto) ||
            referencia.includes(texto)
       );
    });

renderizarViviendas(filtradas);
});

    // ABRIR MODAL PARA CREAR
btnNuevaVivienda.addEventListener("click", function () {
limpiarFormulario();

    tituloModal.textContent = "Nueva vivienda";

    // Al crear, ocultamos estado porque se crea activa por defecto.
    grupoEstado.style.display = "none";

 modalVivienda.classList.remove("oculto");
});

    // ABRIR MODAL PARA EDITAR
function abrirModalEditar(idVivienda) {
const vivienda = viviendas.find(function (item) {
        return item.id_vivienda === idVivienda;
    });

    if (!vivienda) {
        alert("No se encontró la vivienda seleccionada");
        return;
    }

    tituloModal.textContent = "Editar vivienda";

    inputIdVivienda.value = vivienda.id_vivienda;
    inputNumeroVivienda.value = vivienda.numero_vivienda || "";
    inputSector.value = vivienda.sector || "";
    inputDireccionReferencia.value = vivienda.direccion_referencia || "";
    selectEstado.value = String(vivienda.estado);

    // Al editar, sí mostramos el estado.
    grupoEstado.style.display = "block";

 modalVivienda.classList.remove("oculto");
}

    // GUARDAR VIVIENDA
formVivienda.addEventListener("submit", async function (evento) {
 evento.preventDefault();

    const idVivienda = inputIdVivienda.value;

    const datos = {
        numero_vivienda: inputNumeroVivienda.value.trim(),
        sector: inputSector.value.trim() || null,
        direccion_referencia: inputDireccionReferencia.value.trim() || null
    };

    if (!datos.numero_vivienda) {
        alert("El número de vivienda es obligatorio");
        return;
    }

    // Si hay ID, se actualiza.
    // Si no hay ID, se crea.
if (idVivienda) {
        datos.estado = selectEstado.value === "true";

await actualizarVivienda(idVivienda, datos);
} else {
    await crearVivienda(datos);
 }
});

//CREAR VIVIENDA
async function crearVivienda(datos) {
try {
        const token = obtenerTokenAdminViviendas();

     if (!token) {
            return;
        }

        const respuesta = await fetch(`${API_VIVIENDAS}/viviendas`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            },
            body: JSON.stringify(datos)
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            alert(resultado.detail || "No se pudo crear la vivienda");
            return;
        }

        alert(resultado.mensaje || "Vivienda creada correctamente");

        cerrarModal();
        cargarViviendas();

} catch (error) {
        console.error("Error al crear vivienda:", error);
     alert("Error al crear vivienda");
}
}

    // ACTUALIZAR VIVIENDA
async function actualizarVivienda(idVivienda, datos) {
try {
        const token = obtenerTokenAdminViviendas();

    if (!token) {
            return;
        }

        const respuesta = await fetch(`${API_VIVIENDAS}/viviendas/${idVivienda}`, {
            method: "PUT",
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            },
            body: JSON.stringify(datos)
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            alert(resultado.detail || "No se pudo actualizar la vivienda");
            return;
        }

        alert(resultado.mensaje || "Vivienda actualizada correctamente");

        cerrarModal();
        cargarViviendas();

} catch (error) {
        console.error("Error al actualizar vivienda:", error);
        alert("Error al actualizar vivienda");
 }
}

    // ACTIVAR / DESACTIVAR VIVIENDA
async function cambiarEstadoVivienda(idVivienda, nuevoEstado) {
const accion = nuevoEstado ? "activar" : "desactivar";

    const confirmar = confirm(`¿Seguro que deseas ${accion} esta vivienda?`);

    if (!confirmar) {
        return;
    }

    try {
        const token = obtenerTokenAdminViviendas();

    if (!token) {
            return;
        }

        const respuesta = await fetch(
            `${API_VIVIENDAS}/viviendas/${idVivienda}/estado?estado=${nuevoEstado}`,
            {
                method: "PUT",
                headers: {
                    "Authorization": "Bearer " + token
                }
            }
        );

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            alert(resultado.detail || "No se pudo cambiar el estado");
            return;
        }

        alert(resultado.mensaje || "Estado actualizado correctamente");

        cargarViviendas();

 } catch (error) {
        console.error("Error al cambiar estado:", error);
      alert("Error al cambiar estado de vivienda");
 }
}

    // CERRAR MODAL
btnCerrarModal.addEventListener("click", cerrarModal);
btnCancelar.addEventListener("click", cerrarModal);

function cerrarModal() {
    modalVivienda.classList.add("oculto");
    limpiarFormulario();
}

    // LIMPIAR FORMULARIO

function limpiarFormulario() {
inputIdVivienda.value = "";
    inputNumeroVivienda.value = "";
    inputSector.value = "";
    inputDireccionReferencia.value = "";
 selectEstado.value = "true";
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

    return fechaObj.toLocaleString("es-GT", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit"
});
}

    // CERRAR MODAL AL DAR CLIC FUERA
modalVivienda.addEventListener("click", function (evento) {
if (evento.target === modalVivienda) {
        cerrarModal();
}
});