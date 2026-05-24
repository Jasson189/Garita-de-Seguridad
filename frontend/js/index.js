let mapaVisitantes = {};
let mapaVecinos = {};
let mapaViviendasVecino = {};
let imagenBase64 = "";
let todasLasVisitas = [];

/* MOSTRAR USUARIO LOGUEADO */
/* El backend guarda el nombre como nombre_usuario */
document.getElementById("nombreUsuario").textContent =
    "Usuario: " + usuarioSesion.nombre_usuario;


// Mostrar fecha y turno en el header
//Actualiza cada segundo el header 
function mostrarFecha() {

    const fechaTurno =
        document.getElementById("fecha-turno");

    function actualizarHora() {

        const ahora = new Date();

        fechaTurno.textContent =
            "Fecha y hora: " +
            ahora.toLocaleString("es-GT");
    }

    actualizarHora();

    setInterval(actualizarHora, 1000);
}

// Actualizar las metricas con animacion
function actualizarMetricas(visitas) {
    const activas = visitas.filter(v => v.estado_visita === 'activa').length;
    const total = visitas.length;
    const salidas = visitas.filter(v => v.estado_visita !== 'activa').length;
    const sinFoto = visitas.filter(v => !v.foto).length;
    const conPlaca = visitas.filter(v => v.placa).length;

    animarNumero('cnt-activas', activas);
    animarNumero('cnt-ingresos', total);
    animarNumero('cnt-salidas', salidas);
    animarNumero('cnt-sinfoto', sinFoto);

    // Barras de progreso
    const pctOcup = total > 0 ? Math.round((activas / total) * 100) : 0;
    const pctVeh = total > 0 ? Math.round((conPlaca / total) * 100) : 0;

    document.getElementById('pct-ocupacion').textContent = pctOcup + '%';
    document.getElementById('pct-vehiculos').textContent = pctVeh + '%';
    document.getElementById('bar-ocupacion').style.setProperty('--w', pctOcup + '%');
    document.getElementById('bar-vehiculos').style.setProperty('--w', pctVeh + '%');
}

// Animacion de numero que cambia con zoom
function animarNumero(id, nuevoValor) {
    const el = document.getElementById(id);
    el.style.transition = 'transform .2s, opacity .2s';
    el.style.transform = 'scale(1.3)';
    el.style.opacity = '0.3';
    setTimeout(() => {
        el.textContent = nuevoValor;
        el.style.transform = 'scale(1)';
        el.style.opacity = '1';
    }, 200); // espera 200ms para el efecto
}

// Dibuja las filas con animacion escalonada rowIn
function renderTabla(data) {

    const tbody = document.getElementById('tablaVisitas');
    tbody.innerHTML = "";

    data.forEach((v, indice) => {

        const nombreVisitante =
            mapaVisitantes[v.id_visitante] || '';

        const iniciales =
            nombreVisitante
                .split(' ')
                .map(n => n[0])
                .join('')
                .toUpperCase()
                .slice(0, 2);

        const fila = document.createElement('tr');

        fila.style.animation = 'rowIn .4s ease both';
        fila.style.animationDelay = (indice * 0.08) + 's';

        fila.innerHTML = `

<!-- ID -->
<td class="muted">
    ${v.id_visita}
</td>

<!-- VISITANTE -->
<td>
    <span class="av">
        ${iniciales}
    </span>

    ${nombreVisitante}
</td>

<!-- VECINO -->
<td class="muted">
    ${mapaVecinos[v.id_vecino] || '—'}
</td>

<!-- PLACA -->
<td class="${v.placa ? 'placa' : 'muted'}">
    ${v.placa || '—'}
</td>

<!-- FOTO -->
<td>

    ${v.foto

                ? `

            <img
                src="${API}/${v.foto}"
                width="50"
                height="50"

                style="
                    border-radius: 8px;
                    object-fit: cover;
                    border: 1px solid #ccc;
                "
            >

        `

                : '—'

            }

</td>

<!-- FECHA -->
<td class="muted">
    ${v.fecha_ingreso}
</td>

<!-- HORA -->
<td class="muted">
    ${v.hora_ingreso}
</td>

<!-- OBSERVACIONES -->
<td class="muted">
    ${v.observaciones || ''}
</td>

<!-- ESTADO -->
<td>

    <span class="badge ${v.estado_visita === 'activa'
                ? 'badge-on'
                : 'badge-off'}">

        <span class="bdot ${v.estado_visita === 'activa'
                ? 'bdot-on'
                : 'bdot-off'}"></span>

        ${v.estado_visita === 'activa'
                ? 'Activa'
                : 'Finalizada'}

    </span>

</td>

<!-- ACCION -->
<td>

    ${v.estado_visita === 'activa'

                ? `

            <button
                class="btn-salida"
                onclick="registrarSalida(${v.id_visita})"
            >
                Salida
            </button>

        `

                : '<span class="muted">—</span>'

            }

</td>

`;

        tbody.appendChild(fila);

    });

}

// Filtra el historial por visitante, vecino o placa
function filtrarTabla() {

    // Obtiene el texto escrito en el buscador
    const q = document.getElementById('buscador').value.toLowerCase();

    // Recorre todas las visitas y deja solo las que coinciden
    const filtradas = todasLasVisitas.filter(v => {

        // Obtiene el nombre del visitante desde el mapa
        const nombre = (mapaVisitantes[v.id_visitante] || '').toLowerCase();

        // Obtiene el nombre del vecino desde el mapa
        const vecino = (mapaVecinos[v.id_vecino] || '').toLowerCase();

        // Obtiene la placa registrada en la visita
        const placa = (v.placa || '').toLowerCase();

        // Devuelve las visitas que coincidan con el texto buscado
        return nombre.includes(q) ||
            vecino.includes(q) ||
            placa.includes(q);
    });
    // Vuelve a dibujar la tabla con las visitas filtradas
    renderTabla(filtradas)
}
/* REGISTRAR SALIDA */
/* Actualiza la hora de salida en PostgreSQL usando JWT */
async function registrarSalida(idVisita) {

    const token = localStorage.getItem("token");

    if (!token) {
        localStorage.removeItem("usuario");
        localStorage.removeItem("token");
        window.location.replace("login.html");
        return;
    }

    const confirmar = confirm("¿Deseas registrar la salida de esta visita?");

    if (!confirmar) {
        return;
    }

    try {

        let res = await fetch(API + "/visitas/" + idVisita + "/salida", {
            method: "PUT",
            headers: {
                "Authorization": "Bearer " + token
            }
        });

        let data = await res.json();

        if (!res.ok) {
            console.error("Error al registrar salida:", data);

            document.getElementById("mensaje").textContent =
                data.detail || "Error al registrar salida.";

            return;
        }

        document.getElementById("mensaje").textContent =
            data.mensaje || "Salida registrada correctamente.";

        cargarVisitas();

    } catch (error) {

        console.error("Error al registrar salida:", error);

        document.getElementById("mensaje").textContent =
            "Error al registrar salida.";

    }
}
/* CARGA INICIAL */
cargarVisitantes();
cargarVecinos();
cargarVisitas();
