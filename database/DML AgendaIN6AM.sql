CREATE DATABASE Agenda;
USE Agenda;


CREATE TABLE Categoria(
	idCategoria INT NOT NULL AUTO_INCREMENT,
	nombreCategoria VARCHAR (30) NOT NULL,
	PRIMARY KEY (idCategoria)
);


CREATE TABLE Contacto(
	idContacto INT NOT NULL AUTO_INCREMENT,
	nombreContacto VARCHAR (30) NOT NULL,
	apellido VARCHAR (30) NOT NULL,
	direccion VARCHAR (30) NOT NULL,
	telefono VARCHAR (30) NOT NULL,	
	correo VARCHAR (30) NOT NULL,
	idCategoria INT NOT NULL,
	PRIMARY KEY (idContacto),
	FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);


CREATE TABLE Usuario(
	idUsuario INT NOT NULL AUTO_INCREMENT,
	nick VARCHAR (30) NOT NULL,
	contrasena VARCHAR (30) NOT NULL,
    primary key (idUsuario)
);


CREATE TABLE UsuarioDetalle(
	idUsuarioDetalle INT NOT NULL AUTO_INCREMENT,
	idUsuario INT NOT NULL,
	idContacto INT NOT NULL,
	PRIMARY KEY (idUsuarioDetalle),
	FOREIGN KEY (idUsuario) REFERENCES Usuario (idUsuario),
	FOREIGN KEY (idContacto) REFERENCES Contacto (idContacto)
);


CREATE VIEW  vistaContacto AS
SELECT contacto.idContacto, nombreContacto, apellido, direccion, telefono, correo, nombreCategoria 
FROM Contacto 
INNER JOIN categoria ON contacto.idCategoria = categoria.idCategoria;

/*TRIGGER*/
DELIMITER @@
CREATE TRIGGER registroContacto AFTER INSERT ON UsuarioDetalle
  FOR EACH ROW
  BEGIN
    DECLARE _idUsuario integer;
    SET _idUsuario = (SELECT idUsuario from UsuarioDetalle ORDER BY idUsuarioDetalle DESC LIMIT 1);
    IF (_idUsuario <> 0) THEN
       INSERT INTO Historial(descripcion, idUsuario) VALUES ('Contacto Agregado', _idUsuario);
    END IF;
  END;
@@


/*REGISTRAR*/
/*USUARIO*/
DELIMITER //
CREATE PROCEDURE SP_addUser(IN user_name VARCHAR (30), IN passwordUser VARCHAR (30))
	BEGIN
	INSERT INTO Usuario(nick, contrasena) VALUES (user_name, passwordUser);
	END 
    
/*CALL SP_addUser('admin', 'admin');
SELECT * FROM Usuario;*/

/*CATEGORIA*/
DELIMITER //
CREATE PROCEDURE SP_addCategoria1(IN c_nombre VARCHAR (30))
	BEGIN
    INSERT INTO Categoria(nombreCategoria) VALUES (c_nombre);
    END
 
 /*CALL SP_addCategoria1('Colegio');
 SELECT * FROM Categoria;*/
 
 /*CONTACTO*/
 DELIMITER //
CREATE PROCEDURE SP_agregarContacto(IN ct_nombre VARCHAR (30), IN ct_apellido VARCHAR (30), IN ct_direccion VARCHAR(30), IN ct_telefono VARCHAR (30), IN ct_correo VARCHAR (30), IN ct_idCategoria INT)
	BEGIN
	INSERT INTO Contacto(nombreContacto, apellido, direccion, telefono, correo, idCategoria) VALUES (ct_nombre, ct_apellido, ct_direccion, ct_telefono, ct_correo, ct_idCategoria);
	END 
    
 /*CALL SP_agregarContacto('Estuardo', 'Lopez', 'Zona 5', '23354801', 'elopez@gmail.com', 1);
 SELECT * FROM Contacto;*/
 
 
/*DETALLEUSUARIO*/ 
 DELIMITER //
CREATE PROCEDURE SP_addDetalleUsuario(IN dt_idUsuario INT, IN dt_idContacto INT)
	BEGIN
	INSERT INTO UsuarioDetalle(idUsuario, idContacto) VALUES (dt_idUsuario, dt_idContacto);
	END
    
 /*CALL SP_addDetalleUsuario(1, 1);
 SELECT * FROM UsuarioDetalle;*/
 
 
 
/*MODIFICAR*/
DELIMITER //
CREATE PROCEDURE SP_updateUsuario(IN u_idUsuario INT, IN user_name VARCHAR (30), IN passwordUser VARCHAR (30))
	BEGIN
    UPDATE Usuario
    SET
		nick = user_name, 
        password = passwordUser
    WHERE idUsuario =  u_idUsuario;
    END
		
/*CALL SP_updateUsuario('1', 'admin', 'admin')    
SELECT * FROM Usuario; */

DELIMITER //
CREATE PROCEDURE SP_updateContacto(IN ct_idContacto INT, IN ct_nombre VARCHAR (30), IN ct_apellido VARCHAR (30), IN ct_direccion VARCHAR(30), IN ct_telefono VARCHAR (30), IN ct_correo VARCHAR (30), IN ct_idCategoria INT)
	BEGIN
    
    UPDATE Contacto
    SET
		nombre = ct_nombre, 
        apellido = ct_apellido,
        direccion = ct_direccion,
        telefono = ct_telefono,
        correo = ct_correo,
        idCategoria = ct_idCategoria
    WHERE idContacto =  ct_idContacto;
    END
 
 /*CALL SP_updateContacto('1', 'josue', 'barrios', 'zona 3', '24409836', 'jbarrios@gmail.com', '2')
 SELECT * FROM Contacto;*/
 

DELIMITER $$
CREATE PROCEDURE SP_updateCategoria(IN _idCategoria INT, IN _nombreCategoria VARCHAR(30)) BEGIN
UPDATE Categoria SET nombreCategoria = _nombreCategoria WHERE idCategoria = _idCategoria; END
$$

CALL SP_updateCategoria('33', 'Casa');
select * from Categoria;

/*ELIMINAR*/
 DELIMITER //
 CREATE PROCEDURE SP_deleteUsuario(IN u_idUsuario INT)
	BEGIN 
		
    DELETE FROM Usuario
    WHERE  idUsuario = u_idUsuario;
END 

/*CAll SP_deleteUsuario(2);*/

 DELIMITER //
 CREATE PROCEDURE SP_deleteContacto(IN ct_idContacto INT)
	BEGIN 
		
    DELETE FROM Contacto
    WHERE  idContacto = ct_idContacto;
END


 DELIMITER //
 CREATE PROCEDURE SP_deleteDetalleUsuario(IN dt_idDetalleUsuario INT)
	BEGIN 
		
    DELETE FROM UsuarioDetalle
    WHERE  idUsuarioDetalle = dt_idDetalleUsuario;
END

 DELIMITER //
 CREATE PROCEDURE SP_deleteCategoria(IN c_idCategoria INT)
	BEGIN 
		
    DELETE FROM Categoria
    WHERE  idCategoria= c_idCategoria;
END

