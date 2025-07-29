# 3803 - Crear procediment per duplicar un client

## Explicacio

Per duplicar un client, utilitzarem l'`Stored Procedure` anomenat `pPers_DuplicarClient`.

Aquest `Stored Procedure` utilitza 3 parametres:

- `@Client_Orig`:`T_ID_Cliente`
- `@Client_Desti`:`T_ID_Cliente`
- `@IdClientNuevoPadre`:`T_ID_Cliente` (opcional, default de null)

## Funcionament

Per duplicar un client necessitarem saber 3 coses, és una planta o un client normal, quin client ens volem basar i quin serà el número de client destí.

### Client Normal

En cas de ser un client normal, cridarem el mètode de forma normal donant-li només els 2 primers paràmetres que li indicaran quin client copiar i on “enganxar-lo”.

```sql
exec pPers_DuplicarClient '5535', '95535'
```

Aquesta opció ens donarà com a resultat que el client `5535` té un clon que és el `95535`.

### Planta

En el cas de ser una planta, necessitarem saber si el pare ha de ser un de nou o és el mateix. En cas de ser un de nou, cridarem el mètode un primer cop pel pare i li donarem el nou pare en el 3r paràmetre de la segona crida. En cas de duplicar una planta pel mateix pare, no cal passar el 3r paràmetre.

```sql
exec pPers_DuplicarClient '88004', '89004'
exec pPers_DuplicarClient '1444', '91444', '89004'
```

Aquesta opció, el seu resultat seria, el clon del client `88004` -> `89004` i també el clon del client `1444` -> `91444` amb el nou pare creat justament abans.

## Funcionament intern

Internament, s'executen 5 `Stored Procedures` més els quals cadascú s'encarrega d'una part de la clonació del client.

1. [`pPers_DuplicarClient_pClientes_DatosI`]: Copia el client i assigna el nou pare en cas d'assignar-lo al 3r paràmetre.
2. [`pPers_DuplicarClient_InsertarDomiciliaciones`]: Copiem les domiciliacions del client antic al nou.
3. [`pPers_DuplicarClient_PClientes_Datos_Comerciales_U`]: Actualitzem les dades comercials.
4. [`pPers_DuplicarClient_PClientes_Datos_Economicos_U`]: Actualitzem les dades econòmiques.
5. [`pPers_DuplicarClient_CopiaConfigurables`]: Actualitzem les dades configurables.

### pPers_DuplicarClient

<SqlViewer title="pPers_DuplicarClient" file="puignau/3803/pPers_DuplicarClient.sql"/>

### pPers_DuplicarClient_pClientes_DatosI

<SqlViewer title="pPers_DuplicarClient_pClientes_DatosI" file="puignau/3803/pPers_DuplicarClient_pClientes_DatosI.sql"/>

### pPers_DuplicarClient_InsertarDomiciliaciones

<SqlViewer title="pPers_DuplicarClient_InsertarDomiciliaciones" file="puignau/3803/pPers_DuplicarClient_InsertarDomiciliaciones.sql"/>

### pPers_DuplicarClient_PClientes_Datos_Comerciales_U

<SqlViewer title="pPers_DuplicarClient_PClientes_Datos_Comerciales_U" file="puignau/3803/pPers_DuplicarClient_PClientes_Datos_Comerciales_U.sql"/>

### pPers_DuplicarClient_PClientes_Datos_Economicos_U

<SqlViewer title="pPers_DuplicarClient_PClientes_Datos_Economicos_U" file="puignau/3803/pPers_DuplicarClient_PClientes_Datos_Economicos_U.sql"/>

### pPers_DuplicarClient_CopiaConfigurables

<SqlViewer title="pPers_DuplicarClient_CopiaConfigurables" file="puignau/3803/pPers_DuplicarClient_CopiaConfigurables.sql"/>

[`pPers_DuplicarClient_pClientes_DatosI`]: #ppers_duplicarclient_pclientes_datosi
[`pPers_DuplicarClient_InsertarDomiciliaciones`]: #ppers_duplicarclient_insertardomiciliaciones
[`pPers_DuplicarClient_PClientes_Datos_Comerciales_U`]: #ppers_duplicarclient_pclientes_datos_comerciales_u
[`pPers_DuplicarClient_PClientes_Datos_Economicos_U`]: #ppers_duplicarclient_pclientes_datos_economicos_u
[`pPers_DuplicarClient_CopiaConfigurables`]: #ppers_duplicarclient_copiaconfigurables