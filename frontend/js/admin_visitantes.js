// Gestión de visitantes desde panel administrador
// Crear, listar, editar y buscar visitantes
// Incluye DPI o licencia

// VARIABLES GLOBALES
let visitantes = [];

// ELEMENTOS
const tablaVisitantes = document.getElementById("tablaVisitantes");
const modalEditar = document.getElementById("modalEditar");
const modalNuevo = document.getElementById("modalNuevo");
const inputBuscarVisitante = document.getElementById("buscarVisitante");

// OBTENER TOKEN
    function obtenerTokenAdminVisitantes() {
        const token = localStorage.getItem("token");

        if (!token) {
            localStorage.removeItem("usuario");
            localStorage.removeItem("token");
            localStorage.removeItem("rol");
            localStorage.removeItem("id_usuario");

            window.location.replace("login.html");

            return null;
        }

        return token;
    }

    // CARGAR VISITANTES
    async function cargarVisitantes() {
        try {
            const token = obtenerTokenAdminVisitantes();

            if (!token) {
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

                if (respuesta.status === 401) {
                    localStorage.removeItem("usuario");
                    localStorage.removeItem("token");
                    localStorage.removeItem("rol");
                    localStorage.removeItem("id_usuario");

                    window.location.replace("login.html");
                    return;
                }

                alert(data.detail || "Error al cargar visitantes.");
                return;
            }

            visitantes = data;

            renderizarVisitantes(visitantes);

        } catch (error) {
            console.error("Error cargando visitantes:", error);
            alert("Error al cargar visitantes.");
        }
    }

// RENDERIZAR VISITANTES
function renderizarVisitantes(lista) {
    tablaVisitantes.innerHTML = "";

    if (!lista || lista.length === 0) {
        tablaVisitantes.innerHTML = `
            <tr>
                <td colspan="5" style="text-align:center;">
                    No hay visitantes registrados
                </td>
            </tr>
        `;
        return;
    }

    lista.forEach(function (visitante) {
        const fila = document.createElement("tr");

        const idVisitante =
            visitante.id_visitantes ||
            visitante.id_visitante;

        const dpiLicencia =
            visitante.dpi_licencia ||
            "Sin registro";

        fila.innerHTML = `
            <td>${idVisitante}</td>

            <td>${visitante.nombres || ""}</td>

            <td>${visitante.apellidos || ""}</td>

            <td class="dpi-licencia">${dpiLicencia}</td>

            <td>
                <button
                    type="button"
                    class="btn-editar"
                    onclick="abrirModalEditarPorId(${idVisitante})"
                >
                    Editar
                </button>
            </td>
        `;

        tablaVisitantes.appendChild(fila);
    });
}

// BUSCAR VISITANTE
if (inputBuscarVisitante) {
    inputBuscarVisitante.addEventListener("input", function () {
        const texto = inputBuscarVisitante.value.toLowerCase().trim();

        const filtrados = visitantes.filter(function (visitante) {
            const idVisitante = String(
                visitante.id_visitantes ||
                visitante.id_visitante ||
                ""
            ).toLowerCase();

            const nombres = String(visitante.nombres || "").toLowerCase();
            const apellidos = String(visitante.apellidos || "").toLowerCase();
            const dpiLicencia = String(visitante.dpi_licencia || "").toLowerCase();

            return (
                idVisitante.includes(texto) ||
                nombres.includes(texto) ||
                apellidos.includes(texto) ||
                dpiLicencia.includes(texto)
            );
        });

        renderizarVisitantes(filtrados);
    });
}

// ABRIR MODAL NUEVO
function abrirModalNuevo() {
    limpiarFormularioNuevo();

    modalNuevo.style.display = "flex";
}

// CERRAR MODAL NUEVO
function cerrarModalNuevo() {
    modalNuevo.style.display = "none";
}

// LIMPIAR FORMULARIO NUEVO
function limpiarFormularioNuevo() {
    const formNuevo = document.getElementById("formNuevoVisitante");

    if (formNuevo) {
        formNuevo.reset();
    }
}

// ABRIR MODAL EDITAR POR ID
function abrirModalEditarPorId(idVisitante) {
    const visitante = visitantes.find(function (item) {
        const id =
            item.id_visitantes ||
            item.id_visitante;

        return Number(id) === Number(idVisitante);
    });

    if (!visitante) {
        alert("No se encontró el visitante seleccionado.");
        return;
    }

    abrirModalEditar(visitante);
}

// ABRIR MODAL EDITAR
    function abrirModalEditar(visitante) {
        modalEditar.style.display = "flex";

        document.getElementById("editIdVisitante").value =
            visitante.id_visitantes ||
            visitante.id_visitante;

        document.getElementById("editNombres").value =
            visitante.nombres || "";

        document.getElementById("editApellidos").value =
            visitante.apellidos || "";

        document.getElementById("editDpiLicencia").value =
            visitante.dpi_licencia || "";
    }

    // CERRAR MODAL EDITAR
    function cerrarModalEditar() {
        modalEditar.style.display = "none";
    }

    // GUARDAR NUEVO VISITANTE
    document
        .getElementById("formNuevoVisitante")
        .addEventListener("submit", async function (evento) {
            evento.preventDefault();

            try {
                const token = obtenerTokenAdminVisitantes();

                if (!token) {
                    return;
                }

            const datos = {
                nombres: document.getElementById("nuevoNombres").value.trim(),
                apellidos: document.getElementById("nuevoApellidos").value.trim(),
                dpi_licencia: document.getElementById("nuevoDpiLicencia").value.trim() || null
            };

            if (!datos.nombres || !datos.apellidos) {
                alert("Debe ingresar nombres y apellidos.");
                return;
            }

            const respuesta = await fetch(`${API}/visitantes`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": "Bearer " + token
                },
                body: JSON.stringify(datos)
            });

            const resultado = await respuesta.json();

            if (!respuesta.ok) {
                console.error("Error creando visitante:", resultado);
                alert(resultado.detail || "Error al crear visitante.");
                return;
            }

            cerrarModalNuevo();
            limpiarFormularioNuevo();

            await cargarVisitantes();

        } catch (error) {
            console.error("Error creando visitante:", error);
            alert("Error al crear visitante.");
        }
    });

// GUARDAR EDICION DE VISITANTE
document
        .getElementById("formEditarVisitante")
         .addEventListener("submit", async function (evento) {
        evento.preventDefault();

         try {
            const token = obtenerTokenAdminVisitantes();

            if (!token) {
                return;
            }

            const idVisitante =
                document.getElementById("editIdVisitante").value;

            const datos = {
                nombres: document.getElementById("editNombres").value.trim(),
                apellidos: document.getElementById("editApellidos").value.trim(),
                dpi_licencia: document.getElementById("editDpiLicencia").value.trim() || null
            };

            if (!datos.nombres || !datos.apellidos) {
                alert("Debe ingresar nombres y apellidos.");
                return;
            }

            const respuesta = await fetch(`${API}/visitantes/${idVisitante}`, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": "Bearer " + token
                },
                body: JSON.stringify(datos)
            });

            const resultado = await respuesta.json();

            if (!respuesta.ok) {
                console.error("Error actualizando visitante:", resultado);
                alert(resultado.detail || "Error al actualizar visitante.");
                return;
            }

            cerrarModalEditar();

            await cargarVisitantes();

        } catch (error) {
            console.error("Error actualizando visitante:", error);
            alert("Error al actualizar visitante.");
         }
    });

    // CERRAR MODALES AL HACER CLIC FUERA
    window.addEventListener("click", function (evento) {
        if (evento.target === modalNuevo) {
            cerrarModalNuevo();
        }

        if (evento.target === modalEditar) {
            cerrarModalEditar();
        }
    });

// INICIAR
document.addEventListener("DOMContentLoaded", function () {
    cargarVisitantes();
});