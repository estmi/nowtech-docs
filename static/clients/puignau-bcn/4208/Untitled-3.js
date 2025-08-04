<script>

let idPrePedidoUnit = null;
let idPrePedidoLineaUnit = null;
let currentUnit = null; // Para almacenar la unidad actual
function showUnitKeyboard(element, IdPrePedido, IdPrePedidoLinea, PermiteKGS, PermitePEC, PermiteFDO) {
    console.log("📌 showUnitKeyboard ejecutado con parámetros:", { IdPrePedido, IdPrePedidoLinea, PermiteKGS, PermitePEC, PermiteFDO });

    idPrePedidoUnit = IdPrePedido;
    idPrePedidoLineaUnit = IdPrePedidoLinea;
    
    // Extraer la unidad actual del texto de la celda
    currentUnit = element.innerText.trim();
    console.log("🔹 Unidad actual:", currentUnit);

    let unitSelect = document.getElementById("unitSelectOnly");

    if (!unitSelect) {
        console.error("❌ ERROR: No se encontró el selector de unidad en el DOM");
        return;
    }

    // ✅ Limpiar opciones previas
    unitSelect.innerHTML = "";
    let optionsAdded = false;

    // ✅ Agregar opciones según permisos
    let options = [];
    if (PermiteKGS) options.push({ value: "KG", text: "KG" });
    if (PermitePEC) options.push({ value: "Pec", text: "Pec" });
    if (PermiteFDO) options.push({ value: "Far.", text: "Far." });

    options.forEach(option => {
        let optElement = document.createElement("option");
        optElement.value = option.value;
        optElement.textContent = option.text;
        unitSelect.appendChild(optElement);
        optionsAdded = true;
    });

    // ✅ Seleccionar automáticamente la unidad actual
    if (currentUnit && [...unitSelect.options].some(opt => opt.value === currentUnit)) {
        unitSelect.value = currentUnit;
    }

    // ✅ Mostrar módulo si hay opciones
    if (optionsAdded) {
        document.getElementById("keyboard-unit").style.display = "block";
        document.getElementById("overlay").style.display = "block";
        document.body.classList.add("blurred-background");
    } else {
        alert("No hay unidades disponibles para seleccionar.");
    }
}

function submitUnitSelection() {
    let selectedUnit = document.getElementById("unitSelectOnly").value;

    if (selectedUnit) {
        console.log("✅ Unidad seleccionada:", selectedUnit);

        // ✅ Llamar al proceso en Flexygo para actualizar la unidad
        pActualizarPrePedidoLineaTUnitat(selectedUnit, idPrePedidoUnit, idPrePedidoLineaUnit);

        // ✅ Cerrar el teclado de unidad
        closeKeyboards();
    } else {
        alert("Seleccione una unidad antes de continuar.");
    }
}

function closeKeyboards() {
    console.log("📌 Cerrar todos los teclados.");
    
    let keyboard = document.getElementById("keyboard");
    let keyboardPrice = document.getElementById("keyboard-price");
    let keyboardUnit = document.getElementById("keyboard-unit");
    let overlay = document.getElementById("overlay");

    if (keyboard) keyboard.style.display = "none";
    if (keyboardPrice) keyboardPrice.style.display = "none";
    if (keyboardUnit) keyboardUnit.style.display = "none";
    if (overlay) overlay.style.display = "none";

    document.body.classList.remove("blurred-background");
}

function pActualizarPrePedidoLineaTUnitat(Tunitat, IdPrePedido, IdPrePedidoLinia) {
    console.log("📌 Enviando a Flexygo:", { Tunitat, IdPrePedido, IdPrePedidoLinia });

    if (!IdPrePedido || !IdPrePedidoLinia || !Tunitat) {
        console.error("❌ ERROR: Parámetros inválidos para actualizar la unidad.");
        return;
    }

    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = '${IdPrePedido}' and IdPrePedidoLinia = '${IdPrePedidoLinia}'`,
        JSON.stringify({
            IdPrePedido: IdPrePedido,
            IdPrePedidoLinia: IdPrePedidoLinia,
            Tunitat: Tunitat
        }),
        null,
        'current',
        false,
        null,
        null,
        false
    );
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
    if (e.sender && e.sender.moduleName === 'pers_prepedido_linea_tlv2_list') {
      console.log('[module.loaded] Se dibujó pers_prepedido_linea_tlv2_list');
      attachSelectAllListeners();
    }
  });

  // Si ese módulo ya estaba precargado al llegar aquí, puede que necesites
  // forzar una primera llamada. Por si acaso:
  setTimeout(attachSelectAllListeners, 1000);
})();




function pActualizarPrePedidoLineaQuant(elm, IdPrePedido, IdPrePedidoLinia) {
    let objName = elm.getAttribute('objectname');
    let updateField = elm.id;
    let val = elm.getAttribute('value');

    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and Quantitat = ${val}`,
        `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','Quantitat': '${val}'}`,
        null,
        'current',
        false,
        null,
        null,
        false
    );
}
function pActualizarPrePedidoLineaPrecio(elm, IdPrePedido, IdPrePedidoLinia) {
    let objName = elm.getAttribute('objectname');
    let updateField = elm.id;
    let val = elm.getAttribute('value');

    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and Precio = ${val}`,
        `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','Precio': '${val}'}`,
        null,
        'current',
        false,
        null,
        null,
        false
    );
     
}

function pActualizarPrePedidoLineaPrecioFeina(elm, IdPrePedido, IdPrePedidoLinia) {
    let objName = elm.getAttribute('objectname');
    let updateField = elm.id;
    let val = elm.getAttribute('value');

    flexygo.nav.execProcess(
        'pPers_PrePedido_Lineas_U',
        'P_PrePedido_Lineas_TELEV2',
        `IdPrePedido = ${IdPrePedido} and IdPrePedidoLinia = ${IdPrePedidoLinia} and PrecioFeina = ${val}`,
        `{'IdPrePedido': '${IdPrePedido}','IdPrePedidoLinia': '${IdPrePedidoLinia}','PrecioFeina': '${val}'}`,
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
</script>
<style>
  /* Tabla a 100% con líneas */
.tabla-datos {
  width: 100%;
  border-collapse: collapse; /* Para que cada celda comparta bordes */
  background: white;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
  color: black;
}


.tabla-datos th,
.tabla-datos td {
  border: 1px solid #ddd;
  padding: 0px !important; /* Reduce padding para evitar crecimiento */
  vertical-align: middle;
  color: black;
  font-size: 14px;
  /*font-family: "Roboto";*/
  height: 17px !important;
  min-height: 17px !important;
  max-height: 17px !important;
  line-height: 17px !important; /* Asegura altura fija */
  overflow: hidden; /* Evita que el contenido fuerce la expansión */
  white-space: nowrap; /* Evita saltos de línea */
}


/* Todos los inputs dentro de la tabla */
.tabla-datos td input.form-control {
  margin: 0px !important;        /* Elimina margen de Bootstrap */
  padding: 0px !important;     /* Ajusta el relleno */
  line-height: normal !important; /* Evita que crezca la altura */
  height: 17px !important;     /* Asegura altura fija si lo deseas */
  min-height: 17px !important;
  max-height: 17px !important;
  font-size: 14px;
  font-weight: bold;
  color: black;
  border: none;               /* Eliminar el borde */
  background-color: transparent; /* Fondo transparente */
  outline: none;              /* Eliminar el contorno al hacer focus */
  font: inherit;              /* Heredar la tipografía del contenedor */
  vertical-align: right;     /* Ajuste vertical si lo deseas */
  box-shadow: none !important;
  -webkit-box-shadow: none !important;
  -moz-box-shadow: none !important;
}


/* Ajustes específicos para cada columna (si usas ID en su contenedor) */

/* 1) Quantitat: ejemplo de ancho aproximado */
#Cantidad .form-control {
  width: 70px !important;
  text-align: center;
  height: 17px !important;     /* Asegura altura fija si lo deseas */
}
#Cantidad .input-group input {
  border: none;               /* Eliminar el borde */
  background-color: transparent; /* Fondo transparente */
  outline: none;              /* Eliminar el contorno al hacer focus */
  font: inherit;              /* Heredar la tipografía del contenedor */
  color: inherit;             /* Heredar color de texto */
  padding: 0;                 /* Asegurarte de quitar padding */
  margin: 0;                  /* Eliminar margenes */
  vertical-align: middle;     /* Ajuste vertical si lo deseas */
}


/* 2) T. Unitat (combo) */
#TipoUnidad .form-control {
  width: 70px !important;
  text-align: center;
  height: 17px !important;     /* Asegura altura fija si lo deseas */
  /* Para que no se desplace verticalmente, nos aseguramos de que
     el contenedor esté alineado correctamente */
}
#TipoUnidad .input-group {
  vertical-align: middle !important; 
}

/* 3) Ocultar el botón de desplegar (la flechita) en todos los combos */
#TipoUnidad .input-group-btn {
  display: none !important;
}

/* 4) Preu */
#Precio .form-control {
  width: 70px !important;
  text-align: right !important;
}

#PrecioFeina .form-control {
  width: 70px !important;
  text-align: right !important;
}

/* 4) Preu */
#Cantidad .form-control {
  text-align: right !important;
}

/* 5) TObs. */
#TipoObservacion .form-control {
  width: 40px !important;
  text-align: center;
}

/* 6) Observaciones, mínimo 250px */
#Observacion .form-control {
  min-width: 240px !important;
  /* Si quieres forzar un ancho fijo en lugar de “mínimo”
     puedes usar width: 250px !important; */
  height: 17px !important;
  line-height: normal !important;
  font-weight: bold;
  color: black;
}

/* Si quieres que la fila resalte al hover, por ejemplo */
.tabla-datos tbody tr:hover {
  background-color: #ffdf9b;
}


/* Asegurar que el flx-module tenga posición relativa */
flx-module[modulename="pers_prepedido_linea_tlv2_list"] {
    position: relative;
}

/* Hacer que el contenedor del menú se mantenga fijo */
flx-module[modulename="pers_prepedido_linea_tlv2_list"] .cntBodyHeader {
    position: fixed;
    top: 80px;
    left: 200px;
    width: 80%;
    z-index: 1050;
    background: white !important;
    padding: 10px;
    border: 2px solid #000;
    border-bottom: 2px solid #000 !important;
    border-radius: 4px;
    height: auto;
    display: flex;
    align-items: center;
    justify-content: space-between; /* Separa el buscador y los botones */
    gap: 10px;
}
/* Ajustar el contenedor del buscador para que esté alineado a la izquierda */
flx-module[modulename="pers_prepedido_linea_tlv2_list"] flx-filter.active {
    flex-grow: 1; /* Ocupa todo el espacio posible */
    display: flex;
    align-items: center;
    max-width: 850px;
}

/* Ajustar el campo de búsqueda */
flx-module[modulename="pers_prepedido_linea_tlv2_list"] flx-filter.active .search {
    width: 100%;
}

flx-module[modulename="pers_prepedido_linea_tlv2_list"] flx-filter.active .search input {
    width: 100%;
}

/* Ajustar la botonera para que esté alineada a la derecha */
.cntBodyHeader .moduleToolbar {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: nowrap; /* Evita que los botones se vayan a otra línea */
}

/* Asegurar que el flx-module tenga posición relativa */
flx-module[modulename="pers_prepedido_linea_tlv2_list"] {
    position: relative;
}
/* Ajustar el contenedor del buscador para que esté alineado a la izquierda */
flx-module[modulename="pers_prepedido_linea_tlv2_list"] .filterPanel {
    flex-grow: 1;
    max-width: 800px;
    display: flex;
    align-items: center;
}

/* Ajustar el campo de búsqueda */
flx-module[modulename="pers_prepedido_linea_tlv2_list"] .filterPanel .search {
    width: 100%;
}

flx-module[modulename="pers_prepedido_linea_tlv2_list"] .filterPanel .search input {
    width: 100%;
}

/* Ajustar la botonera para que esté alineada a la derecha */
.cntBodyHeader .moduleToolbar {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: nowrap;
    order: 1; /* Asegura que la botonera vaya antes de los botones de búsqueda */
}

/* Mover los botones de búsqueda y limpieza al final */
.cntBodyHeader .filterButtons {
    display: flex;
    align-items: center;
    gap: 8px;
    order: 2; /* Hace que estos botones sean los últimos */
}
/* ----------------------------- */
/* 🔹 Estilos para el módulo flotante de unidad */
/* ----------------------------- */
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

.input-display {
    width: 100%;
    height: 50px;
    font-size: 22px;
    text-align: center;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 5px;
    color: black !important;
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

/* ----------------------------- */
/* 🔹 Estilos específicos para `keyboard-unit` */
/* ----------------------------- */
#keyboard-unit {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 90%;
    max-width: 350px;
    background: white;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    z-index: 1001;
}

#keyboard-unit label {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 10px;
    display: block;
    color: black;
}

#keyboard-unit select {
    width: 100%;
    padding: 10px;
    font-size: 18px;
    border: 1px solid #ccc;
    border-radius: 5px;
    margin-bottom: 15px;
}

/* Botón cerrar */
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

/* Botón de confirmación */
.key.special {
    background: #007bff;
    color: white;
    padding: 10px 20px;
    font-size: 18px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    display: block;
    margin: 10px auto 0;
}

.key.special:hover {
    background: #0056b3;
}

@keyframes pulso {
    0%   { transform: scale(1);    opacity: 1;    }
    50%  { transform: scale(1.05); opacity: 0.85; }
    100% { transform: scale(1);    opacity: 1;    }
    }
.boton-atras {
    position: fixed;
    top: 100px;
    left: 10%;
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #6e8efb, #a777e3);
    border-radius: 50%;
    box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 9999;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    
    }
.boton-atras:hover {
    transform: scale(1.1);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
.boton-atras:active {
    transform: scale(0.95);
    }
.boton-atras i {
    color: white;
    font-size: 24px;
    }
@keyframes flotar {
    0% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
    100% { transform: translateY(0); }
    }
@media (max-width: 600px) {
    .boton-atras {
        width: 50px;
        height: 50px;
        left: 20px; /* Ajustamos para pantallas pequeñas */
        top: 100px;
        }
    .boton-atras i {
        font-size: 20px;
        }
    }
</style>
<div class="boton-atras" onclick="window.history.back()">
    <i class="flx-icon icon-order-left"></i>
</div>
<table class="tabla-datos">
    <thead>
        <tr>
            <th>Lin</th>
            <th>CodArt.</th>
            <th>Article</th>
            <th>Quantitat</th>
            <th>T.Unitat</th>
            <th>Pres</th>
            <th>Total</th>
            <th style=" text-align: right !important;">Preu</th>
            <th></th>
            <th style=" text-align: right !important;">Preu Feina</th>
            <th></th>
            <th style=" text-align: right !important;">PreuTot</th>
            <th>TObs.</th>
            <th>Observacions</th>
            <th>Ult.Preu</th>
            <th>Ult.Venta</th>
            <th>Vendes</th>
            <th>Stock</th>
        </tr>
    </thead>
    <tbody>