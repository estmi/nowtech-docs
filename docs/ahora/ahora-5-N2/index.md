# Ahora tecnico 2

## Tipos personalizados

Utilitzar tipos personalitzats, per poder normalitzar la BD i en cas de canvis de tipus ser canvis automatics.

Programmability -> Types -> User-Defined Data Types:

- `T_Id_Cliente` = `varchar(15)`
- `T_Fecha_Corta` = `(smalldatetime, not null)`

## Integritat referencial

Utilizar relacions amb claus foranies.

- On delete `Set Null` i `Cascade`

## Prefixe pers

util per buscar totes les modificacions aplicades fora de fabrica.

## Generar taula SQL

Al generar una taula SQL s'ha de donar permisos sobre ella.

```sql
zpermisos pers_MiTabla
```

## Manteniments

Mini forms per gestionar taules:

![crear_script]

:::note
Per veure l'script t'has de moure de l'estrella als 3 punts i tornar a l'estrella.
:::

```C#
// Taula, Nom, Modal
gCn.AhoraProceso("DameMantenimiento", out _, gCn, "Pers_MiTabla", "Pers Mi Tabla", false);
```

![defs_pers_mitabla]

Per poder utilitzar manteniments dins Ahora, s'ha de crear una columna IdDoc, tipus `T_Id_Doc`.

## Taules

### VS 2022 Comparador de BD per generar personalitzacions

### Taula `Ahora_Session`

Usuaris logejats.

Hi ha varis storeds que es basen en aquesta taula per poder gestionar la empresa i delegacio on esta conectada l'usuari.

### Taula `Ahora_Licencias`

1 registre amb la llicencia. Si es mou BD de SQL Server, la llicencia caduca.

:::note Llicencia temp
Al instalar una BD nova, en entrar a Ahora Express, hem d'anar a empresa i assignar un NIF el qual ens dona una llicencia de 30 dies.
:::

## Triggers

Les taules tenen uns triggers que contenen validacions de les dades.

Nomenclatura:

- `_ITrig`: Trigger de insert.
- `_UTrig`: Trigger de update.
- `_DTrig`: Trigger de delete.

:::info ITrig Clientes_Datos_ITrig
Valida dades i per exemple genera contactes
:::

### Crear custom trigger per afegir automaticament registre a mitabla

#### ITrig

Dins de trigger, taula inserted i taula deleted.

- Inserted: obtenim registres ja insertats.
- Deleted: Obtenim registres ja eliminats.

#### UTrig

- Inserted: obtenim registres actualitzats.
- Deleted: Obtenim registres abans d'actualitzar.

#### DTrig

Dins de trigger, taula inserted i taula deleted.

- Inserted: obtenim registres ja insertats.
- Deleted: Obtenim registres ja eliminats.

### Validacio de que hi ha registres afectats

Amb el seguent IF validem que hi ha registres afectats per l'insert.

```sql
IF @@ROWCOUNT<>0 BEGIN
```

### sp_settriggerorder

Per ordenar els triggers d'una taula

```sql
sp_settriggerorder
```

## Seguimientos

Habilitar-los:

![enable_seguimientos]

### Crear dashboard

![send_seguimientos_filter_to_dashboard]

## Custom filters (Buscadors)

![create_searcher]

![searcher_created]

Enviar a usuari:

![send_to_user]

![select_user_to_send]

Pasar a predeterminat:

![share_searcher]

## Taula `Scripts`

Conte els scripts generats