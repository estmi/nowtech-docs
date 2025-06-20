# 08. DevExpress Reporting

## Stating

### Crear Report

`Archivo` -> `Nuevo informe usando el asistente...`

Seleccionarem la opcio mes indicada.

![alt text](image.png)

### Crear connection string

`Explorador de informes` -> `Data Sources` -> `DataConnectionString` -> `Configurar connexion` (click dret)

![alt text](image-1.png)

Un cop dins seleccionarem que volem fer una connection string manualment:

![alt text](image-2.png)

I despres escollim una `Custom connection string`:

![alt text](image-3.png)

```plaintext
xpoprovider=MSSqlServer;server={{SQL Server Instance}};database={{Database Name}};trustservercertificate=True;User={{SQL Server User}};Password={{Password}}
```

## Crear query


