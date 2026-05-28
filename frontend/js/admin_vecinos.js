// Gestion de vecinos desde panel administrador
// URL del backend desde config.js
const API_VECINOS = API;

// Arreglos principales
let vecinos = [];
let viviendas = [];

// Elementos del HTML
const tablaVecinos = document.getElementById("tablaVecinos");
const buscarVecino = document.getElementById("buscarVecino");

const modalEditar = document.getElementById("modalEditar");
const modalNuevo = document.getElementById("modalNuevo");

const selectNuevoVivienda = document.getElementById("nuevoIdVivienda");
const selectEditVivienda = document.getElementById("editIdVivienda");

// FUNCION PARA OBTENER TOKEN
function obtenerTokenAdminVecinos() {
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
// CARGAR DATOS AL INICIAR
document.addEventListener("DOMContentLoaded", async function () {
    await cargarViviendas();
    await cargarVecinos();
});

// CARGAR VIVIENDAS
async function cargarViviendas() {
    try {
        const token = obtenerTokenAdminVecinos();

        if (!token) {
            return;
        }

        const respuesta = await fetch(`${API_VECINOS}/viviendas`, {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error cargando viviendas:", data);

            if (respuesta.status === 401) {
                localStorage.removeItem("usuario");
                localStorage.removeItem("token");
                localStorage.removeItem("rol");
                window.location.replace("login.html");
                return;
            }

            alert(data.detail || "Error al cargar viviendas");
            return;
        }

        viviendas = data;

        llenarSelectViviendas();

    } catch (error) {
        console.error("Error cargando viviendas:", error);
        alert("Error al cargar viviendas");
    }
}

// LLENAR SELECT DE VIVIENDAS
function llenarSelectViviendas() {
    selectNuevoVivienda.innerHTML = `
        <option value="" disabled selected>Seleccione una vivienda</option>
    `;

    selectEditVivienda.innerHTML = `
        <option value="" disabled selected>Seleccione una vivienda</option>
    `;

    viviendas.forEach(function (vivienda) {
        if (vivienda.estado === true) {
            const texto = `${vivienda.numero_vivienda} - ${vivienda.sector || "Sin sector"}`;

            const optionNuevo = document.createElement("option");
            optionNuevo.value = vivienda.id_vivienda;
            optionNuevo.textContent = texto;

            const optionEditar = document.createElement("option");
            optionEditar.value = vivienda.id_vivienda;
            optionEditar.textContent = texto;

            selectNuevoVivienda.appendChild(optionNuevo);
            selectEditVivienda.appendChild(optionEditar);
        }
    });
}

// OBTENER TEXTO DE VIVIENDA
function obtenerTextoVivienda(idVivienda) {
    const vivienda = viviendas.find(function (item) {
        return Number(item.id_vivienda) === Number(idVivienda);
    });

    if (!vivienda) {
        return `ID ${idVivienda}`;
    }

    return `${vivienda.numero_vivienda} - ${vivienda.sector || "Sin sector"}`;
}
// CARGAR VECINOS
async function cargarVecinos() {
    try {
        const token = obtenerTokenAdminVecinos();

        if (!token) {
            return;
        }

        const respuesta = await fetch(`${API_VECINOS}/vecinos`, {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error cargando vecinos:", data);

            if (respuesta.status === 401) {
                localStorage.removeItem("usuario");
                localStorage.removeItem("token");
                localStorage.removeItem("rol");
                window.location.replace("login.html");
                return;
            }

            alert(data.detail || "No se pudieron cargar los vecinos");
            return;
        }

        vecinos = data;

        renderizarVecinos(vecinos);

    } catch (error) {
        console.error("Error cargando vecinos:", error);
        alert("Error al cargar vecinos");
    }
}

// MOSTRAR VECINOS EN TABLA
function renderizarVecinos(lista) {
    tablaVecinos.innerHTML = "";

    if (lista.length === 0) {
        tablaVecinos.innerHTML = `
            <tr>
                <td colspan="8" style="text-align:center;">
                    No hay vecinos registrados
                </td>
            </tr>
        `;
        return;
    }

    lista.forEach(function (vecino) {
        const fila = document.createElement("tr");

        const estadoTexto = vecino.estado ? "Activo" : "Inactivo";

        fila.innerHTML = `
            <td>${vecino.id_vecino}</td>

            <td>${vecino.nombres || ""} ${vecino.apellidos || ""}</td>

            <td>${obtenerTextoVivienda(vecino.id_vivienda)}</td>

            <td>${vecino.codigo_unico || ""}</td>

            <td>${vecino.telefono || ""}</td>

            <td>${vecino.correo || ""}</td>

            <td>${estadoTexto}</td>

            <td>
                <button type="button" onclick='abrirModalEditar(${JSON.stringify(vecino)})'>
                    Editar
                </button>

                <button type="button" onclick="cambiarEstadoVecino(${vecino.id_vecino}, ${!vecino.estado})">
                    ${vecino.estado ? "Desactivar" : "Activar"}
                </button>
            </td>
        `;

        tablaVecinos.appendChild(fila);
    });
}

// BUSCAR VECINOS
buscarVecino.addEventListener("input", function () {
    const texto = buscarVecino.value.toLowerCase().trim();

    const filtrados = vecinos.filter(function (vecino) {
        const nombre = `${vecino.nombres || ""} ${vecino.apellidos || ""}`.toLowerCase();
        const correo = String(vecino.correo || "").toLowerCase();
        const telefono = String(vecino.telefono || "").toLowerCase();
        const codigo = String(vecino.codigo_unico || "").toLowerCase();
        const vivienda = obtenerTextoVivienda(vecino.id_vivienda).toLowerCase();

        return (
            nombre.includes(texto) ||
            correo.includes(texto) ||
            telefono.includes(texto) ||
            codigo.includes(texto) ||
            vivienda.includes(texto)
        );
    });

    renderizarVecinos(filtrados);
});

// MODAL NUEVO
function abrirModalNuevo() {
    limpiarFormularioNuevo();
    modalNuevo.style.display = "flex";
}

function cerrarModalNuevo() {
    modalNuevo.style.display = "none";
}

// MODAL EDITAR
function abrirModalEditar(vecino) {
    modalEditar.style.display = "flex";

    document.getElementById("editIdVecino").value = vecino.id_vecino;
    document.getElementById("editIdVivienda").value = vecino.id_vivienda;
    document.getElementById("editNombres").value = vecino.nombres || "";
    document.getElementById("editApellidos").value = vecino.apellidos || "";
    document.getElementById("editDpi").value = vecino.dpi || "";
    document.getElementById("editTelefono").value = vecino.telefono || "";
    document.getElementById("editCorreo").value = vecino.correo || "";
    document.getElementById("editEstado").value = String(vecino.estado);
}

function cerrarModalEditar() {
    modalEditar.style.display = "none";
}

// CREAR VECINO
document.getElementById("formNuevoVecino").addEventListener("submit", async function (evento) {
    evento.preventDefault();

    const datos = {
        id_vivienda: Number(document.getElementById("nuevoIdVivienda").value),
        nombres: document.getElementById("nuevoNombres").value.trim(),
        apellidos: document.getElementById("nuevoApellidos").value.trim(),
        dpi: document.getElementById("nuevoDpi").value.trim() || null,
        telefono: document.getElementById("nuevoTelefono").value.trim() || null,
        correo: document.getElementById("nuevoCorreo").value.trim()
    };

    if (!datos.id_vivienda) {
        alert("Seleccione una vivienda");
        return;
    }

    try {
        const token = obtenerTokenAdminVecinos();

        if (!token) {
            return;
        }

        const respuesta = await fetch(`${API_VECINOS}/vecinos`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            },
            body: JSON.stringify(datos)
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            alert(resultado.detail || "No se pudo crear el vecino");
            return;
        }

        alert(resultado.mensaje || "Vecino creado correctamente");

        cerrarModalNuevo();
        await cargarVecinos();

    } catch (error) {
        console.error("Error creando vecino:", error);
        alert("Error al crear vecino");
    }
});

// EDITAR VECINO
document.getElementById("formEditarVecino").addEventListener("submit", async function (evento) {
    evento.preventDefault();

    const idVecino = document.getElementById("editIdVecino").value;

    const datos = {
        id_vivienda: Number(document.getElementById("editIdVivienda").value),
        nombres: document.getElementById("editNombres").value.trim(),
        apellidos: document.getElementById("editApellidos").value.trim(),
        dpi: document.getElementById("editDpi").value.trim() || null,
        telefono: document.getElementById("editTelefono").value.trim() || null,
        correo: document.getElementById("editCorreo").value.trim(),
        estado: document.getElementById("editEstado").value === "true"
    };

    if (!datos.id_vivienda) {
        alert("Seleccione una vivienda");
        return;
    }

    try {
        const token = obtenerTokenAdminVecinos();

        if (!token) {
            return;
        }

        const respuesta = await fetch(`${API_VECINOS}/vecinos/${idVecino}`, {
            method: "PUT",
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            },
            body: JSON.stringify(datos)
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            alert(resultado.detail || "No se pudo actualizar el vecino");
            return;
        }

        alert(resultado.mensaje || "Vecino actualizado correctamente");

        cerrarModalEditar();
        await cargarVecinos();

    } catch (error) {
        console.error("Error actualizando vecino:", error);
        alert("Error al actualizar vecino");
    }
});

// ACTIVAR O DESACTIVAR VECINO
async function cambiarEstadoVecino(idVecino, nuevoEstado) {
    const accion = nuevoEstado ? "activar" : "desactivar";

    const confirmar = confirm(`¿Seguro que deseas ${accion} este vecino?`);

    if (!confirmar) {
        return;
    }

    try {
        const token = obtenerTokenAdminVecinos();

        if (!token) {
            return;
        }

        const respuesta = await fetch(
            `${API_VECINOS}/vecinos/${idVecino}/estado?estado=${nuevoEstado}`,
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

        await cargarVecinos();

    } catch (error) {
        console.error("Error cambiando estado:", error);
        alert("Error al cambiar estado");
    }
}
// LIMPIAR FORMULARIO NUEVO
function limpiarFormularioNuevo() {
    document.getElementById("nuevoIdVivienda").value = "";
    document.getElementById("nuevoNombres").value = "";
    document.getElementById("nuevoApellidos").value = "";
    document.getElementById("nuevoDpi").value = "";
    document.getElementById("nuevoTelefono").value = "";
    document.getElementById("nuevoCorreo").value = "";
}