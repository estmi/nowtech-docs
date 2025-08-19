# Publicar paquet NuGet

Per publicar un packet NuGet al servidor de Nowtech s'ha de fer el seguent:

A l'arxiu de `NuGet.config` ubicat a `AppData/Roaming/NuGet` dins la clau `packageSources` afegirem la seguent clau, que ens permetra accedir per nom al servidor, nom `dev-nowtech` i tambe ens permetra evitar la validacio https:

```xml
<add key="dev-nowtech" value="https://192.168.0.223/nuget" allowInsecureConnections="true" disableTLSCertificateValidation="true"/>
```

## Publicar un package

Per publicar un package necessitarem un arxiu nupkg el servidor desti i el token d'acces. Un cop tinguem aixo usarem la seguent comanda:

```batch
nuget push {{nupkg}} {{Token}} -Source {{httpUrl}}
rem exemple
nuget.exe push NowtechDistribucio.0.0.0.1.nupkg aaaaaa -Source dev-nowtech 
```

## Guardar un Token

Podem guardar un token per no haver de enrecordar-nos cada cop, per fer aixo utilitzarem la seguent comanda:

```batch
nuget setApiKey xxxxxxx -Source dev-nowtech
```
