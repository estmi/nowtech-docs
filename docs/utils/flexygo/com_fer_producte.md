# Com crear un VisualStudio Project per producte

1. Instalar [FlexyGO Template][FlexyGO_Template_VS2022] per Visual Studio.
2. Crear un projecte de VS2022 amb la plantilla `Flexygo Complete Solution` que un cop creada compilarem tota la solucio.
3. Publicarem les 2 BD, per fer aixo anirem al projecte `ProducteBD`, farem clic dret i `Publicar`. Escollirem la conexio de la maquina i quin nom li especificarem, `Producte_IC`. Tambe farem el mateix la la `Producte_DataBD`.
4. Anirem al Web.config del projecte principal Web i modificarem les 2 cadenes de connexio, posarem el host, la BD, la de Conf es la `_IC` i tambe la PWD.
5. Ara arrancarem el projecte, si ens diu alguna cosa sobre modificar l'arxiu `web.config`, endavant.

[FlexyGO_Template_VS2022]: https://marketplace.visualstudio.com/items?itemName=Flexygo.FlexygoTemplate
