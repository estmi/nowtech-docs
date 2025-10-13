# Instalar aplicacio FlexyGO a entorn de Produccio

## Obtenir instalador de FlexyGO

Aquest el podem obtenir de la web oficial de flexyGO o sino ja el tenim al servidor `0.4`.

## Restaurar BD

Necessitarem tenir les BD de FlexyGO restaurades al servidor de BDD de produccio.

## Crear un Site

Anirem a la carpeta dels Sites de IIS i farem una nova carpeta, despres entrarem desde l'Administrador de IIS i afegirem la carpeta com a Site.

:::info
C:\inetpub\wwwroot
:::

### Com crear un Site

Dinte de l'administrador de IIS, Farem clic dret a la opcio del menu `Sites` i farem clic a `Add Website...`(`Agregar sitio web...`).

![context_menu_site]

Aqui assignarem un nom i una ruta, tambe haurem d'assignar desde quina IP volem accedir i desde quin port, es important posar-ne un de lliure, sino no arrancara.

![add_website_wizard]

## Instalar FlexyGO sobre les 2 BDD restaurades i contra el nou Site

Ara farem una instalacio completa de forma estandar sobre les 2 bases de dades restaurades. Al especificar la BD `_IC`, de configuracio, detectara quin producte i versio ha d'instalar, solicitant-nos acceptar descarregar la versio correcte:

![flexygo_installer_version_check]

I en la seguent pantalla escolliriem el Site on instalar-ho:

![flexygo_installer_site_selector]

Un cop fet aixo ens apareixera si volem o no instalar els `Crystal Runtimes`, no cal instalar, ja que ja haurien de esta instalats, i despres ens plantejara la ip per accedir.
