// OBTENER TOKEN DE SESION
function obtenerToken() {

    const token = localStorage.getItem("token");

    if (!token) {
        localStorage.removeItem("usuario");
        localStorage.removeItem("token");
        window.location.replace("login.html");
        return null;
    }

    return token;
}

// CARGAR VISITAS
async function cargarVisitas() {

    try {

        const token = obtenerToken();

        if (!token) {
            return;
        }

        let res = await fetch(API + "/visitas", {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        let data = await res.json();

        if (!res.ok) {
            console.error("Error al cargar visitas:", data);

            if (res.status === 401 || res.status === 403) {
                localStorage.removeItem("usuario");
                localStorage.removeItem("token");
                window.location.replace("login.html");
            }

            return;
        }

        todasLasVisitas = data;

        actualizarMetricas(data);

        renderTabla(data);

    } catch (error) {

        console.error("Error al cargar visitas:", error);

    }

}
// REGISTRAR VISITA MANUAL
async function registrarVisita() {

    const token = obtenerToken();

    if (!token) {
        return;
    }

    let visitante = document.getElementById("visitante").value;
    let vecino = document.getElementById("vecino").value;
    let vivienda = mapaViviendasVecino[vecino];
    let placa = document.getElementById("placa").value;

    // Validaciones antes de enviar
    if (!visitante) {
        document.getElementById("mensaje").textContent =
            "Seleccione un visitante.";
        return;
    }

    if (!vecino) {
        document.getElementById("mensaje").textContent =
            "Seleccione un vecino.";
        return;
    }

    if (!vivienda) {
        document.getElementById("mensaje").textContent =
            "El vecino seleccionado no tiene vivienda relacionada.";
        return;
    }

    const idUsuarioAgente =
        usuarioSesion.id_usuarios ||
        usuarioSesion.id_usuario ||
        usuarioSesion.id;

    if (!idUsuarioAgente) {
        document.getElementById("mensaje").textContent =
            "No se encontró el ID del usuario logueado.";
        return;
    }

    const datos = {
        id_visitante: parseInt(visitante),
        id_vecino: parseInt(vecino),
        id_vivienda: parseInt(vivienda),
        id_usuario_agente: parseInt(idUsuarioAgente),
        tipo_ingreso: "normal",
        observaciones: "Registrado desde web",
        foto: imagenBase64 || null,
        placa: placa || null
    };

    console.log("Datos enviados a /visitas:", datos);

    try {

        let res = await fetch(API + "/visitas", {

            method: "POST",

            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            },

            body: JSON.stringify(datos)
        });

        let data = await res.json();

        if (!res.ok) {
            console.error("Error del backend:", data);

            document.getElementById("mensaje").textContent =
                data.detail || "Error al registrar la visita.";

            return;
        }

        document.getElementById("mensaje").textContent =
            data.mensaje || "Visita registrada correctamente.";

        const toast = document.getElementById("toast");

        if (toast) {

            toast.textContent =
                data.mensaje || "Visita registrada correctamente.";

            toast.classList.add("show");

            setTimeout(() => {
                toast.classList.remove("show");
            }, 2500);
        }

        document.getElementById("placa").value = "";

        imagenBase64 = "";

        cargarVisitas();

    } catch (error) {

        console.error("Error al registrar visita:", error);

        document.getElementById("mensaje").textContent =
            "Error al registrar la visita.";

    }

}
// CARGAR VECINOS
// Llena el combo de vecinos
// y guarda la vivienda relacionada
async function cargarVecinos() {

    const token = obtenerToken();

    if (!token) {
        return;
    }

    try {

        let res = await fetch(API + "/vecinos", {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        let data = await res.json();

        if (!res.ok) {
            console.error("Error al cargar vecinos:", data);

            if (res.status === 401 || res.status === 403) {
                localStorage.removeItem("usuario");
                localStorage.removeItem("token");
                window.location.replace("login.html");
            }

            return;
        }

        let select = document.getElementById("vecino");

        select.innerHTML =
            '<option value="">Seleccione un vecino</option>';

        data.forEach(v => {

            mapaVecinos[v.id_vecino] =
                v.nombres + " " + v.apellidos + " - " + v.codigo_unico;

            mapaViviendasVecino[v.id_vecino] =
                v.id_vivienda;

            let option = document.createElement("option");

            option.value =
                v.id_vecino;

            option.textContent =
                v.nombres + " " + v.apellidos + " - Código: " + v.codigo_unico;

            select.appendChild(option);

        });

    } catch (error) {

        console.error("Error al cargar vecinos:", error);

    }

}

// CARGAR VISITANTES
// Llena el combo de visitantes
async function cargarVisitantes() {

    const token = obtenerToken();

    if (!token) {
        return;
    }

    try {

        let res = await fetch(API + "/visitantes", {
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        let data = await res.json();

        if (!res.ok) {
            console.error("Error al cargar visitantes:", data);

            if (res.status === 401 || res.status === 403) {
                localStorage.removeItem("usuario");
                localStorage.removeItem("token");
                window.location.replace("login.html");
            }

            return;
        }

        let select = document.getElementById("visitante");

        select.innerHTML =
            '<option value="">Seleccione un visitante</option>';

        data.forEach(v => {

            const idVisitante =
                v.id_visitante || v.id_visitantes;

            if (!idVisitante) {
                console.warn("Visitante sin ID válido:", v);
                return;
            }

            mapaVisitantes[idVisitante] =
                v.nombres + " " + v.apellidos;

            let option = document.createElement("option");

            option.value = idVisitante;

            option.textContent =
                v.nombres + " " + v.apellidos;

            select.appendChild(option);

        });

    } catch (error) {

        console.error("Error al cargar visitantes:", error);

    }

}
// CARGAR DATOS INICIALES
cargarVisitas();
cargarVecinos();
cargarVisitantes();