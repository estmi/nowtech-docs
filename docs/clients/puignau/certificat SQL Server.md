# Certificat SQL Server

## Problema

Degut a que els nous clients SQL Server utilitzen un parametre que es diu Encrypt, fa que es requereixi activar sempre una opcio que es diu `TrustServerCertificate`.

## Solucio

### Crear certificat

Degut d'aixo s'ha optat per fer un certificat autofirmat per el Servidor `192.168.0.4` amb la comanda powershell:

```powershell
New-SelfSignedCertificate `
  -CertStoreLocation "cert:\LocalMachine\My" `
  -Subject "CN=192.168.0.4" `
  -FriendlyName "Certificat SQL Server" `
  -KeySpec KeyExchange `
  -KeyExportPolicy Exportable `
  -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1") `
  -NotAfter (Get-Date).AddYears(5)
```

### Aplicar permisos al certificat

Un cop amb el certificat, hem entrat al gestort de certificats, l'hem buscat dintre dels certificats de l'equip local i a la carpeta `personal` -> `Certificats`, n'hi ha un que es diu `Certificat SQL Server`. Ara li farem clic dret -> `Todas las tareas` -> `Administrar claus privades`. Aqui li donarem a afegir, i buscarem l'usuari que utilitza l'SQL Server, normalment amagat (`MSSQL$`...).

### Aplicar certificat a SQL Server

Ara entrarem a la consola de configuracio de SQL Server i buscarem el protocol per la nostra instancia, un cop alla farem clic dret a la opcio i propiedades.
Veurem que hi ha una pestanya de certificat, en entrar trobarem un desplegable el qual trobarem el nostre certificat nou alla. Un cop marcat, ens avisara que hem de reiniciar el servei. Si tot es correcte el servei es reiniciara correctament.

## Problemes en reiniciar

En cas de no arrencar podria ser que l'usuari que arranca l'SQL Server no sigui el que hem donat permisos i li faltin permisos per utilitzar el certificat.
