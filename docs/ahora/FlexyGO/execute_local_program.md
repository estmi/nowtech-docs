# Executar Programa Delphi o altres locals desde FlexyGO

Exemple basat en GestioComercialClients de Puignau, ubicat a la `F:/Puignau/Comandes`.

## Crear BAT

Primer de tot ubicarem l'executable a cridar i el cridarem desde un arxiu .bat:

```batch
@echo off
cd /d F:\Puignau\Comandes
ECHO Executant GestioComercialClients.exe
start F:\Puignau\Comandes\GestioComercialClients.exe
```

[^1]

## Crear Protocol

Ara crearem un protocol al Registre de Windows, en el nostre cas el protocol es el seguent `gestio-comercial`:

```ini
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\gestio-comercial]
@="URL:Gestio Comercial Puignau Protocol"
"URL Protocol"=""

[HKEY_CLASSES_ROOT\gestio-comercial\shell]

[HKEY_CLASSES_ROOT\gestio-comercial\shell\open]

[HKEY_CLASSES_ROOT\gestio-comercial\shell\open\command]
@="\"F:\\aplicacions\\Puignau\\Comandes\\GestioComercialClients.bat\" \"%1\""
```

Un cop creat el `.reg` l'executarem per afegir-lo al registre.

## Crear Proces FlexyGO

Crearem un proces de FlexyGO per poder cridar la url del protocol, `gestio-comercial://`:

![flx_javascript_process]

```js
flexygo.nav.openURL('gestio-comercial://','','popup1024x678').close()
```

[^2]

## Utilitzar Proces

Ara ja podem cridar el proces, ja sigui a traves d'un execprocess o a traves d'una opcio de menu:

![flx_menu_option]

## Video Explicatiu

<video controls src="/ahora/FlexyGO/execute_local_program/Accedir_a_programa_Delphi_desde_FlexyGO.mp4" title="" style={{width:100 + '%'}}></video>

[flx_javascript_process]: /ahora/FlexyGO/execute_local_program/image.png
[flx_menu_option]: /ahora/FlexyGO/execute_local_program/image-1.png
[^1]: Utilitzar `start` ja que sino quedara sempre la consola negra oberta mentre el programa desti estigui obert.
[^2]: Aquest codi simplement crida la url amb el protocol designat i tanca la finestra ja que queda sino oberta una finestra dummy ue no aporta.
