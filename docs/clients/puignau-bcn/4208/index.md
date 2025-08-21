# 4208 - Projecte Traspàs Pendent Arribar Girona - Barcelona

## Vista reserves PA

S'afegeixen els camps `k.IdEmpresa IdEmpresaLlotja` i `p.IdEmpresa IdEmpresaPrepedido` per poder saber on som i d'on ve l'article de PA. S'afegeix tambe que la columna de color de l'article te el color de l'empresa propietaria.

<SqlViewer file="puignau-bcn/4208/vPers_Gestio_Articles_Reserva_PrePedidoAvui_Empresa.sql"/>

## Vista de linies de detall de les reserves

S'afegeix en el filtre que enc as de ser PA tambe miri els de l'empresa 0 (Puignau Girona).

<SqlViewer file="puignau-bcn/4208/vPers_Gestio_Articles_Reserva_Detall_PrePedidoAvui_Empresa.sql"/>

## Proces de reserva

<SqlViewer file="puignau-bcn/4208/pPers_Gestio_Articles_Reserva_IU.sql"/>

### Detall afectat

<SqlViewer file="puignau-bcn/4208/pPers_Gestio_Articles_Reserva_IU.detail.sql" title="Detall Reserva PA"/>

### pPers_Gestio_Articles_Reserva_IU (Proces Flexy)

Afegir parametre `IdEmpresaLlotja`. Ocultar i posar default `{{IdEmpresaLlotja}}`.

![param_definition_IdEmpresaLlotja]

## BD PuignauBCN Afegir camp IdLlotjaGirona i IdComandaRel

Aquests dos camps ens permetran saber si hi ha una comanda a eliminar i si prove d'una llotja relacionada.

![fields_to_add]

## Informe

<SqlViewer file="puignau-bcn/4208/fpers_reserves_producte_pa_pugi_per_puba.sql" title="Informe PA de PUGI -=> PUBA"/>

[param_definition_IdEmpresaLlotja]: /nowtech-docs/clients/puignau-bcn/4208/param_definition_IdEmpresaLlotja.png

[fields_to_add]: /nowtech-docs/clients/puignau-bcn/4208/fields_to_add.png
