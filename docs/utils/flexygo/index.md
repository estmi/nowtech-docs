# FlexyGO Utils

## Decrypt FlexyGO ConnectionStrings

```batch
cd C:\Windows\Microsoft.NET\Framework\v4.0.30319
./aspnet_regiis.exe -pdf "connectionStrings" C:\inetpub\wwwroot\PuignauCRMTest
```

## Switch statement in html

```html
<span class="{{type_id|switch:[0:txt-warning,1:txt-outstanding,2:txt-tools,else:txt-primary]}}" >
    <i class="flx-icon {{type_id|switch:[0:icon-focus-6,1:icon-user4,2:icon-providers,else:icon-clients1]}} icon-margin-right"></i>
    {{descrip}}
</span>
```

## Access ContextVars

```js
> flexygo.context.currentReference
<- '0'
```

## Preguntar a l'usuari abans de fer una accio

```JavaScript
flexygo.msg.confirm('¿Estás seguro?').then((result) => {
    if (result) {
        flexygo.msg.alert('Confirmado');
    } else {
        flexygo.msg.alert('Cancelado');
    }
});
```

## Enable development mode

```js
flexygo.debug.enableDevelopMode(1,0)
```
