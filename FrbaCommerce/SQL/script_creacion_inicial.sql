
-------------------------------------------------------------------------------------
---------------------------------CREANDO EL ESQUEMA----------------------------------
-------------------------------------------------------------------------------------
BEGIN TRANSACTION 

USE [GD1C2014]
GO

DECLARE @SchemaName AS VARCHAR(100) = 'DATA_GROUP'
DECLARE @sql VARCHAR(100) = 'CREATE SCHEMA '+ @SchemaName +' AUTHORIZATION [gd]'

IF NOT EXISTS(SELECT name FROM sys.schemas WHERE name = @SchemaName)
BEGIN
	PRINT 'Creating ' + @SchemaName + ' schema'
	EXEC(@sql)
	PRINT @SchemaName + ' schema created'
END
ELSE
  PRINT @SchemaName + ' schema already exists.'
-------------------------------------------------------------------------------------
---------------------------------CREANDO LAS TABLAS----------------------------------
-------------------------------------------------------------------------------------

IF OBJECT_ID('DATA_GROUP.FuncionalidadXRol', 'U') IS NOT NULL DROP TABLE DATA_GROUP.FuncionalidadXRol;
CREATE TABLE DATA_GROUP.FuncionalidadXRol (
	id_rol NUMERIC(18,0) NOT NULL,
	id_funcionalidad NUMERIC(18,0) NOT NULL,
	habilitada bit DEFAULT 1 NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.UsuarioXRol', 'U') IS NOT NULL	DROP TABLE DATA_GROUP.UsuarioXRol;
CREATE TABLE DATA_GROUP.UsuarioXRol (
	id_usuario NUMERIC(18,0) NOT NULL, 
	id_rol NUMERIC(18,0) NOT NULL,
	habilitada bit DEFAULT 1 NOT NULL,
);

--En el modelo de datos que nos dieron ustedes se supone que todas las compras ya fueron facturadas? O hay compras sin facturar?
IF OBJECT_ID('DATA_GROUP.Compra', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Compra;
CREATE TABLE DATA_GROUP.Compra (
	id_compra NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
	id_publicacion NUMERIC(18, 0) NOT NULL,
	id_usuario_comprador NUMERIC(18, 0) NOT NULL,
	id_calificacion NUMERIC(18, 0),
	fecha datetime NOT NULL,
	cantidad NUMERIC(18, 0) NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.Oferta', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Oferta;
CREATE TABLE DATA_GROUP.Oferta(
	id_oferta NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
	id_publicacion NUMERIC(18, 0) NOT NULL,
	id_usuario_ofertador NUMERIC(18, 0) NOT NULL,
	fecha datetime NOT NULL,
	monto NUMERIC(18, 2) NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.CalificacionPublicacion', 'U') IS NOT NULL DROP TABLE DATA_GROUP.CalificacionPublicacion;
CREATE TABLE DATA_GROUP.CalificacionPublicacion(
	id_calificacion NUMERIC(18, 0) NOT NULL,
	estrellas_calificacion NUMERIC(18, 0),
	detalle_calificacion nvarchar(255),
);

IF OBJECT_ID('DATA_GROUP.ItemFactura', 'U') IS NOT NULL DROP TABLE DATA_GROUP.ItemFactura;
CREATE TABLE DATA_GROUP.ItemFactura(
	nro_factura NUMERIC(18, 0) NOT NULL,
	id_publicacion NUMERIC(18, 0) NOT NULL,
	cantidad NUMERIC(18, 0) NOT NULL,
	monto NUMERIC(18, 2) NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.Factura', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Factura;
CREATE TABLE DATA_GROUP.Factura(
	nro_factura NUMERIC(18, 0) NOT NULL,
	id_vendedor NUMERIC(18, 0) NOT NULL,
	fecha datetime NOT NULL,
	total NUMERIC(18, 2) NOT NULL,
	forma_pago_descripcion nvarchar(255) NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.Pregunta', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Pregunta;
CREATE TABLE DATA_GROUP.Pregunta(
	id_pregunta NUMERIC(18,0) IDENTITY(1,1) NOT NULL,
	id_publicacion NUMERIC(18,0) NOT NULL,
	id_usuario NUMERIC(18, 0) NOT NULL,
	pregunta nvarchar(255),
	fecha_pregunta datetime,
	respuesta nvarchar(400),
	fecha_respuesta datetime,
);

IF OBJECT_ID('DATA_GROUP.Publicacion', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Publicacion;
CREATE TABLE DATA_GROUP.Publicacion(
	id_publicacion NUMERIC(18,0) NOT NULL,
	descripcion nvarchar(255),
	stock NUMERIC(18,0),
	fecha_inicio datetime,
	fecha_vencimiento datetime,
	precio NUMERIC(18,2),
	permite_preguntas bit DEFAULT 1 NOT NULL,
	id_tipo_publicacion NUMERIC(18,0) NOT NULL,
	id_visibilidad NUMERIC(18,0) NOT NULL, 
	id_estado NUMERIC(18,0) NOT NULL, 
	id_usuario_publicador NUMERIC(18,0) NOT NULL,
	id_rubro NUMERIC(18, 0),
	habilitada bit DEFAULT 1 NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.Rol', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Rol;
CREATE TABLE DATA_GROUP.Rol(
	id_rol NUMERIC(18,0) IDENTITY(1,1) NOT NULL, 
	nombre nvarchar(255) NOT NULL,
	habilitada bit DEFAULT 1 NOT NULL, 
);

IF OBJECT_ID('DATA_GROUP.Funcionalidad', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Funcionalidad;
CREATE TABLE DATA_GROUP.Funcionalidad (
	id_funcionalidad NUMERIC(18,0) IDENTITY(1,1) NOT NULL,
	nombre nvarchar(255) NOT NULL,
	habilitada bit DEFAULT 1 NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.Administrador', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Administrador;
CREATE TABLE DATA_GROUP.Administrador ( 
	id_administrador NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
	id_usuario NUMERIC(18,0) NOT NULL, 
	habilitada bit DEFAULT 1 NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.Cliente', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Cliente;
CREATE TABLE DATA_GROUP.Cliente (
	id_tipo_documento NUMERIC(18, 0) NOT NULL,
	nro_documento NUMERIC(18,0) NOT NULL,
	id_usuario NUMERIC(18,0),
	nombre nvarchar(255), 
	apellido nvarchar (255),
	dom_calle nvarchar(255),
	nro_calle NUMERIC(18, 0),
	piso NUMERIC(18,0),      
	depto nvarchar(50),      
	localidad nvarchar(255),
	cod_postal nvarchar(50),
	mail nvarchar(255),
	fecha_nacimiento datetime,
	sexo bit DEFAULT NULL,
	--habilitada bit DEFAULT 1,
);

IF OBJECT_ID('DATA_GROUP.Empresa', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Empresa;
CREATE TABLE DATA_GROUP.Empresa (
	cuit nvarchar(50) NOT NULL,
	razon_social nvarchar(255) NOT NULL, 
	id_usuario NUMERIC(18,0), 
	mail nvarchar(50),
	dom_calle nvarchar(255),
	piso NUMERIC(18,0) , 
	depto nvarchar(50),
	localidad nvarchar(255),
	nro_calle NUMERIC(18,0),
	cod_postal nvarchar(50),
	ciudad nvarchar(255),
	nombre_de_contacto nvarchar(255),
	fecha_creacion datetime,
);

IF OBJECT_ID('DATA_GROUP.Usuario', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Usuario;
CREATE TABLE DATA_GROUP.Usuario (
	id_usuario NUMERIC(18,0) IDENTITY(1,1) NOT NULL,
	username nvarchar(255),
	contrasenia nvarchar(255),
	telefono NUMERIC(18,0),
	intentos_login NUMERIC(1, 0) DEFAULT 0, 
	tipo_usuario nvarchar(3), 
	habilitada bit DEFAULT 1
);

IF OBJECT_ID('DATA_GROUP.TipoDocumento', 'U') IS NOT NULL DROP TABLE DATA_GROUP.TipoDocumento;
CREATE TABLE DATA_GROUP.TipoDocumento (
	id_tipo_documento NUMERIC(18, 0) IDENTITY (1,1) NOT NULL,
	descripcion nvarchar(255) NOT NULL,
)

IF OBJECT_ID('DATA_GROUP.Rubro', 'U') IS NOT NULL DROP TABLE DATA_GROUP.Rubro;
CREATE TABLE DATA_GROUP.Rubro(
	id_rubro NUMERIC(18,0) IDENTITY(1,1) NOT NULL, 
	descripcion nvarchar(255) NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.TipoPublicacion', 'U') IS NOT NULL DROP TABLE DATA_GROUP.TipoPublicacion;
CREATE TABLE DATA_GROUP.TipoPublicacion(
	id_tipo_publicacion NUMERIC(18,0) IDENTITY(1,1) NOT NULL, 
	descripcion nvarchar(255) NOT NULL,
);

IF OBJECT_ID('DATA_GROUP.VisibilidadPublicacion', 'U') IS NOT NULL DROP TABLE DATA_GROUP.VisibilidadPublicacion;
CREATE TABLE DATA_GROUP.VisibilidadPublicacion(
	id_visibilidad NUMERIC(18,0) NOT NULL,
	descripcion nvarchar(255) NOT NULL,
	precio NUMERIC(18, 2) NOT NULL,
	porcentaje NUMERIC(18, 2) NOT NULL,
	habilitada bit DEFAULT 1
);

IF OBJECT_ID('DATA_GROUP.EstadoPublicacion', 'U') IS NOT NULL DROP TABLE DATA_GROUP.EstadoPublicacion;
CREATE TABLE DATA_GROUP.EstadoPublicacion(
	id_estado NUMERIC(18,0) IDENTITY(1,1) NOT NULL, 
	descripcion nvarchar(255) NOT NULL,
);

-------------------------------------------------------------------------------------
----------------------------------CREANDO LAS PKS------------------------------------
-------------------------------------------------------------------------------------

ALTER TABLE DATA_GROUP.Rol ADD CONSTRAINT pk_id_rol PRIMARY KEY ( id_rol );
ALTER TABLE DATA_GROUP.Funcionalidad ADD CONSTRAINT pk_id_funcionalidad PRIMARY KEY ( id_funcionalidad );
ALTER TABLE DATA_GROUP.FuncionalidadXRol ADD CONSTRAINT pk_funcionalidad_rol PRIMARY KEY ( id_rol,id_funcionalidad  );
ALTER TABLE DATA_GROUP.Usuario ADD CONSTRAINT pk_id_usuario PRIMARY KEY ( id_usuario );
ALTER TABLE DATA_GROUP.Administrador ADD CONSTRAINT pk_id_administrador PRIMARY KEY ( id_usuario );
ALTER TABLE DATA_GROUP.Cliente ADD CONSTRAINT pk_id_cliente PRIMARY KEY ( id_tipo_documento, nro_documento );
ALTER TABLE DATA_GROUP.Empresa ADD CONSTRAINT pk_id_empresa PRIMARY KEY ( cuit, razon_social );
ALTER TABLE DATA_GROUP.UsuarioXRol ADD CONSTRAINT pk_usuario_rol PRIMARY KEY ( id_usuario,id_rol );
ALTER TABLE DATA_GROUP.Rubro ADD CONSTRAINT pk_id_rubro PRIMARY KEY ( id_rubro );
ALTER TABLE DATA_GROUP.TipoPublicacion ADD CONSTRAINT pk_id_tipo_publicacion PRIMARY KEY ( id_tipo_publicacion );
ALTER TABLE DATA_GROUP.VisibilidadPublicacion ADD CONSTRAINT pk_id_visibilidad PRIMARY KEY ( id_visibilidad );
ALTER TABLE DATA_GROUP.EstadoPublicacion ADD CONSTRAINT pk_id_estado PRIMARY KEY ( id_estado );
ALTER TABLE DATA_GROUP.Publicacion ADD CONSTRAINT pk_id_publicacion PRIMARY KEY ( id_publicacion );
ALTER TABLE DATA_GROUP.Pregunta ADD CONSTRAINT pk_id_pregunta PRIMARY KEY ( id_pregunta );
ALTER TABLE DATA_GROUP.Compra ADD CONSTRAINT pk_id_compra PRIMARY KEY (id_compra);
ALTER TABLE DATA_GROUP.Oferta ADD CONSTRAINT pk_id_oferta PRIMARY KEY (id_oferta);
ALTER TABLE DATA_GROUP.CalificacionPublicacion ADD CONSTRAINT pk_id_calificacion_publicacion PRIMARY KEY(id_calificacion);
ALTER TABLE DATA_GROUP.Factura ADD CONSTRAINT pk_nro_factura PRIMARY KEY (nro_factura);
--ALTER TABLE DATA_GROUP.ItemFactura ADD CONSTRAINT pk_item_factura PRIMARY KEY ( id_item );
ALTER TABLE DATA_GROUP.TipoDocumento ADD CONSTRAINT pk_tipo_documento PRIMARY KEY (id_tipo_documento);

-------------------------------------------------------------------------------------
----------------------------------CREANDO LAS FKS------------------------------------
-------------------------------------------------------------------------------------

--Roles, funcionalidades, usuarios
ALTER TABLE DATA_GROUP.FuncionalidadXRol ADD CONSTRAINT fk_FuncionalidadXRol_to_Funcionalidad
FOREIGN KEY (id_funcionalidad) REFERENCES DATA_GROUP.Funcionalidad (id_funcionalidad);

ALTER TABLE DATA_GROUP.FuncionalidadXRol ADD CONSTRAINT fk_FuncionalidadXRol_to_Rol
FOREIGN KEY (id_rol) REFERENCES DATA_GROUP.Rol (id_rol);

ALTER TABLE DATA_GROUP.Administrador ADD CONSTRAINT fk_Administrador_to_Usuario
FOREIGN KEY (id_usuario) REFERENCES DATA_GROUP.Usuario (id_usuario);

ALTER TABLE DATA_GROUP.Cliente ADD CONSTRAINT fk_Cliente_to_Usuario
FOREIGN KEY (id_usuario) REFERENCES DATA_GROUP.Usuario (id_usuario);

ALTER TABLE DATA_GROUP.Cliente ADD CONSTRAINT fk_Cliente_to_TipoDocumento
FOREIGN KEY (id_tipo_documento) REFERENCES DATA_GROUP.TipoDocumento(id_tipo_documento);

ALTER TABLE DATA_GROUP.Empresa ADD CONSTRAINT fk_Empresa_to_Usuario
FOREIGN KEY (id_usuario) REFERENCES DATA_GROUP.Usuario (id_usuario);

ALTER TABLE DATA_GROUP.UsuarioXRol ADD CONSTRAINT fk_UsuarioXRol_to_Usuario
FOREIGN KEY (id_usuario) REFERENCES DATA_GROUP.Usuario (id_usuario);

ALTER TABLE DATA_GROUP.UsuarioXRol ADD CONSTRAINT fk_UsuarioXRol_to_Rol
FOREIGN KEY (id_rol) REFERENCES DATA_GROUP.Rol (id_rol);

--Publicacion
ALTER TABLE DATA_GROUP.Publicacion ADD CONSTRAINT fk_Publicacion_to_TipoPublicacion
FOREIGN KEY (id_tipo_publicacion) REFERENCES DATA_GROUP.TipoPublicacion (id_tipo_publicacion);

ALTER TABLE DATA_GROUP.Publicacion ADD CONSTRAINT fk_Publicacion_to_EstadoPublicacion
FOREIGN KEY (id_estado) REFERENCES DATA_GROUP.EstadoPublicacion (id_estado);

ALTER TABLE DATA_GROUP.Publicacion ADD CONSTRAINT fk_Publicacion_to_VisibilidadPublicacion
FOREIGN KEY (id_visibilidad) REFERENCES DATA_GROUP.VisibilidadPublicacion (id_visibilidad);

ALTER TABLE DATA_GROUP.Publicacion ADD CONSTRAINT fk_Publicacion_to_Usuario
FOREIGN KEY (id_usuario_publicador) REFERENCES DATA_GROUP.Usuario (id_usuario);

ALTER TABLE DATA_GROUP.Publicacion ADD CONSTRAINT fk_Publicacion_to_Rubro
FOREIGN KEY (id_rubro) REFERENCES DATA_GROUP.Rubro (id_rubro);

--Preguntas
ALTER TABLE DATA_GROUP.Pregunta ADD CONSTRAINT fk_Pregunta_to_Publicacion
FOREIGN KEY (id_publicacion) REFERENCES DATA_GROUP.Publicacion (id_publicacion);

ALTER TABLE DATA_GROUP.Pregunta ADD CONSTRAINT fk_Pregunta_to_Usuario
FOREIGN KEY (id_usuario) REFERENCES DATA_GROUP.Usuario (id_usuario);

--Compra
ALTER TABLE DATA_GROUP.Compra ADD CONSTRAINT fk_Compra_to_Publicacion 
FOREIGN KEY (id_publicacion) REFERENCES DATA_GROUP.Publicacion (id_publicacion);

ALTER TABLE DATA_GROUP.Compra ADD CONSTRAINT fk_Compra_to_Usuario 
FOREIGN KEY (id_usuario_comprador) REFERENCES DATA_GROUP.Usuario (id_usuario);

ALTER TABLE DATA_GROUP.Compra ADD CONSTRAINT fk_Compra_to_CalificacionPublicacion 
FOREIGN KEY (id_calificacion) REFERENCES DATA_GROUP.CalificacionPublicacion (id_calificacion);

--Oferta
ALTER TABLE DATA_GROUP.Oferta ADD CONSTRAINT fk_Oferta_to_Publicacion 
FOREIGN KEY (id_publicacion) REFERENCES DATA_GROUP.Publicacion (id_publicacion);

ALTER TABLE DATA_GROUP.Oferta ADD CONSTRAINT fk_Oferta_to_Usuario 
FOREIGN KEY (id_usuario_ofertador) REFERENCES DATA_GROUP.Usuario (id_usuario);

--Facturas
ALTER TABLE DATA_GROUP.Factura ADD CONSTRAINT fk_Factura_to_Usuario 
FOREIGN KEY (id_vendedor) REFERENCES DATA_GROUP.Usuario (id_usuario);

ALTER TABLE DATA_GROUP.ItemFactura ADD CONSTRAINT fk_ItemFactura_to_Publicacion 
FOREIGN KEY (id_publicacion) REFERENCES DATA_GROUP.Publicacion ( id_publicacion );

ALTER TABLE DATA_GROUP.ItemFactura ADD CONSTRAINT fk_ItemFactura_to_Factura 
FOREIGN KEY (nro_factura) REFERENCES DATA_GROUP.Factura ( nro_factura );


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
------------------------------------MIGRACION----------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--------------------------------------------------------
----------------------TipoDocumento---------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.TipoDocumento(descripcion)
VALUES ('DNI'), ('LC'), ('LE'), ('CUIT');

--------------------------------------------------------
--------------------EstadoPublicacion-------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.EstadoPublicacion(descripcion)
VALUES ('Publicada'),('Borrador'),('Pausada'),('Finalizada');
--Activa=Publicada, en la maestra aparece como publicada.

--------------------------------------------------------
------------------VisibilidadPublicacion----------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.VisibilidadPublicacion(id_visibilidad, descripcion, precio, porcentaje)
SELECT DISTINCT Publicacion_Visibilidad_Cod, Publicacion_Visibilidad_Desc,Publicacion_Visibilidad_Precio, Publicacion_Visibilidad_Porcentaje
FROM gd_esquema.Maestra;

--------------------------------------------------------
------------------------Rol-----------------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.Rol(nombre)
VALUES ('Administrador General'),('Cliente'),('Empresa');

--------------------------------------------------------
----------------------Funcionalidad---------------------
--------------------------------------------------------

INSERT INTO DATA_GROUP.Funcionalidad(nombre)
VALUES ('ABM de Rol'), ('Registro de Usuario'), ('ABM de Cliente'), ('ABM de Empresa'), 
	   ('ABM de visibilidad de publicacion'), ('Generar Publicacion'), ('Editar Publicacion'), 
	   ('Gestión de Preguntas'), ('Comprar/Ofertar'), ('Historial de Cliente'), 
	   ('Facturar Publicaciones'), ('Listado Estadístico');
	   
--------------------------------------------------------
-------------------FuncionalidadXRol--------------------
--------------------------------------------------------
--Rol Administrador General
INSERT INTO DATA_GROUP.FuncionalidadXRol(id_rol, id_funcionalidad)
VALUES (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7), (1,8), (1,9), (1,10), (1,11), (1,12);
--Rol Cliente
INSERT INTO DATA_GROUP.FuncionalidadXRol(id_rol, id_funcionalidad)
VALUES (2,6), (2,7), (2,8), (2,9), (2,10);
--Rol Empresa
INSERT INTO DATA_GROUP.FuncionalidadXRol(id_rol, id_funcionalidad)
VALUES  (3,6), (3,7), (3,8), (3,9), (3,10);
--------------------------------------------------------
------------------------Rubro---------------------------
--------------------------------------------------------

INSERT INTO DATA_GROUP.Rubro(descripcion)
SELECT DISTINCT Publicacion_Rubro_Descripcion
FROM gd_esquema.Maestra;

--------------------------------------------------------
---------------------TipoPublicacion--------------------
--------------------------------------------------------

INSERT INTO DATA_GROUP.TipoPublicacion(descripcion)
VALUES ('Compra inmediata'), ('Subasta');

--------------------------------------------------------
-------------------------Usuarios-----------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.Usuario(username, contrasenia, tipo_usuario)
SELECT DISTINCT CONVERT(nvarchar, Publ_Cli_Dni), 'w23e', 'CLI'
FROM gd_esquema.Maestra
WHERE Publ_Cli_Dni IS NOT NULL
UNION
SELECT DISTINCT CONVERT(nvarchar, Publ_Empresa_Cuit), 'w23e', 'EMP'
FROM gd_esquema.Maestra
WHERE Publ_Empresa_Cuit IS NOT NULL

INSERT INTO DATA_GROUP.Usuario(username, contrasenia, tipo_usuario)
VALUES ('admin','w23e', 'ADM'); 

--------------------------------------------------------
----------------------Administrador---------------------
--------------------------------------------------------

INSERT INTO DATA_GROUP.Administrador(id_usuario)
SELECT U.id_usuario
FROM DATA_GROUP.Usuario U
WHERE U.tipo_usuario='ADM' AND U.username ='admin' AND U.contrasenia='w23e';

--------------------------------------------------------
-------------------------Cliente------------------------
--------------------------------------------------------

INSERT INTO DATA_GROUP.Cliente(nro_documento, id_tipo_documento, id_usuario, apellido, nombre, fecha_nacimiento, mail, dom_calle, nro_calle, piso, depto, cod_postal)
SELECT DISTINCT maes.Publ_Cli_Dni, 1, usu.id_usuario, maes.Publ_Cli_Apeliido, maes.Publ_Cli_Nombre, maes.Publ_Cli_Fecha_Nac, maes.Publ_Cli_Mail, Publ_Cli_Dom_Calle, Publ_Cli_Nro_Calle, Publ_Cli_Piso, Publ_Cli_Depto, Publ_Cli_Cod_Postal
FROM gd_esquema.Maestra maes
JOIN DATA_GROUP.Usuario usu
ON usu.tipo_usuario='CLI' AND usu.username=CAST(maes.Publ_Cli_Dni AS NVARCHAR(255));

--------------------------------------------------------
-------------------------Empresa------------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.Empresa(razon_social, cuit, id_usuario, fecha_creacion, mail, dom_calle, nro_calle, piso, depto, cod_postal)
SELECT DISTINCT m.Publ_Empresa_Razon_Social, m.Publ_Empresa_Cuit, u.id_usuario, m.Publ_Empresa_Fecha_Creacion, m.Publ_Empresa_Mail, m.Publ_Empresa_Dom_Calle, m.Publ_Empresa_Nro_Calle, m.Publ_Empresa_Piso, m.Publ_Empresa_Depto, m.Publ_Empresa_Cod_Postal
FROM gd_esquema.Maestra m
JOIN DATA_GROUP.Usuario u
ON u.tipo_usuario='EMP' AND u.username=CAST(m.Publ_Empresa_Cuit AS NVARCHAR(255))
WHERE m.Publ_Empresa_Cuit is not null;

--------------------------------------------------------
------------------------RolXUsuario---------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.UsuarioXRol(id_usuario, id_rol)
SELECT DISTINCT c.id_usuario, 2
FROM DATA_GROUP.Cliente c
UNION
SELECT DISTINCT e.id_usuario, 3
FROM DATA_GROUP.Empresa e
UNION
SELECT DISTINCT a.id_usuario, 1
FROM DATA_GROUP.Administrador a;


--------------------------------------------------------
------------------------Publicacion---------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.Publicacion (id_publicacion, descripcion, stock, fecha_inicio, fecha_vencimiento, precio, id_tipo_publicacion, id_visibilidad, id_estado, id_usuario_publicador, id_rubro)
SELECT DISTINCT m.Publicacion_Cod, 
				m.Publicacion_Descripcion, 
				m.Publicacion_Stock, 
				m.Publicacion_Fecha, 
				m.Publicacion_Fecha_Venc, 
				m.Publicacion_Precio, 
				case m.Publicacion_Tipo WHEN 'Compra Inmediata' THEN 1 WHEN 'Subasta' THEN 2 END, 
				m.Publicacion_Visibilidad_Cod,
				case WHEN m.Publicacion_Fecha_Venc > CAST('20140618' as datetime) THEN 1 ELSE 4 END,
				u.id_usuario, 
				r.id_rubro
FROM gd_esquema.Maestra m
INNER JOIN DATA_GROUP.Usuario u
ON CONVERT(nvarchar, m.Publ_Cli_Dni)=u.username OR CONVERT(nvarchar, m.Publ_Empresa_Cuit)=u.username
INNER JOIN DATA_GROUP.Rubro r
ON m.Publicacion_Rubro_Descripcion=r.descripcion
WHERE m.Publicacion_Cod is not null;

--------------------------------------------------------
-----------------CalificacionPublicacion----------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.CalificacionPublicacion(id_calificacion, estrellas_calificacion, detalle_calificacion)
SELECT DISTINCT m.Calificacion_Codigo, m.Calificacion_Cant_Estrellas, m.Calificacion_Descripcion
FROM gd_esquema.Maestra m
WHERE m.Calificacion_Codigo is not null;

--------------------------------------------------------
-------------------------Compras------------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.Compra(fecha, cantidad, id_calificacion, id_usuario_comprador, id_publicacion)
SELECT m.Compra_Fecha, m.Compra_Cantidad, m.Calificacion_Codigo, u.id_usuario, m.Publicacion_Cod
FROM gd_esquema.Maestra m
JOIN DATA_GROUP.Usuario u
ON u.username=CAST(m.Cli_Dni as nvarchar(255))
WHERE m.Compra_Fecha is not null AND
		m.Cli_Dni is not null AND
		m.Publicacion_Cod is not null;
		
--------------------------------------------------------
-------------------------Ofertas------------------------
--------------------------------------------------------		
INSERT INTO DATA_GROUP.Oferta(fecha, monto, id_publicacion, id_usuario_ofertador)
SELECT m.Oferta_Fecha, m.Oferta_Monto, m.Publicacion_Cod, u.id_usuario
FROM gd_esquema.Maestra m
JOIN DATA_GROUP.Usuario u
ON u.username=CAST(m.Cli_Dni as nvarchar(255))
WHERE m.Oferta_Fecha is not null and
		m.Cli_Dni is not null;
		
--------------------------------------------------------
------------------------Facturas------------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.Factura(nro_factura, fecha, forma_pago_descripcion, total, id_vendedor)
SELECT DISTINCT m.Factura_Nro, m.Factura_Fecha, m.Forma_Pago_Desc, m.Factura_Total, p.id_usuario_publicador
FROM gd_esquema.Maestra m
JOIN DATA_GROUP.Publicacion p
ON m.Publicacion_Cod=p.id_publicacion
WHERE m.Factura_Nro is not null;

--------------------------------------------------------
----------------------ItemFactura-----------------------
--------------------------------------------------------
INSERT INTO DATA_GROUP.ItemFactura(cantidad, monto, id_publicacion, nro_factura)
SELECT m.Item_Factura_Cantidad, m.Item_Factura_Monto, m.Publicacion_Cod, m.Factura_Nro
FROM gd_esquema.Maestra m
WHERE m.Factura_Nro is not null;

--Completo la transaccion
COMMIT