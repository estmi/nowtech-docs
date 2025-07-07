# PBI Botigues

## Ametller

Cada dia a les 00:05 s'executa el flow `02 - Automate ametlller` en el cloud de PowerAutomate. Aquest llença en el servidor `0.15` usuari `adm.esteve` l'execucio del flow local `Ametller WEBv4` el qual s'encarrega de obrir una instancia de Chrome i parametritzar la pantalla per poder descarregar els arxius a la carpeta corresponent.

Perque es guadrin a la carpeta de Sharepoint, s'utilitza la configuracio de Chrome per guardar els arxius sense preguntar i directament a la carpeta que toca.

## Valvi

Es reben via mail els Excels a importar.

En rebre un arxiu a la carpeta del sharepoint de valvi, s'execvuta el flow cloud `11 - [sharepoint] Al crear fitxer de recaudació actualitzar DataFlow Botigues` que refresca les dades i elimina els excels.
