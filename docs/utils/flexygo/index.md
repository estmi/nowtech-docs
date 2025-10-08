# FlexyGO Utils

## Decrypt FlexyGO ConnectionStrings

```batch
cd C:\Windows\Microsoft.NET\Framework\v4.0.30319
./aspnet_regiis.exe -pdf "connectionStrings" C:\inetpub\wwwroot\PuignauCRMTest
```

## Switch statement in html

<SqlViewer baseUrl="/" file="utils/flexygo/switch_statement.html" title="Switch Statement"/>

## Access ContextVars

```js
> flexygo.context.currentReference
<- '0'
```

## Preguntar a l'usuari abans de fer una accio

<SqlViewer baseUrl="/" file="utils/flexygo/ask_user_yes_no.js" title="Ask user yes or no"/>

## Enable development mode

```js
flexygo.debug.enableDevelopMode(1,0)
```
