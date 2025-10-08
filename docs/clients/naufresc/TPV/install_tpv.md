# Instalacio de punt de venda Prigest

Per imprimir els tiquets hi ha varies configuracions, un cop tenim triada 1, entre elles nomes varia font i format, podem anar al Punt de Venda i anar a la opcio de `Format dels impresos`:

![PuntVenda_FormatImpresos]

Haurem de triar el format amb codi `TIQUET` i alla configurarem el marge final, perque no quedi tallat el text per sota i tambe el Marge Inicial que ho haurem de fer per BD.

> Accedirem a la taula `formatimpressos` i buscarem el registre amb codi `TIQUET`:
>
> ```sql
> select * from formatimpressos
> WHERE FOIM_FORMATIMPRES = 'TIQUET'
> ```
>
> Alla buscarem la linia amb FOIM_CANAL = `PuntdeVenda` amb un `1` al final i canviarem la columna `FOIM_RETORNSFINESTRA`.

[PuntVenda_FormatImpresos]: /clients/naufresc/TPV/PuntVenda_FormatImpresos.png
