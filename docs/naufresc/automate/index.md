# Power Automate PBI Vendes Ametller

La recuperacio de les vendes d'Ametller Origen, te varies parts. Aquestes parts son les seguents:

- [Sharepoint](#sharepoint): On resideix el csv d'importacio de dades.
- [PowerAutomate Desktop](#power-automate-desktop): Encarregat de descarregar les dades de Ametller a un csv i deixar-lo al Sharepoint
- [PowerAutomate Cloud](#power-automate-cloud): Prepara la carpeta del sharepoint i envia una senyal al PADesktop per executar els flows locals.

## Sharepoint

En el sharepoint propietat de l'usuari `adminBI@peixospuignau.net`[^pwd] al site `Business Intelligence` a la ruta `Business Intelligence\Botigues\Recaudació Ametller` hi haura allotjar un csv resultat de tot el fluxe.

## Power Automate Desktop

Crida un navegador de chrome on obre la web [LookerStudio de Ametller](https://lookerstudio.google.com/reporting/1wFBG0DiRJ2XRU5y4Ydl5R3IKNLAoZ3Ru/page/ROS2), configura certs parametres de dates i despres degut de que treballa amb una resolucio de 1024x768 no es veu la graella que necessitem exportar i s'ha de fer scroll down per veure-la i tambe fer scroll right per veure el boto d'exportar.

## Power Automate Cloud

Aquest automate es un dummy que crida el desktop i en cas de fallar ho reintenta 2 cops mes fins que al final envia un missatge d'error.

Tambe neteja la carpeta de Sharepoint.

[^pwd]: Contrassenya al KeePass
