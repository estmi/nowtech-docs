# FlexyGO

## Access ContextVars

```js
> flexygo.context.currentReference
<- '0'
```

## FlexyGO Properties settings

### Persist Default Value

Permet fer que cada cop que guardes s'apliqui de nou el `Default Value`.

### Custom Control

Si utilitzem `Custom Controls`, despres podem acabar de personalitzar algunes coses per ajustar el control.

## Delete filter

Per eliminar un filtre has d'anar a la coleccio, vista llista, i fer embut i `Settings`. Alla, veurem el mateix menu que en el wizard de l'objecte, pero amb un buto que diu `Delete`.

## Switch statement in html

```html
<span class="{{type_id|switch:[0:txt-warning,1:txt-outstanding,2:txt-tools,else:txt-primary]}}" >
    <i class="flx-icon {{type_id|switch:[0:icon-focus-6,1:icon-user4,2:icon-providers,else:icon-clients1]}} icon-margin-right"></i>
    {{descrip}}
</span>
```

## Relacions entre objectes

Si fem les relacions a flexy corresponents, podem despres entrar al llistat per defecte i afegir les columnes dels objectes relacionats.
