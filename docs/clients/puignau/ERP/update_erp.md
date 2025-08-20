# Update ERP

## Disable User access to servers

### Bloquejar servidor TSs

Expulsar els usuaris primer.

- 11: entrar desde vcsa i eliminar xarxa
- 13: entrar desde vcsa i eliminar xarxa
- 16: posar tot el broker i granja en manteniment
- 17: posar tot el broker i granja en manteniment
- 18: posar tot el broker i granja en manteniment

### Parar servei de IIS

### Parar Gateway PowerBI

### Parar Docuware Local Data Connector

### Parar Task Scheduler

## Disable SQL Server Access

### Get query to disable and reenable logins

<SqlViewer file="puignau\ERP\update_erp\get_enable_disable_users.sql"/>

### Disable logins

<SqlViewer file="puignau\ERP\update_erp\disable_users.sql"/>

### Kill Sessions

<SqlViewer file="puignau\ERP\update_erp\kill_sessions.sql"/>

## UPDATE

Update Stuff...

## Reacticar tot

## Enable logins on SQL Server

<SqlViewer file="puignau\ERP\update_erp\enable_users.sql"/>

## Reactivar serveis

Serveis parats:

- IIS
- Docuware Local Data Connector
- PowerBI Gateway
- Task Scheduler