begin tran;
insert into Clientes_Datos(IdCliente, Cliente, RazonSocial,IdTipo ) values ('X0001', 'prova 1', 'prova 1', -1), ('X0002', 'prova 2', 'prova 2', -1);
select * from Pers_MiTabla
rollback tran;