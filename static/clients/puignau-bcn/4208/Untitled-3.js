
<style>
    .keyboard-container {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 90%;
    max-width: 400px;
    background: white;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    z-index: 1000;
}

.input-display-quant {
    width: calc(30% - 20px); /* Reducimos el ancho para dejar espacio al botón */
    height: 45px; /* Ligera reducción de altura */
    font-size: 20px;
    text-align: right;
    margin: 10px 0px 5px 0px; /* Margen superior reducido */
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 5px;
    color: black !important;
    position: absolute;
    left: 35%
}

.input-display {
    width: calc(30% - 20px); /* Reducimos el ancho para dejar espacio al botón */
    height: 45px; /* Ligera reducción de altura */
    font-size: 20px;
    text-align: right;
    margin: 10px 0px 5px 0px; /* Margen superior reducido */
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 5px;
    color: black !important;
    position: absolute;
    left: 10%
}

.input-feina {
    width: calc(30% - 20px); /* Reducimos el ancho para dejar espacio al botón */
    height: 45px; /* Ligera reducción de altura */
    font-size: 20px;
    margin: 10px 0px 5px 0px; /* Margen superior reducido */
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 5px;
    color: black !important;
    text-align:right; 
    font-weight:bold;
    position: absolute;
    left: 40%
}

.simbolEuroPriceKeyboard{
    color: black !important; font-size: 20px; text-align: right; height: 45px; display: inline-block; margin: 10px 0px 5px 0px; padding: 5px;
        position: absolute;
    }

.lobibox-notify-wrapper {
  display: none !important;
}
/* Contenedor general de la tabla */
.tabla-container {
    margin: 15px auto; /* Margen superior e inferior, centrado */
    padding: 5px;
    width: 98%; /* Ajusta el ancho para que no quede pegado a los bordes */
}

.grid-list {
    width: 100%;
    border-collapse: collapse;
    margin: 5px auto;
    color: black !important;
}
.grid-list th:nth-child(1) {
    width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
}
.grid-list th {
    width: 1%;
    padding: 8px 20px;
    background: #f8f9fa;
    text-align: center;
    font-size: 16px;
    border-bottom: 2px solid #ccc;
    color: black !important;
    white-space: nowrap;
}
.grid-list td {
    padding: 6px 8px;
    text-align: right; 
    border-bottom: 1px solid #ddd;
    color: black !important; 
    white-space: nowrap;
}
.grid-list tr:nth-child(even) {
    background-color: #f4f4f4; /* Alternar colores */
}

.grid-list tr:nth-child(odd) {
    background-color: #ffffff;
}

.grid-list td:first-child {
    text-align: left;
    padding-left: 10px;
}
.grid-list td:nth-child(3) {
    text-align: left; 
}
.grid-list button {
    padding: 6px 12px;
    font-size: 16px;
    min-width: 40px;
    color: black !important;
}
@media (max-width: 1024px) {
    .grid-list td {
        font-size: 16px;
        padding: 4px 6px;
    }
    .grid-list th {
        padding: 4px 6px;
    }
}
/* Ajuste específico para valores numéricos */
#Cantidad .form-control,
#Precio .form-control {
    width: 90px !important; /* Más ancho en tablets */
}

/* Estilos para el teclado numérico flotante */
.keyboard-container {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 90%;
    max-width: 400px;
    background: white;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    z-index: 1000;
}



.keys {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 10px;
}

.key {
    padding: 15px;
    font-size: 22px;
    text-align: center;
    background: #f0f0f0;
    border: none;
    cursor: pointer;
    border-radius: 5px;
}

.key.special {
    background: #007bff;
    color: white;
}

.key.delete {
    background: #dc3545;
    color: white;
}

/* Fondo oscuro con desenfoque */
.overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(5px);
    z-index: 999;
}

/* Ajustar el ancho mínimo de la segunda columna (Artículo) */
/* Encabezado de Artículo */
/*
th:nth-child(1), 
td:nth-child(1) {  
    min-width: 180px; 
    word-break: break-word;
} */

/* Estilos del selector de unidades */
.unit-dropdown {
    width: 100%;
    padding: 5px;
    font-size: 18px;
    margin-bottom: 10px;
    display: block;
    margin-top:5px;
}


/* Información de stock */
.stock-info {
    font-size: 18px;
    font-weight: bold;
    color: #333;
    text-align: center;
    margin-top: 10px;
}
.info-display {
    font-size: 18px;
    font-weight: bold;
    color: #333;
    text-align: center;
    margin-top: 10px;
}

.close-keyboard {
    background: #dc3545;
    color: white;
    border: none;
    font-size: 14px;
    padding: 5px 8px;
    border-radius: 50%;
    cursor: pointer;
    position: absolute;
    top: 5px;
    right: 5px;
    width: 45px;
    height: 45px;
    display: flex;
    align-items: center;
    justify-content: center;
    line-height: 1;
}

.close-keyboard:hover {
    background: #b52b3b;
}

.additional-info {
    display: flex;
    justify-content: space-between;
    font-size: 18px;
    margin: 10px 0;
    padding: 5px;
    background: #f8f9fa;
    border-radius: 5px;
}

.additional-info span {
    flex: 1;
    text-align: center;
    font-weight: bold;
}
.close-keyboard {
    background: #dc3545;
    color: white;
    border: none;
    font-size: 16px;
    padding: 8px 12px;
    border-radius: 5px;
    cursor: pointer;
    position: absolute;
    top: 10px;
    right: 10px;
}

.close-keyboard:hover {
    background: #b52b3b;
}

/* Asegurar que el flx-module tenga posición relativa para que el sticky funcione */
flx-module[modulename="pers_prepedido_linea_comercial_list"] {
    position: relative;
}

/* Hacer que el contenedor del menú se mantenga fijo */
flx-module[modulename="pers_prepedido_linea_comercial_list"] .cntBodyHeader {
    position: fixed; /* Se mantiene fijo en la pantalla */
    top: 78px;
    right: 0px; /* Asegurar que está pegado al borde izquierdo */
    //width: 100%; /* Ajusta según sea necesario */
    z-index: 1050; /* Para que esté por encima de otros elementos */
    background: white !important;
    padding: 7px;
    border: 2px solid #000; /* Borde para visualizarlo mejor */
    border-bottom: 2px solid #000 !important;
    border-left: 0px;
    border-radius: 4px;     /* Bordes redondeados */
    border-top-left-radius: 0px;
    border-bottom-left-radius: 0px;
    border-top-right-radius: 0px;
    text-align: left; /* Alinear el contenido del menú a la izquierda */
    height: 64px;
}


/* Ajustar los botones dentro del menú */
.cntBodyHeader .moduleToolbar {
    display: flex;
    gap: 8px;
    justify-content: start; /* Alinear a la izquierda */
    flex-wrap: wrap; /* Permite que los botones se ajusten si no caben */
}

.cntBodyHeader .btn-group {
    display: flex;
}

.cntBodyHeader .btn {
    padding: 8px 12px;
    font-size: 14px;
    border-radius: 4px;
    border: none;
    transition: all 0.2s ease-in-out;
}

/* Espacio para evitar que el contenido quede tapado */
flx-module[modulename="pers_prepedido_linea_comercial_list"] .filterPanel {
    margin-top: 60px; /* Ajusta la distancia según sea necesario */
}
flx-module[modulename="prepedido_Edit_comer"] .cntBody {
        position: relative;
}
flx-module[modulename="prepedido_Edit_comer"] .cntBodyFooter {
    position: relative;
}
flx-module[modulename="prepedido_Edit_comer"] .cntBodyFooter .btn-toolbar{
    position: absolute;
    top: -65px;
    right: 0em;
    z-index: 2;
}

flx-module[modulename="pers_prepedido_button_module_comercial"]{
    height:0px;
}

@media (max-width: 900px) {
    .cntBodyHeader .moduleToolbar.btn-toolbar button {
        max-width: 200px;}
    flx-module[modulename="pers_prepedido_linea_comercial_list"] .cntBodyHeader {
        z-index:10;
    }
    header {
        z-index: 1049;
    }
}
</style>
<script>
function refreshButtonera () {
    $("#mod-pers_prepedido_button_module_comercial")[0].refresh();    
} 
function refreshEditGridP () {
    $("#mod-pers_prepedido_linea_comercial_list")[0].refresh();
}

(function() {
    function attachSelectAllListeners() {
        let inputs = document.querySelectorAll('flx-text[control-class="cantidadInput"] input.form-control');
        console.log('Cantidad de inputs encontrados:', inputs.length);

        inputs.forEach(function (inputElem) {
            if (!inputElem.dataset.selectListenerAdded) {
                inputElem.addEventListener('focus', (ev) => ev.currentTarget.select());
                inputElem.addEventListener('click', (ev) => ev.currentTarget.select());
                inputElem.dataset.selectListenerAdded = 'true';
            }
        });
    }

    // 1) Verificar que al menos el script se ejecuta
    console.log('Script attachSelectAllListeners cargado');

    // 2) Engancharnos al evento del MÓDULO con modulename = "pers_prepedido_linea_tlv2_list"
    flexygo.events.on('module', 'loaded', function (e) {
    // e.sender tiene info del módulo que se acaba de cargar
        if (e.sender && e.sender.moduleName === 'pers_prepedido_linea_comercial_list') {
            console.log('[module.loaded] Se dibujó pers_prepedido_linea_tlv2_list');
            attachSelectAllListeners();
        }
    });

    // Si ese módulo ya estaba precargado al llegar aquí, puede que necesites
    // forzar una primera llamada. Por si acaso:
    setTimeout(attachSelectAllListeners, 1000);
})();

function closeKeyboards() {
    document.getElementById("keyboard").style.display = "none";
    document.getElementById("keyboard-price").style.display = "none";
    document.getElementById("overlay").style.display = "none";
    document.body.classList.remove("blurred-background");
    eliminarQuantitat = 0;
    refreshEditGridP();
}

let currentPriceElement = null;
let idPrePedidoPrice = null;
let idPrePedidoLineaPrice = null;
let eliminarQuantitat = 0;
function showPriceKeyboard(
  element,
  IdPrePedido,
  IdPrePedidoLinea,
  PrecioT1,
  PrecioT2,
  PrecioT3,
  PrecioT4,
  PrecioT5,
  PreuCost,
  DescripArticle, 
  PrecioSinFeina, 
  PrecioFeina,
  PrecioCliente,
  PrecioCaixa
) {
    // Asignaciones previas
    currentPriceElement = element;
    idPrePedidoPrice = IdPrePedido;
    idPrePedidoLineaPrice = IdPrePedidoLinea;
    lastFocusedInput = document.getElementById("priceInput");
    lastFocusedInput.style = "border: 4px solid black; padding: 2px;";

    // Referencias a elementos del DOM
    let priceSelect = document.getElementById("priceSelect");
    let priceInput = document.getElementById("priceInput");
    let costDisplay = document.getElementById("costDisplay");
    let costContainer = document.getElementById("costContainer");
    let descriptionContainer = document.getElementById("descriptionContainer");
    let descriptionDisplay = document.getElementById("descriptionDisplay");

    if (!priceSelect || !priceInput || !costDisplay || 
        !costContainer || !descriptionContainer || !descriptionDisplay) {
        console.error("❌ ERROR: Elementos del teclado de precio no encontrados en el DOM");
        return;
    }

    // 1) COST: mostrar/ocultar + formatear (2 decimales, coma, €)
    let numericCost = parseFloat(PreuCost);
    if (!numericCost || numericCost === 0) {
        // Ocultamos si es 0, null o no numérico
        costContainer.style.display = 'none';
    } else {
        // Mostramos si es > 0
        costContainer.style.display = 'block';
        // Formatear a 2 decimales + coma + €
        let costFormatted = numericCost.toFixed(2).replace('.', ',') + '€';
        costDisplay.innerText = costFormatted;
    }

    // 2) TARIFAS: formatear en el desplegable
    let precios = [
        { valor: PrecioCliente - PrecioFeina, texto: "PREU ACT"},
        { valor: PrecioT1, texto: "TARIFA 1" },
        { valor: PrecioT2, texto: "TARIFA 2" },
        { valor: PrecioT3, texto: "TARIFA 3" },
        { valor: PrecioT4, texto: "TARIFA 4" },
        { valor: PrecioT5, texto: "TARIFA 5" },
        { valor: PrecioCaixa, texto: "PREU CAIXA" }
    ];
    // ► dentro de showPriceKeyboard, justo tras rellenar el input principal:
    let pfInput = document.getElementById('precioFeinaInput');
    if (pfInput) {
    if (PrecioFeina && !isNaN(parseFloat(PrecioFeina))) {
        pfInput.textContent = parseFloat(PrecioFeina)
                        .toFixed(2)            // 2 decimales
                        .replace('.', ',');    // coma para el usuario
    } else {
        pfInput.textContent = ''; // vacío para que pueda escribir
    }
    }

    // ► Mostrar Precio Feina al lado del OK
    let pfSpan = document.getElementById('precioFeinaDisplay');
    if (pfSpan) {
    if (PrecioFeina && !isNaN(parseFloat(PrecioFeina))) {
        pfSpan.textContent = parseFloat(PrecioFeina)
                            .toFixed(2)
                            .replace('.', ',') + '€';
        pfSpan.style.display = 'inline-block';
    } else {
        pfSpan.style.display = 'none';
    }
    }
    priceSelect.innerHTML = "";
    precios.forEach(precio => {
        let numericVal = parseFloat(precio.valor);
        // Solo agregar opciones con valor > 0
        if (numericVal && numericVal > 0) {
            // Formateamos a 2 decimales con coma y €
            let formattedTarifa = numericVal.toFixed(2).replace('.', ',') + '€';

            let option = document.createElement("option");
            option.value = precio.valor; // Mantiene el valor real
            option.textContent = `${precio.texto}: ${formattedTarifa} (${((precio.valor - PreuCost) / precio.valor * 100).toFixed(2)} %)`;
            priceSelect.appendChild(option);
        }
    });

    // 3) Mostrar en el input el precio actual (texto del elemento)
    let precioActual = PrecioSinFeina ?? element.textContent.trim();
    priceInput.textContent = String(precioActual).replace('.', ',');

    // 4) Descripción del artículo (similar lógica a showKeyboard):
    //    - Si no hay texto, ocultamos. Si lo hay, truncamos a 45 caracteres.
    if (!DescripArticle || DescripArticle.trim().length === 0) {
        // Vacío o null => ocultar
        descriptionContainer.style.display = 'none';
    } else {
        let truncatedDesc = (DescripArticle.length > 40)
            ? DescripArticle.slice(0, 40) + "…"
            : DescripArticle;

        descriptionDisplay.innerText = truncatedDesc;
        descriptionContainer.style.display = 'block';
    }

    // 5) Mostrar teclado y overlay
    document.getElementById("keyboard-price").style.display = "block";
    document.getElementById("overlay").style.display = "block";
    document.body.classList.add("blurred-background");
}

function updatePriceInput() {
    let selectedPrice = document.getElementById("priceSelect").value;
    document.getElementById("priceInput").textContent = selectedPrice;
}

let lastFocusedInput = null;

// Track last focused input
document.getElementById("priceInput").addEventListener("click", () => {
lastFocusedInput = document.getElementById("priceInput");
document.getElementById("priceInput").style = "border: 4px solid black; padding: 2px;";
document.getElementById("precioFeinaInput").style = "";
});
document.getElementById("precioFeinaInput").addEventListener("click", () => {
lastFocusedInput = document.getElementById("precioFeinaInput");
document.getElementById("precioFeinaInput").style = "border: 4px solid black; padding: 2px;";
document.getElementById("priceInput").style = "";
});

function addPriceNumber(num) {
    const active = lastFocusedInput;
    if (active && (active.id === 'priceInput' || active.id === 'precioFeinaInput')){
        if (eliminarQuantitat == 1){
            active.textContent = num;
            eliminarQuantitat = 0;
        } 
        else{
            active.textContent += num;
        }
    }
    
}

function addPriceDecimal() {
    const active = lastFocusedInput;
    if (active && (active.id === 'priceInput' || active.id === 'precioFeinaInput')){
        if (!active.textContent.includes(',')) {
            active.textContent += ',';
        }
    }
}

function deletePriceNumber() {
    const active = lastFocusedInput;
    if (active && (active.id === 'priceInput' || active.id === 'precioFeinaInput')){
        active.textContent = active.textContent.slice(0, -1);
    }
}

function pActualizarPrePedidoLineaQuant(elm, IdPrePedido, IdPrePedidoLinia) {
    let val = elm.getAttribute('value');
    let numericVal = parseFloat(val) || 0;

    if (numericVal === 0) {
        // Si es 0 => proceso "pPers_PrePedido_Lineas_U_Quant0"
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U_Quant0',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinea = ${IdPrePedidoLinia}`,
            `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinea': '${IdPrePedidoLinia}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    } else {
        // Caso distinto de 0 => mantiene lógica actual
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinea = ${IdPrePedidoLinia} and Quantitat = ${val}`,
            `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinea': '${IdPrePedidoLinia}','Quantitat': '${val}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    }
}

function pActualizarPrePedidoLineaQuant2(Numero, IdPrePedido, IdPrePedidoLinia) {
    let numericNumero = parseFloat(Numero) || 0;

    if (numericNumero === 0) {
        // Si es 0 => proceso "pPers_PrePedido_Lineas_U_Quant0"
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U_Quant0',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinea = ${IdPrePedidoLinia}`,
            `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinea': '${IdPrePedidoLinia}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    } else {
        // Caso distinto de 0 => mantiene lógica actual
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and Quantitat = ${Numero}`,
            `{'IdPrePedido': '${IdPrePedido}', 'IdPrePedidoLinia': '${IdPrePedidoLinia}', 'Quantitat': '${Numero}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    }
}

function pActualizarPrePedidoLineaPrecio(elm, IdPrePedido, IdPrePedidoLinia) {
    // Tomamos el valor del elemento
    let val = elm.getAttribute('value');
    // Convertimos a número
    let numericVal = parseFloat(val) || 0;
debugger;
    if (numericVal === 0) {
        // Si es 0 => proceso "pPers_PrePedido_Lineas_U_Precio0"
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U_Precio0',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinea = ${IdPrePedidoLinia}`,
            `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinea': '${IdPrePedidoLinia}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    } else {
        // Si es distinto de 0 => se mantiene la lógica actual
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinea = ${IdPrePedidoLinia} and Precio = ${val}`,
            `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinea': '${IdPrePedidoLinia}','Precio': '${val}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    }
}

function pActualizarPrePedidoLineaPrecio2(Price, IdPrePedido, IdPrePedidoLinia) {
    // Convertimos el precio a número
    let numericPrice = parseFloat(Price) || 0;
    
    if (numericPrice === 0) {
        // Si es 0 => proceso "pPers_PrePedido_Lineas_U_Precio0"
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U_Precio0',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinea = ${IdPrePedidoLinia}`,
            `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinea': '${IdPrePedidoLinia}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    } else {
        // Si es distinto de 0 => se mantiene la lógica actual
        flexygo.nav.execProcess(
            'pPers_PrePedido_Lineas_U',
            'P_PrePedido_Lineas_TELEV2',
            `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and Precio = ${Price}`,
            `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','Precio': '${Price}'}`,
            null,
            'current',
            false,
            null,
            null,
            false
        );
    }
}

function pActualizarPrePedidoLineaTUnitat(elm, IdPrePedido, IdPrePedidoLinia) {
    let objName = elm.getAttribute('objectname');
    let updateField = elm.id;
    let val = elm.getAttribute('value');

    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and Tunitat = ${val}`,
        `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','Tunitat': '${val}'}`,
        null,
        'current',
        false,
        null,
        null,
        false
    );
}

function pActualizarPrePedidoLineaTUnitat2(Tunitat, IdPrePedido, IdPrePedidoLinia) {
    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and Tunitat = '${Tunitat}'`,
        `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','Tunitat': '${Tunitat}'}`,
        null,
        'current',
        false,
        null,
        null,
        false
    );
}

function pActualizarPrePedidoLineaTObs(elm, IdPrePedido, IdPrePedidoLinia) {
    let objName = elm.getAttribute('objectname');
    let updateField = elm.id;
    let val = elm.getAttribute('value');

    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and TObs = ${val}`,
        `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','TObs': '${val}'}`,
        null,
        'current',
        false,
        null,
        null,
        false
    );
}

function pActualizarPrePedidoLineaPrecioFeina(val, IdPrePedido, IdPrePedidoLinea) {
  flexygo.nav.execProcess(
      'pPers_PrePedido_Lineas_U_Precio_Feina2',
      'P_PrePedido_Lineas_TELEV2',
      `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinea}`,
      `{'IdPrePedido': '${IdPrePedido}',
        'IdPrePedidoLinia': '${IdPrePedidoLinea}',
        'PrecioFeinaNew': '${val}'}`,
      null,
      'current',
      false,
      null,
      null,
      false
  );
}

function submitPrice() {
  // Valores escritos por el usuario
  let priceRaw = document.getElementById("priceInput").textContent.replace(',', '.');
  let pfRaw    = document.getElementById("precioFeinaInput").textContent.replace(',', '.');

  // Validaciones
  if (priceRaw === '' || isNaN(priceRaw)) {
    alert("Precio incorrecto.");
    return;
  }
  
  // Normalizamos a 2 decimales con punto
  let price = parseFloat(priceRaw).toFixed(2);
  let val   = parseFloat(pfRaw).toFixed(2);

  // 1) Precio normal
  pActualizarPrePedidoLineaPrecio2(price, idPrePedidoPrice, idPrePedidoLineaPrice);

  if (pfRaw === '' || isNaN(pfRaw)) {
  
  }
  else {
    // 2) Precio Feina
    pActualizarPrePedidoLineaPrecioFeina(val, idPrePedidoPrice, idPrePedidoLineaPrice);
  }

  // 3) Cerrar teclado y limpiar
  document.getElementById("keyboard-price").style.display = "none";
  document.getElementById("overlay").style.display = "none";
  document.body.classList.remove("blurred-background");

  document.getElementById("priceInput").textContent       = '';
  document.getElementById("precioFeinaInput").textContent = '';
}

function pActualizarPrePedidoLineaObs(elm, IdPrePedido, IdPrePedidoLinia) {
    let objName = elm.getAttribute('objectname');
    let updateField = elm.id;
    let val = elm.getAttribute('value');

    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and Obs = ${val}`,
        `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','Obs': '${val}'}`,
        null,
        'current',
        false,
        null,
        null,
        false
    );
}

let currentElement = null;
let idPrePedido = null;
let idPrePedidoLinea = null;
function showKeyboard(
  element, 
  IdPrePedido, 
  IdPrePedidoLinea, 
  PermiteKGS, 
  PermitePEC, 
  PermiteFDO, 
  StockCalc, 
  KGPres, 
  TotalCantidad, 
  DescripArticle,
  defaultUnit
) {
    eliminarQuantitat = 1;

    currentElement = element;
    idPrePedido = IdPrePedido;
    idPrePedidoLinea = IdPrePedidoLinea;

    // Convertir '1'/'true' a boolean
    PermiteKGS = (PermiteKGS === '1' || PermiteKGS === 1 || PermiteKGS === true || PermiteKGS === "true");
    PermitePEC = (PermitePEC === '1' || PermitePEC === 1 || PermitePEC === true || PermitePEC === "true");
    PermiteFDO = (PermiteFDO === '1' || PermiteFDO === 1 || PermiteFDO === true || PermiteFDO === "true");

    // Evitar undefined
    KGPres = KGPres ?? '0';
    TotalCantidad = TotalCantidad ?? '0';
    StockCalc = StockCalc ?? 'Sin Stock';
    DescripArticle = DescripArticle || '';

    let numberInput = document.getElementById("numberInput");
    let unitSelect = document.getElementById("unitSelect");
    let kgPresDisplay = document.getElementById("kgPresDisplay");
    let totalCantidadDisplay = document.getElementById("totalCantidadDisplay");
    let stockDisplay = document.getElementById("stockDisplay");
    let articleDescDisplay = document.getElementById("articleDesc");

    if (!numberInput || !unitSelect || !kgPresDisplay || 
        !totalCantidadDisplay || !stockDisplay || !articleDescDisplay) {
        console.error("❌ ERROR: Algún elemento HTML no se encontró.");
        return;
    }

    // Truncar a 45 caracteres y añadir "…" si excede
    let truncatedDesc = (DescripArticle.length > 40)
                      ? DescripArticle.slice(0, 40) + "…"
                      : DescripArticle;
    
    // Asignar texto
    articleDescDisplay.innerText = truncatedDesc;

    // Valores iniciales
    numberInput.textContent = TotalCantidad;
    kgPresDisplay.innerText = KGPres;
    totalCantidadDisplay.innerText = TotalCantidad;

    // Stock
    if (StockCalc !== "Sin Stock") {
        stockDisplay.innerHTML = `<strong style="font-size: 18px;">Stock disponible: ${StockCalc}</strong>`;
        stockDisplay.style.display = "block";
    } else {
        stockDisplay.innerHTML = "Sin Stock";
        stockDisplay.style.display = "none";
    }

    // Limpiar y cargar las opciones de unidad
    unitSelect.innerHTML = "";
    let optionsAdded = false;

    if (PermiteKGS) {
        let optionKGS = document.createElement("option");
        optionKGS.value = "KG";
        optionKGS.textContent = "KG";
        unitSelect.appendChild(optionKGS);
        optionsAdded = true;
    }
    if (PermitePEC) {
        let optionPEC = document.createElement("option");
        optionPEC.value = "Pec";
        optionPEC.textContent = "Pec";
        unitSelect.appendChild(optionPEC);
        optionsAdded = true;
    }
    if (PermiteFDO) {
        let optionFDO = document.createElement("option");
        optionFDO.value = "Far.";
        optionFDO.textContent = "Far.";
        unitSelect.appendChild(optionFDO);
        optionsAdded = true;
    }

    // Mostrar/ocultar el <select> según haya o no opciones
    unitSelect.style.display = optionsAdded ? "block" : "none";

    // ---------------------------------------------------------------------------------------
    // Seleccionar por defecto la unidad que nos pasen por parámetro "defaultUnit", si coincide
    // ---------------------------------------------------------------------------------------
    if (defaultUnit) {
  // Convertimos el valor a minúsculas y quitamos espacios
  let defUnitNormalized = defaultUnit.trim().toLowerCase();

  // Recorremos las opciones del select comparando en minúsculas
  for (let i = 0; i < unitSelect.options.length; i++) {
    if (unitSelect.options[i].value.toLowerCase() === defUnitNormalized) {
      // Si coincide, seleccionamos esta opción
      unitSelect.selectedIndex = i;
      break;
    }
  }
}

    document.getElementById("keyboard").style.display = "block";
    document.getElementById("overlay").style.display = "block";
    document.body.classList.add("blurred-background");
}

function addNumber(num) {
    if (eliminarQuantitat == 1){
        document.getElementById("numberInput").textContent = num;
        eliminarQuantitat = 0;
    } 
    else{
        document.getElementById("numberInput").textContent += num;
    }
    updateTotalCantidad(); // ✅ Recalcular el total
}

function addDecimal() {
    let inputField = document.getElementById("numberInput");
    if (!inputField.textContent.includes('.')) {
        inputField.textContent += '.';
    }
}
function deleteNumber() {
    let inputField = document.getElementById("numberInput");
    inputField.textContent = inputField.textContent.slice(0, -1);
    updateTotalCantidad(); // ✅ Recalcular el total
}

function submitNumber() {
    let number = document.getElementById("numberInput").textContent;
    let selectedUnit = document.getElementById("unitSelect").value;
    eliminarQuantitat = 0;
    if (number && !isNaN(number)) {
        // ✅ Llamamos a la función para actualizar la cantidad
        pActualizarPrePedidoLineaQuant2(number, idPrePedido, idPrePedidoLinea);

        // ✅ Verificamos si se ha cambiado la unidad
        if (selectedUnit) {
            pActualizarPrePedidoLineaTUnitat2(selectedUnit, idPrePedido, idPrePedidoLinea);
        }

        // ✅ Cerrar el teclado numérico
        document.getElementById("keyboard").style.display = "none";
        document.getElementById("overlay").style.display = "none";
        document.body.classList.remove("blurred-background");

        // ✅ Limpiar el input
        document.getElementById("numberInput").textContent = "";
    } else {
        alert("Ingrese un número válido antes de continuar.");
    }
}

function refreshStockCalc() {
    $("#stockDisplay").load(location.href + " #stockDisplay > *");
}
function updateTotalCantidad() {
    let cantidad = parseFloat(document.getElementById("numberInput").textContent) || 0;
    let kgPres = parseFloat(document.getElementById("kgPresDisplay").innerText) || 1;
    
    let total = cantidad * kgPres;
    document.getElementById("totalCantidadDisplay").innerText = total.toFixed(2);
}
</script>

<!-- Fondo de overlay -->
<div class="overlay" id="overlay"></div>

<!-- Teclado numérico de cantidad -->

<div class="keyboard-container" id="keyboard">
    <button class="close-keyboard" onclick="closeKeyboards()">✖</button>
    <div style="height:70px">
    <span id="numberInput" class="input-display-quant">
    </div>

    <!-- Select para unidades -->
    <select id="unitSelect" class="unit-dropdown" style="display: none;"></select>

    <!-- 🟢 Mostrar KGPres y TotalCantidad junto al select -->
    <div class="additional-info">
        <span><strong>KG Pres:</strong> <span id="kgPresDisplay">0</span></span>
        <span><strong>Total Cant.:</strong> <span id="totalCantidadDisplay">0</span></span>
    </div>
      <div class="additional-info" style="font-size:14px;">
      <span><strong></strong>
        <span id="articleDesc" style="font-size:14px;"></span>
      </span>
    </div>
   
    <div class="keys">
        <button class="key" onclick="addNumber(1)">1</button>
        <button class="key" onclick="addNumber(2)">2</button>
        <button class="key" onclick="addNumber(3)">3</button>
        <button class="key" onclick="addNumber(4)">4</button>
        <button class="key" onclick="addNumber(5)">5</button>
        <button class="key" onclick="addNumber(6)">6</button>
        <button class="key" onclick="addNumber(7)">7</button>
        <button class="key" onclick="addNumber(8)">8</button>
        <button class="key" onclick="addNumber(9)">9</button>
        <button class="key delete" onclick="deleteNumber()">⌫</button>
        <button class="key" onclick="addNumber(0)">0</button>
        <button class="key" onclick="addDecimal()">,</button>
        <button class="key special" onclick="submitNumber()">OK</button>
    </div>

    <!-- 🟢 Campo StockCalc abajo -->
    <div id="stockDisplay" class="stock-info">
        Stock disponible: <strong>Sin Stock</strong>
    </div>
</div>

<!-- Teclado numérico de precio -->
<div class="keyboard-container" id="keyboard-price">
    <button class="close-keyboard" onclick="closeKeyboards()">✖</button>
    <div style="height:70px">
        <span id="priceInput" class="input-display"/>
        <span style="left: calc(40% - 20px);" class="simbolEuroPriceKeyboard">€</span>
        <span id="precioFeinaInput" class="input-feina"/>
        <span style="left: calc(70% - 20px);" class="simbolEuroPriceKeyboard">€ Feina</span>
    </div>


    <select id="priceSelect" class="unit-dropdown" onchange="updatePriceInput()">
        <option value="0.00">TARIFA 1: 0.00€</option>
        <option value="0.00">TARIFA 2: 0.00€</option>
        <option value="0.00">TARIFA 3: 0.00€</option>
        <option value="0.00">TARIFA 4: 0.00€</option>
        <option value="0.00">TARIFA 5: 0.00€</option>
    </select>
    
    <div class="additional-info" id="costContainer" style="margin: 10px 0; display: none;">
      <span><strong>Cost:</strong> <span id="costDisplay"></span></span>
    </div>
<!-- NUEVO: Bloque para la descripción del artículo -->
    <div class="additional-info" id="descriptionContainer" style="margin: 10px 0; display: none; font-size:14px;">
      <span><strong></strong> 
        <span id="descriptionDisplay"></span>
      </span>
    </div>
    <div class="keys">
        <button class="key" onclick="addPriceNumber(1)">1</button>
        <button class="key" onclick="addPriceNumber(2)">2</button>
        <button class="key" onclick="addPriceNumber(3)">3</button>
        <button class="key" onclick="addPriceNumber(4)">4</button>
        <button class="key" onclick="addPriceNumber(5)">5</button>
        <button class="key" onclick="addPriceNumber(6)">6</button>
        <button class="key" onclick="addPriceNumber(7)">7</button>
        <button class="key" onclick="addPriceNumber(8)">8</button>
        <button class="key" onclick="addPriceNumber(9)">9</button>
        <button class="key delete" onclick="deletePriceNumber()">⌫</button>
        <button class="key" onclick="addPriceNumber(0)">0</button>
        <button class="key" onclick="addPriceDecimal()">,</button>
        <button class="key special" onclick="submitPrice(); return false;">OK</button>
    </div>
</div>
