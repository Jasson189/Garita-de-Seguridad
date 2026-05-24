async function iniciarCamara() {
    let stream = await navigator.mediaDevices.getUserMedia({ video: true });
    const video = document.getElementById("video");
    const camBox = document.getElementById("cam-box");
    video.srcObject = stream;
    video.style.display = "block";
    camBox.style.display = "none";
    document.getElementById("cam-txt").textContent = "Cámara activa";
}
/* TOMAR FOTO */
/* Captura la imagen del video */
/* la guarda en imagenBase64 */
/* y la muestra en pantalla */
function tomarFoto() {

    const video = document.getElementById("video");
    const canvas = document.getElementById("canvas");
    const camBox = document.getElementById("cam-box");

    const ctx = canvas.getContext("2d");

    ctx.drawImage(video, 0, 0, 320, 240);

    imagenBase64 = canvas.toDataURL("image/png");

    video.style.display = "none";
    canvas.style.display = "block";

    camBox.style.display = "none";

    document.getElementById("cam-txt").textContent =
        "Foto capturada";
}