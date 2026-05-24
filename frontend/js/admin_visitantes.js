// tabla
const tablaVisitantes =
    document.getElementById("tablaVisitantes");


// cargar visitantes
async function cargarVisitantes() {

    try {

        const token = localStorage.getItem("token");

        if (!token) {
            localStorage.removeItem("usuario");
            localStorage.removeItem("token");
            window.location.replace("login.html");
            return;
        }

        // obtener datos
        const respuesta =
            await fetch(`${API}/visitantes`, {
                headers: {
                    "Authorization": "Bearer " + token
                }
            });

        const visitantes =
            await respuesta.json();

        if (!respuesta.ok) {
            console.error("Error cargando visitantes:", visitantes);

            if (respuesta.status === 401) {
                localStorage.removeItem("usuario");
                localStorage.removeItem("token");
                window.location.replace("login.html");
                return;
            }

            alert(visitantes.detail || "Error al cargar visitantes");
            return;
        }

        // limpiar tabla
        tablaVisitantes.innerHTML = "";

        // recorrer visitantes
        visitantes.forEach(visitante => {

            // crear fila
            const fila =
                document.createElement("tr");

            // contenido
            fila.innerHTML = `
                <td>${visitante.id_visitantes || visitante.id_visitante}</td>

                <td>${visitante.nombres}</td>

                <td>${visitante.apellidos}</td>

                <td>
                    <button
                        onclick='abrirModalEditar(${JSON.stringify(visitante)})'
                    >
                        Editar
                    </button>
                </td>
            `;

            // agregar fila
            tablaVisitantes.appendChild(fila);

        });

    }
    catch (error) {

        console.error(
            "Error cargando visitantes:",
            error
        );

    }

}


// iniciar
cargarVisitantes();


// modal editar
const modalEditar =
    document.getElementById("modalEditar");


// modal nuevo
const modalNuevo =
    document.getElementById("modalNuevo");


// abrir modal editar
function abrirModalEditar(visitante) {

    modalEditar.style.display = "flex";

    document.getElementById("editIdVisitante").value =
        visitante.id_visitantes || visitante.id_visitante;

    document.getElementById("editNombres").value =
        visitante.nombres;

    document.getElementById("editApellidos").value =
        visitante.apellidos;

}


// cerrar modal editar
function cerrarModalEditar() {

    modalEditar.style.display = "none";

}


// abrir modal nuevo
function abrirModalNuevo() {

    modalNuevo.style.display = "flex";

}


// cerrar modal nuevo
function cerrarModalNuevo() {

    modalNuevo.style.display = "none";

}


// guardar edicion
document
    .getElementById("formEditarVisitante")
    .addEventListener("submit", async function (evento) {

        evento.preventDefault();

        const token = localStorage.getItem("token");

        if (!token) {
            localStorage.removeItem("usuario");
            localStorage.removeItem("token");
            window.location.replace("login.html");
            return;
        }

        const idVisitante =
            document.getElementById("editIdVisitante").value;

        const datos = {
            nombres: document.getElementById("editNombres").value,
            apellidos: document.getElementById("editApellidos").value
        };

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
            alert(resultado.detail || "Error al actualizar visitante");
            return;
        }

        cerrarModalEditar();

        cargarVisitantes();

    });


// guardar nuevo
document
    .getElementById("formNuevoVisitante")
    .addEventListener("submit", async function (evento) {

        evento.preventDefault();

        const token = localStorage.getItem("token");

        if (!token) {
            localStorage.removeItem("usuario");
            localStorage.removeItem("token");
            window.location.replace("login.html");
            return;
        }

        const datos = {
            nombres: document.getElementById("nuevoNombres").value,
            apellidos: document.getElementById("nuevoApellidos").value
        };

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
            alert(resultado.detail || "Error al crear visitante");
            return;
        }

        cerrarModalNuevo();

        this.reset();

        cargarVisitantes();

    });


// buscar visitante
document
    .getElementById("buscarVisitante")
    .addEventListener("input", function () {

        const texto =
            this.value.toLowerCase();

        const filas =
            tablaVisitantes.querySelectorAll("tr");

        filas.forEach(fila => {

            const contenido =
                fila.textContent.toLowerCase();

            fila.style.display =
                contenido.includes(texto)
                    ? ""
                    : "none";

        });

    });