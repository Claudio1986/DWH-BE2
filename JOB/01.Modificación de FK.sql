use dwh
go

ALTER TABLE bancaempresas.dbo.gc_clientes ALTER COLUMN tipo_cliente int NOT NULL

IF (OBJECT_ID('FK_asignacion_clientes_clientes', 'F') IS NOT NULL)
BEGIN
	alter table asignacion_clientes drop constraint FK_asignacion_clientes_clientes;
END
alter table asignacion_clientes add constraint FK_asignacion_clientes_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

------------------------------------------------------------------
IF (OBJECT_ID('FK_clientes_excluidos_vis_clientes', 'F') IS NOT NULL)
BEGIN
alter table clientes_excluidos_vis drop	constraint FK_clientes_excluidos_vis_clientes;
END
alter table clientes_excluidos_vis add constraint FK_clientes_excluidos_vis_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

------------------------------------------------------------------
IF (OBJECT_ID('FK_clientes_fugados_clientes', 'F') IS NOT NULL)
BEGIN
alter table clientes_fugados drop	constraint FK_clientes_fugados_clientes;
END
alter table clientes_fugados add constraint FK_clientes_fugados_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

------------------------------------------------------------------
IF (OBJECT_ID('FK_cre_estructurados_clientes', 'F') IS NOT NULL)
BEGIN
alter table cre_estructurados drop	constraint FK_cre_estructurados_clientes;
END
alter table cre_estructurados add constraint FK_cre_estructurados_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

------------------------------------------------------------------
IF (OBJECT_ID('FK_credito_cart_clientes', 'F') IS NOT NULL)
BEGIN
alter table credito_cart drop	constraint FK_credito_cart_clientes;
END
alter table credito_cart add constraint FK_credito_cart_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

------------------------------------------------------------------
IF (OBJECT_ID('FK_credito_cart_detalle_clientes', 'F') IS NOT NULL)
BEGIN
alter table credito_cart_detalle drop	constraint FK_credito_cart_detalle_clientes;
END
alter table credito_cart_detalle add constraint FK_credito_cart_detalle_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

------------------------------------------------------------------
IF (OBJECT_ID('FK_dap_clientes', 'F') IS NOT NULL)
BEGIN
alter table dap drop	constraint FK_dap_clientes;
END
alter table dap add constraint FK_dap_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

------------------------------------------------------------------
IF (OBJECT_ID('FK_normalizaciones_clientes', 'F') IS NOT NULL)
BEGIN
alter table normalizaciones drop	constraint FK_normalizaciones_clientes;
END
alter table normalizaciones add constraint FK_normalizaciones_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

---------------------------------------------------------------
IF (OBJECT_ID('FK_spotfwd_clientes', 'F') IS NOT NULL)
BEGIN
alter table spotfwd drop	constraint FK_spotfwd_clientes;
END
alter table spotfwd add constraint FK_spotfwd_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

---------------------------------------------------------------
IF (OBJECT_ID('FK_visitas_clientes', 'F') IS NOT NULL)
BEGIN
alter table visitas drop	constraint FK_visitas_clientes;
END
alter table visitas add constraint FK_visitas_clientes foreign key (id_cliente) references clientes (id) on delete cascade;

---------------------------------------------------------------
IF (OBJECT_ID('FK_asignacion_clientes_ejecutivos', 'F') IS NOT NULL)
BEGIN
alter table asignacion_clientes drop constraint FK_asignacion_clientes_ejecutivos;
END
alter table asignacion_clientes add constraint FK_asignacion_clientes_ejecutivos foreign key (id_ejecutivo) references ejecutivos (id) on delete cascade;

---------------------------------------------------------------
IF (OBJECT_ID('FK_cre_estructurados_ejecutivos', 'F') IS NOT NULL)
BEGIN
alter table cre_estructurados drop constraint FK_cre_estructurados_ejecutivos;
END
alter table cre_estructurados add constraint FK_cre_estructurados_ejecutivos foreign key (id_ejecutivo) references ejecutivos (id) on delete cascade;

---------------------------------------------------------------
IF (OBJECT_ID('FK_jerarquia_ejecutivos_ejecutivos', 'F') IS NOT NULL)
BEGIN
alter table jerarquia_ejecutivos drop constraint FK_jerarquia_ejecutivos_ejecutivos;
END
alter table jerarquia_ejecutivos add constraint FK_jerarquia_ejecutivos_ejecutivos foreign key (id_ejecutivo) references ejecutivos (id) on delete cascade;
---------------------------------------------------------------
IF (OBJECT_ID('FK_jerarquia_ejecutivos_jefe', 'F') IS NOT NULL)
BEGIN
alter table jerarquia_ejecutivos drop constraint FK_jerarquia_ejecutivos_jefe;
END
alter table jerarquia_ejecutivos add constraint FK_jerarquia_ejecutivos_jefe foreign key (id_jefe) references ejecutivos (id) on delete NO ACTION;

---------------------------------------------------------------
IF (OBJECT_ID('FK_metas_ejecutivos_ejecutivos', 'F') IS NOT NULL)
BEGIN
alter table metas_ejecutivos drop constraint FK_metas_ejecutivos_ejecutivos;
END
alter table metas_ejecutivos add constraint FK_metas_ejecutivos_ejecutivos foreign key (id_ejecutivo) references ejecutivos (id) on delete cascade;

---------------------------------------------------------------
IF (OBJECT_ID('FK_visitas_ejecutivos', 'F') IS NOT NULL)
BEGIN
alter table visitas drop constraint FK_visitas_ejecutivos;
END
alter table visitas add constraint FK_visitas_ejecutivos foreign key (id_ejecutivo) references ejecutivos (id) on delete cascade;

---------------------------------------------------------------
IF (OBJECT_ID('FK_ejecutivos_plataformas', 'F') IS NOT NULL)
BEGIN
alter table ejecutivos drop constraint FK_ejecutivos_plataformas;
END
alter table ejecutivos add constraint FK_ejecutivos_plataformas foreign key (id_plataforma) references plataformas (id) on delete cascade;





