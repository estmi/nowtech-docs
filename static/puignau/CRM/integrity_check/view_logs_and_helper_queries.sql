select * from per_log_esteve order by id

/*
delete from per_log_esteve where obj = 'IntegrityCheck_OK @IdPrePedido' or msg = 'Tot OK'
delete from per_log_esteve where fecha < '20250620'
truncate table per_log_esteve
*/
select * from Pers_PrePedido_Lineas where iddoc in ()
select * from Pers_PrePedido_Lineas where idprepedido in () order by IdPrePedido, IdPrePedidoLinea
select * from Pers_PrePedido where idprepedido in () order by IdPrePedido
SELECT COUNT(*) FROM Pers_PrePedido_Lineas where IdPedido is null and IdPrePedido = 45766
select * from Empleados_Datos where IdEmpleado = 1013