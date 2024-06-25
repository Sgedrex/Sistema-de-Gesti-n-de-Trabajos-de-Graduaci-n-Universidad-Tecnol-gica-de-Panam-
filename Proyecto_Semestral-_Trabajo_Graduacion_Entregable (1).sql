--   2.CREACION DE LA BASE DE DATOS
--------------------------------------
CREATE DATABASE Trabajo_Graduacion
drop database Trabajo_Graduacion
use trabajo_graduacion 
go 


--------------------------------------Creacion de tabla SEDE
CREATE TABLE Sede (
    Cod_sede INT
	  CONSTRAINT cod_sede_pk PRIMARY KEY (Cod_sede),
    Nombre_sede VARCHAR(255) NOT NULL
	 CONSTRAINT uk_nombresede_sede UNIQUE (Nombre_Sede),
    Ubicacion VARCHAR(255) NOT NULL,
      CONSTRAINT ubicacion_ck 
		CHECK (Ubicacion IN ('Panama', 'Colon', 'Panama Oeste', 'Cocle',
		                   'Azuero', 'Veraguas', 'Chiriqui', 'Bocas del Toro Centro',
						   'Bethania','Tocumen','Panama-Pacifico'))
)

------------------------------------------Creacion de tabla EMPRESA
CREATE TABLE Empresa (
    Cod_empresa INT 
	  CONSTRAINT cod_empresa_pk PRIMARY KEY,
    Nombre_empresa VARCHAR(100) NOT NULL
	  CONSTRAINT uk_nombreempresa_empresa UNIQUE (Nombre_Empresa)
)

----------------------------------------Creacion de tabla SUPERVISOR
CREATE TABLE Supervisor (
    Cod_supervisor INT
	  CONSTRAINT supervisor_pk PRIMARY KEY,
    Nombre_supervisor VARCHAR(255) NOT NULL,
    Apellido_supervisor VARCHAR(255) NOT NULL,
    Cod_empresa INT,
      FOREIGN KEY (Cod_empresa) REFERENCES Empresa(Cod_empresa)
)

-------------------------------------Creacion de tabla PROFESOR
CREATE TABLE Profesor (
    Cod_Profesor INT CONSTRAINT COD_PROF_PK PRIMARY KEY,
    Nombre_prof VARCHAR(255) NOT NULL,
    Apellido_prof VARCHAR(255) NOT NULL,
    Tipo_prof VARCHAR(50)
)

---------------------------------------Creacion de tabla DEPARTAMENTO
CREATE TABLE Departamento (
    Cod_depto INT 
	 Constraint pk_departamento_departamento PRIMARY KEY,
    Nombre_depto VARCHAR(255) NOT NULL,
	Cod_Profesor_jefe INT 
	 Constraint fk_profesor_departamento foreign key references profesor (cod_profesor)
);

---------------------- ----------------AÑADIR CONSTRAINT DE FOREIGN KEY 
Alter Table profesor
add cod_depto int
Constraint fk_profesor_depto foreign key references departamento (cod_depto)


----------------------------------------Creacion de la tabla PROYECTO
CREATE TABLE Proyecto (
    Cod_proyecto VARCHAR(20) PRIMARY KEY,
    Titulo_proyecto VARCHAR(255),
    Cod_profesor INT,
	tipo_proyecto char(2)
	  Constraint ch_tipoproyecto_proyecto CHECK (tipo_proyecto in ('TT','TP','PP')),
    Fecha_entrega DATE DEFAULT GETDATE(), 
    Fecha_verificacion DATE NULL,
    Fecha_evaluacion DATE NULL,
    Fecha_aprobacion DATE NULL,
    Fecha_sustentacion DATE NULL,
    constraint cod_prof_proy_fk FOREIGN KEY (Cod_profesor) 
        REFERENCES Profesor(Cod_Profesor),
    constraint fech_entrega_ck CHECK (Fecha_entrega <= GETDATE()),
    constraint f_verifica_ck CHECK (Fecha_verificacion > Fecha_entrega),
    constraint f_evalua_ck CHECK (Fecha_evaluacion > Fecha_verificacion),
    constraint f_aprobacion_ck CHECK (Fecha_aprobacion > Fecha_evaluacion),
    constraint f_sustentacion_ck CHECK (Fecha_sustentacion > Fecha_aprobacion)
);


------------------------------------------Creacion de la tabla PRACTICA PROFESIONAL
CREATE TABLE Practica_profesional (
    Cod_proyecto VARCHAR(20) 
	CONSTRAINT PRACT_PROF_COD_P_PK PRIMARY KEY(cod_proyecto),
    Cod_supervisor INT,
   Constraint cod_sup_pp_fk  FOREIGN KEY (Cod_supervisor) 
		REFERENCES Supervisor(Cod_supervisor) 
)


---------------------------------------------------Creacion de la tabla PROYECTO PROFESOR SUSTENTA
CREATE TABLE Proyecto_profesor_sustenta (
    Cod_Profesor INT,
    Cod_proyecto VARCHAR(20),
    Lugar VARCHAR(255),
    Nota_asignada FLOAT,
    Constraint proy_prof_sus_pk PRIMARY KEY (Cod_Profesor, Cod_proyecto),
   CONSTRAINT CODG_PROF_FK FOREIGN KEY (Cod_Profesor) 
		REFERENCES Profesor(Cod_Profesor),
   CONSTRAINT COD_PROYECTO_FK FOREIGN KEY (Cod_proyecto) 
		REFERENCES Proyecto(Cod_proyecto)
)


--------------------------------------------------------Creacion de la tabla CARRERA
CREATE TABLE Carrera (
    Cod_carrera INT,
    Nombre_carrera VARCHAR(255) NOT NULL,
    Cod_depto INT,
	    CONSTRAINT fk_coddept_carrera FOREIGN KEY (Cod_depto) References Departamento (cod_depto),
        CONSTRAINT carrera_pk Primary Key (Cod_carrera)
)


---------------------------Creacion de la tabla Estudiante
CREATE TABLE Estudiante (
    Cedula VARCHAR(13) 
	   CONSTRAINT cedula_estud_pk PRIMARY KEY,
    Pri_nom VARCHAR(50),
    Seg_nom VARCHAR(50),
    Pri_apellido VARCHAR(50),
    Seg_apellido VARCHAR(50),
    Año_cursa INT,
    Semestre INT,
    Indice DECIMAL(3, 2), 
    Cod_proyecto VARCHAR(20),
    Cod_carrera INT,
    Cod_sede INT,
      CONSTRAINT CEDULA_CK CHECK(Cedula like '[0][1-9][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'OR Cedula
		                              like '[1][0-3][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'OR Cedula
							          like '[2][0][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'),
   CONSTRAINT COD_PRO_EST_FK  FOREIGN KEY (Cod_proyecto) 
		REFERENCES Proyecto(Cod_proyecto),
    constraint cod_carrera_est_fk FOREIGN KEY (Cod_carrera)REFERENCES Carrera (Cod_carrera),
    FOREIGN KEY (Cod_sede) REFERENCES Sede(Cod_sede)
);

drop table telf_estud

-----------------------------Creacion de la tabla TELEFONOS DE ESTUDIANTES
CREATE TABLE Telf_Estud (
    Cedula VARCHAR(13)
	CONSTRAINT CEDULA_CK_telfestud CHECK(Cedula like '[0][0-9][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'OR Cedula
		                              like '[1][0-3][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'OR Cedula
							          like '[2][0][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'),
    Telefono VARCHAR(20),
    CONSTRAINT TELEF_PK PRIMARY KEY (Cedula, Telefono),
   Constraint ced_telf_fk  FOREIGN KEY (Cedula) REFERENCES Estudiante(Cedula)

)

drop table correo_estud
-------------------------------Creacion de la Tabla CORREO DE ESTUDIANTES
CREATE TABLE Correo_estud (
    Cedula VARCHAR(13)
	CONSTRAINT CEDULA_CK_Correoestud CHECK(Cedula like '[0][0-9][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'OR Cedula
		                              like '[1][0-3][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'OR Cedula
							          like '[2][0][-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]'),
    Correo VARCHAR(50),
    constraint correo_estud_pk PRIMARY KEY (Cedula, Correo),
	Constraint cedula_correo_estud_fk FOREIGN KEY (Cedula) REFERENCES Estudiante(Cedula)
)


----------------------------------- Creacion de la tabla EVALUACION
CREATE TABLE Evaluacion (
    Cod_proyecto VARCHAR(20),
    Fecha_evaluación DATE,
    Evaluacion FLOAT,
     CONSTRAINT EVALUACION_PK PRIMARY KEY (Cod_proyecto, Fecha_evaluación),
     CONSTRAINT COD_PROYECTOS_EVAL_FK FOREIGN KEY (Cod_proyecto) REFERENCES Proyecto(Cod_proyecto)
			
)



----------------------------------------------------------------------------------------
--                                     2. SECUENCIA PARA GENERAR CODIGO
                                     drop sequence numero_proyecto
-----------------------------------------------------------------------------------------


      CREATE SEQUENCE numero_Proyecto                         
            START WITH 1000
             INCREMENT BY 1



----------------------------------------------------------------------------------------
--                        2.TRIGGER PARA CODIGO DE LA TABLA PROYECTO
                                 drop trigger insertar_tipoproyecto
----------------------------------------------------------------------------------------
CREATE TRIGGER insertar_tipoproyecto
ON Proyecto
INSTEAD OF INSERT 
AS

    DECLARE @annio INT = YEAR(GETDATE());

    WITH ProyectosInsertados AS (
        SELECT 
            Titulo_proyecto, 
            Cod_profesor, 
            tipo_proyecto, 
            Fecha_entrega, 
            Fecha_verificacion, 
            Fecha_evaluacion, 
            Fecha_aprobacion, 
            Fecha_sustentacion
        FROM inserted
    )
    INSERT INTO Proyecto (Cod_proyecto, Titulo_proyecto, Cod_profesor, tipo_proyecto, Fecha_entrega, Fecha_aprobacion, Fecha_evaluacion, Fecha_sustentacion, Fecha_verificacion)
    SELECT 
        CONCAT(tipo_proyecto, '-',   @annio,  '-', NEXT VALUE FOR numero_Proyecto ) 

	AS Cod_proyecto,
        Titulo_proyecto, 
        Cod_profesor, 
        tipo_proyecto, 
        Fecha_entrega, 
        Fecha_aprobacion, 
        Fecha_evaluacion, 
        Fecha_sustentacion, 
        Fecha_verificacion
    FROM ProyectosInsertados;

	SELECT * FROM Proyecto

	INSERT INTO Estudiante (Cedula, Pri_nom, Seg_nom, Pri_apellido, Seg_apellido, Año_cursa, Semestre, Indice, Cod_proyecto, Cod_carrera, Cod_sede)
VALUES ('09-0001-0021', 'Eva', 'ALICIA' ,'galvan', 'villanueva', '5', '2', '3.5', 'PP-2023-1001', '004', '010');
    
	---------------------------------------------------------------------------------------------
--                         5.TRIGGER PARA VALIDAR SI YA EXISTE ESTUDIANTE
							  DROP trigger t_existe_anteproyecto_registrado
	---------------------------------------------------------------------------------------------
CREATE TRIGGER t_existe_anteproyecto_registrado
ON Estudiante
INSTEAD OF INSERT
AS

    DECLARE @Cedula VARCHAR(13);

    -- Recuperar la cédula del estudiante desde la tabla INSERTED
    SELECT @Cedula = i.Cedula
    FROM INSERTED AS i;

    -- Verificar si ya existe un anteproyecto registrado para este estudiante
    IF EXISTS (SELECT 1 FROM Estudiante WHERE Cedula = @Cedula AND Cod_proyecto IS NOT NULL)
    BEGIN
        -- Ya existe un anteproyecto registrado para este estudiante
        -- Puedes emitir un mensaje con el nombre y la fecha de la inscripción existente
        DECLARE @NombreEstudiante VARCHAR(150);
        DECLARE @FechaInscripcionAnterior DATE;

        SELECT  @FechaInscripcionAnterior = Fecha_entrega
			  from Proyecto
        SELECT @NombreEstudiante = Pri_nom + ' ' + Pri_apellido
              FROM Estudiante
         
        
        WHERE Cedula = @Cedula AND Cod_proyecto IS NOT NULL;

        PRINT 'El estudiante ' + @NombreEstudiante + ' ya tiene un anteproyecto registrado desde el ' + CONVERT(VARCHAR, @FechaInscripcionAnterior, 103) + '.';
    END
    ELSE
    BEGIN
        -- No existe un anteproyecto registrado para este estudiante, proceder con la inserción
        INSERT INTO Estudiante (Cedula, Pri_nom, Seg_nom, Pri_apellido, Seg_apellido, Año_cursa, Semestre, Indice, Cod_proyecto, Cod_carrera, Cod_sede)
        SELECT Cedula, Pri_nom, Seg_nom, Pri_apellido, Seg_apellido, Año_cursa, Semestre, Indice, Cod_proyecto, Cod_carrera, Cod_sede
        FROM INSERTED;
    END

	
-----------------------------------------------------------------------------------------------------------
--                          6. TRIGGER DE VALIDAR INSERCION O ACTUALIZACION DE PRACTICA PROFESIONAL
			                  drop trigger t_mensaje_practica
----------------------------------------------------------------------------------------------------------
CREATE TRIGGER t_mensaje_practica
ON Proyecto
AFTER INSERT, UPDATE
AS

    DECLARE @cod_proyecto VARCHAR(20);

    -- Obtener el código de proyecto de la tabla inserted
    SELECT @cod_proyecto = Cod_proyecto
    FROM inserted;

    -- Obtener los primeros dos dígitos del código de proyecto
    DECLARE @primeros_dos_digitos VARCHAR(2);
    SET @primeros_dos_digitos = LEFT(@cod_proyecto, 2);

    -- Verificar si los primeros dos dígitos indican una Práctica Profesional ("PP")
    IF (@primeros_dos_digitos = 'PP')
    BEGIN
        -- Construir el mensaje indicando que se deben incluir datos de la empresa y del supervisor
        PRINT'Este proyecto es de tipo Práctica Profesional. Asegúrese de incluir datos de la empresa y del supervisor.';
    END


	
---------------------------------------------------------------------------------------
--                          7.PROCEDIMIENTO ACTUALIZAR ETAPAS
                                 drop procedure P_Etapa
---------------------------------------------------------------------------------------
CREATE PROCEDURE P_Etapa
    @Cod_pro VARCHAR(20),
    @etapa_seleccionada CHAR(1)
AS
    -- Actualizar la fecha en la tabla Proyecto según la etapa seleccionada
    UPDATE Proyecto
    SET 
        Fecha_entrega = CASE WHEN @etapa_seleccionada = 'A' THEN GETDATE() ELSE Fecha_entrega END,
        Fecha_verificacion = CASE WHEN @etapa_seleccionada = 'B' THEN GETDATE() ELSE Fecha_verificacion END,
        Fecha_evaluacion = CASE WHEN @etapa_seleccionada = 'C' THEN GETDATE() ELSE Fecha_evaluacion END,
        Fecha_aprobacion = CASE WHEN @etapa_seleccionada = 'D' THEN GETDATE() ELSE Fecha_aprobacion END,
		Fecha_sustentacion = CASE WHEN @etapa_seleccionada = 'F' THEN GETDATE() ELSE Fecha_sustentacion END

    WHERE @Cod_pro = Cod_proyecto;

DECLARE @codigo_proyecto VARCHAR(20) = 'TT-2023-0016  '; 
DECLARE @etapa_selec CHAR(1) = 'D'; 
-- Llamar al procedimiento P_Etapa
EXEC P_Etapa @codigo_proyecto, @etapa_selec 


SELECT *
FROM Proyecto
WHERE Cod_proyecto = 'TT-2023-0016';

--------------------------------------------------------------------------------------


---                                      8. VISTAS

--------------------------------------------------------------------------------------

CREATE VIEW Vista_Entrega
AS
SELECT
    P.Cod_proyecto,
    E.Pri_nom + ' ' + E.Seg_nom + ' ' + E.Pri_apellido + ' ' + E.Seg_apellido AS Nombre_Estudiante,
    P.Titulo_proyecto,
    P.Fecha_entrega AS Fecha_Etapa
FROM
    Proyecto P
    JOIN Estudiante E ON P.Cod_proyecto = E.Cod_proyecto
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Proyecto P2
        WHERE P.Cod_proyecto = P2.Cod_proyecto
        AND COALESCE(P.Fecha_sustentacion, P.Fecha_aprobacion, P.Fecha_evaluacion, P.Fecha_verificacion, P.Fecha_entrega) <
            COALESCE(P2.Fecha_sustentacion, P2.Fecha_aprobacion, P2.Fecha_evaluacion, P2.Fecha_verificacion, P2.Fecha_entrega)
    );

	SELECT * FROM Vista_Entrega;

	CREATE VIEW Vista_Verificacion AS
SELECT
    P.Cod_proyecto,
    E.Pri_nom + ' ' + E.Seg_nom + ' ' + E.Pri_apellido + ' ' + E.Seg_apellido AS Nombre_Estudiante,
    P.Titulo_proyecto,
    P.Fecha_verificacion AS Fecha_Etapa
FROM
    Proyecto P
    JOIN Estudiante E ON P.Cod_proyecto = E.Cod_proyecto
WHERE
    P.Fecha_verificacion IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM Proyecto P2
        WHERE P.Cod_proyecto = P2.Cod_proyecto
        AND COALESCE(P.Fecha_sustentacion, P.Fecha_aprobacion, P.Fecha_evaluacion, P.Fecha_verificacion) <
            COALESCE(P2.Fecha_sustentacion, P2.Fecha_aprobacion, P2.Fecha_evaluacion, P2.Fecha_verificacion)
    );

	SELECT * FROM Vista_Verificacion;

-- Vista para Evaluación
CREATE VIEW Vista_Evaluacion AS
SELECT
    P.Cod_proyecto,
    E.Pri_nom + ' ' + E.Seg_nom + ' ' + E.Pri_apellido + ' ' + E.Seg_apellido AS Nombre_Estudiante,
    P.Titulo_proyecto,
    P.Fecha_evaluacion AS Fecha_Etapa
FROM
    Proyecto P
    JOIN Estudiante E ON P.Cod_proyecto = E.Cod_proyecto
WHERE
    P.Fecha_evaluacion IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM Proyecto P2
        WHERE P.Cod_proyecto = P2.Cod_proyecto
        AND COALESCE(P.Fecha_sustentacion, P.Fecha_aprobacion, P.Fecha_evaluacion, P.Fecha_verificacion) <
            COALESCE(P2.Fecha_sustentacion, P2.Fecha_aprobacion, P2.Fecha_evaluacion, P2.Fecha_verificacion)
    );
	SELECT * FROM Vista_Evaluacion;

CREATE VIEW Vista_Aprobacion AS
SELECT
    P.Cod_proyecto,
    E.Pri_nom + ' ' + E.Seg_nom + ' ' + E.Pri_apellido + ' ' + E.Seg_apellido AS Nombre_Estudiante,
    P.Titulo_proyecto,
    P.Fecha_aprobacion AS Fecha_Etapa
FROM
    Proyecto P
    JOIN Estudiante E ON P.Cod_proyecto = E.Cod_proyecto
WHERE
    P.Fecha_aprobacion IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM Proyecto P2
        WHERE P.Cod_proyecto = P2.Cod_proyecto
        AND COALESCE(P.Fecha_sustentacion, P.Fecha_aprobacion, P.Fecha_evaluacion, P.Fecha_verificacion) <
            COALESCE(P2.Fecha_sustentacion, P2.Fecha_aprobacion, P2.Fecha_evaluacion, P2.Fecha_verificacion)
    );
	SELECT * FROM Vista_Aprobacion;

CREATE VIEW Vista_Sustentacion AS
SELECT
    P.Cod_proyecto,
    E.Pri_nom + ' ' + E.Seg_nom + ' ' + E.Pri_apellido + ' ' + E.Seg_apellido AS Nombre_Estudiante,
    P.Titulo_proyecto,
    P.Fecha_sustentacion AS Fecha_Etapa
FROM
    Proyecto P
    JOIN Estudiante E ON P.Cod_proyecto = E.Cod_proyecto
WHERE
    P.Fecha_sustentacion IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM Proyecto P2
        WHERE P.Cod_proyecto = P2.Cod_proyecto
        AND COALESCE(P.Fecha_sustentacion, P.Fecha_aprobacion, P.Fecha_evaluacion, P.Fecha_verificacion) <
            COALESCE(P2.Fecha_sustentacion, P2.Fecha_aprobacion, P2.Fecha_evaluacion, P2.Fecha_verificacion)
    );
SELECT * FROM Vista_Sustentacion;

-- Vista de desarrollo
CREATE VIEW Vista_Desarrollo AS
SELECT
    P.Cod_proyecto,
    E.Pri_nom + ' ' + E.Seg_nom + ' ' + E.Pri_apellido + ' ' + E.Seg_apellido AS Nombre_Estudiante,
    P.Titulo_proyecto,
    P.Fecha_aprobacion AS Fecha_Aprobacion
FROM
    Proyecto P
    JOIN Estudiante E ON P.Cod_proyecto = E.Cod_proyecto
WHERE
    P.Fecha_aprobacion IS NOT NULL
    AND P.Fecha_sustentacion IS NULL
    AND NOT EXISTS (
        SELECT 1
        FROM Proyecto P2
        WHERE P.Cod_proyecto = P2.Cod_proyecto
        AND COALESCE(P.Fecha_sustentacion, P.Fecha_aprobacion, P.Fecha_evaluacion, P.Fecha_verificacion) <
            COALESCE(P2.Fecha_sustentacion, P2.Fecha_aprobacion, P2.Fecha_evaluacion, P2.Fecha_verificacion)
    );

-- Seleccionar todos los registros de la vista
SELECT * FROM Vista_Desarrollo;

-------------------------------------------------------------------------------------


--                                 9. PROCEDIMIENTO PARA EJECUTAR VISTAS


-------------------------------------------------------------------------------------
CREATE PROCEDURE p_muestra_vistas
    @tipo_busqueda CHAR(1)
AS
BEGIN
   

    -- Evaluar la elección del cliente y mostrar la vista correspondiente
    IF @tipo_busqueda = 'A'
        SELECT * FROM Vista_Entrega;
    ELSE IF @tipo_busqueda = 'B'
        SELECT * FROM Vista_Verificacion;
    ELSE IF @tipo_busqueda = 'C'
        SELECT * FROM Vista_Evaluacion;
    ELSE IF @tipo_busqueda = 'D'
        SELECT * FROM Vista_Aprobacion;
    ELSE IF @tipo_busqueda = 'E'
        SELECT * FROM Vista_Desarrollo;
    ELSE IF @tipo_busqueda = 'F'
        SELECT * FROM Vista_Sustentacion;
    ELSE
        PRINT 'Tipo de búsqueda no válido.';
END;

--EJECUTAR VISTA
EXEC p_muestra_vistas 'D';
----------------------------------------------------------------------


--                      10.Procedimiento p_empresas_colaboradoras 
  drop procedure p_empresas_colaboradoras

-----------------------------------------------------------------------
CREATE PROCEDURE p_proyectos_activos_aprobados
    @nombre_empresa VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.Titulo_proyecto AS 'Título del Proyecto',
        E.Pri_nom + ' ' + E.Pri_apellido AS 'Nombre del Estudiante',
        E.Cedula AS 'Cédula del Estudiante',
        S.Nombre_supervisor + ' ' + S.Apellido_supervisor AS 'Nombre del Supervisor',
        P.Fecha_sustentacion AS 'Fecha de Sustentación',
        CASE 
            WHEN P.Fecha_sustentacion IS NULL AND P.Fecha_aprobacion IS NOT NULL THEN 'ACTIVA'
            ELSE 'CONCLUIDA'
        END AS 'Estado'
    FROM Practica_profesional PP
    INNER JOIN Proyecto P ON PP.Cod_proyecto = P.Cod_proyecto
    INNER JOIN Estudiante E ON P.Cod_proyecto = E.Cod_proyecto
    INNER JOIN Supervisor S ON PP.Cod_supervisor = S.Cod_supervisor
    INNER JOIN Empresa Emp ON S.Cod_empresa = Emp.Cod_empresa
    WHERE Emp.Nombre_empresa = @nombre_empresa
    ORDER BY P.Fecha_sustentacion DESC;
END;

-- Ejemplo de ejecución del procedimiento con el nombre de la empresa como parámetro
EXEC p_proyectos_activos_aprobados @nombre_empresa = 'MELO';


SELECT * FROM PROYECTO
-----------------------------------------------------------------------

--                        11.CURSOR c_cuenta_modalidad_activa 
                        
----------------------------------------------------------------------------

-- Declarar variables para el cursor
DECLARE @TipoProyecto NVARCHAR(50);
DECLARE @Cantidad INT;
DECLARE @NombreProyectoo NVARCHAR(100);
DECLARE @CedulaEstudiante NVARCHAR(20);
DECLARE @NombresEstudiantes NVARCHAR(MAX);
DECLARE @NombreEmpresa NVARCHAR(100);

SET NOCOUNT ON;

-- Crear el cursor
DECLARE c_cuenta_modalidad_activa CURSOR FOR
    SELECT tipo_proyecto, COUNT(*) AS Cantidad
    FROM proyecto P
	INNER JOIN estudiante E ON P.cod_proyecto = E.cod_proyecto
    WHERE Fecha_sustentacion IS null and E.Cod_proyecto = P.Cod_proyecto
    GROUP BY tipo_proyecto;

-- Abrir el cursor
OPEN c_cuenta_modalidad_activa;

-- Inicializar la variable de resultados
FETCH NEXT FROM c_cuenta_modalidad_activa INTO @TipoProyecto, @Cantidad;

-- Recorrer el cursor
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Imprimir información del tipo de proyecto y cantidad
    PRINT 'Tipo de Proyecto: ' + @TipoProyecto + ', Cantidad: ' + CAST(@Cantidad AS NVARCHAR(10));

    -- Inicializar la variable de nombres de estudiantes
    SET @NombresEstudiantes = '';

    -- Obtener los nombres de los proyectos y estudiantes
    DECLARE c_proyectos_estudiantes CURSOR FOR
        SELECT P.Titulo_proyecto, E.cedula
        FROM proyecto P
        INNER JOIN estudiante E ON P.cod_proyecto = E.cod_proyecto
        WHERE P.tipo_proyecto = @TipoProyecto AND P.Fecha_sustentacion IS NULL;

    -- Abrir el cursor interno
    OPEN c_proyectos_estudiantes;

    -- Inicializar la variable de nombre de empresa
    SET @NombreEmpresa = '';

    -- Recorrer el cursor interno
    FETCH NEXT FROM c_proyectos_estudiantes INTO @NombreProyectoo, @CedulaEstudiante;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Concatenar nombres de estudiantes
        SET @NombresEstudiantes = @NombresEstudiantes + ', ' + @CedulaEstudiante;

        -- Obtener nombre de la empresa para las prácticas profesionales
        SET @NombreEmpresa = (
            SELECT TOP 1 E.nombre_empresa
            FROM practica_profesional PP
            INNER JOIN supervisor S ON PP.cod_supervisor = S.cod_supervisor
            INNER JOIN empresa E ON S.cod_empresa = E.cod_empresa
            WHERE PP.cod_proyecto = (SELECT cod_proyecto FROM proyecto WHERE Titulo_proyecto = @NombreProyectoo)
        );

        -- Imprimir información del proyecto, estudiantes y empresa (si aplica)
        IF @NombreEmpresa IS NOT NULL
            PRINT '  Proyecto: ' + @NombreProyectoo + ', Estudiantes: ' + @NombresEstudiantes + ', Empresa: ' + @NombreEmpresa;
        ELSE
            PRINT '  Proyecto: ' + @NombreProyectoo + ', Estudiantes: ' + @NombresEstudiantes;

        FETCH NEXT FROM c_proyectos_estudiantes INTO @NombreProyectoo, @CedulaEstudiante;
    END;

    -- Cerrar el cursor interno
    CLOSE c_proyectos_estudiantes;
	DEALLOCATE c_proyectos_estudiantes;

    -- Obtener la siguiente fila del cursor principal
    FETCH NEXT FROM c_cuenta_modalidad_activa INTO @TipoProyecto, @Cantidad;
END;

-- Cerrar el cursor principal
CLOSE c_cuenta_modalidad_activa;
DEALLOCATE c_cuenta_modalidad_activa;

--------------------------------------------------------------------------------


--                            12. CURSOR C_SUSTENACIONES


--------------------------------------------------------------------------------
-- Cursor para contar tesis y prácticas sustentadas
DECLARE c_sustentaciones CURSOR FOR
SELECT
    YEAR(p.Fecha_sustentacion) AS Anio,
    CASE
        WHEN MONTH(p.Fecha_sustentacion) IN (1, 2, 3, 4, 5, 6) THEN '1S'
        ELSE '2S'
    END AS Semestre,
    p.tipo_proyecto AS Modalidad,
    COUNT(*) AS Cantidad,
    p.Titulo_proyecto AS Titulo_Proyecto,
    e.Pri_nom + ' ' + e.Pri_apellido AS Autor
FROM
    Proyecto p
JOIN Estudiante e ON p.Cod_proyecto = e.Cod_proyecto
WHERE
    p.Fecha_sustentacion IS NOT NULL
GROUP BY
    YEAR(p.Fecha_sustentacion),
    CASE
        WHEN MONTH(p.Fecha_sustentacion) IN (1, 2, 3, 4, 5, 6) THEN '1S'
        ELSE '2S'
    END,
    p.tipo_proyecto,
    p.Titulo_proyecto,
    e.Pri_nom,
    e.Pri_apellido;

-- Variables para almacenar los resultados del cursor
DECLARE @Anio INT, @Semestre VARCHAR(2), @Modalidad CHAR(2), @Cantidad INT, @Titulo_Proyecto VARCHAR(255), @Autor VARCHAR(100);

-- Abrir el cursor y obtener el primer registro
OPEN c_sustentaciones;
FETCH NEXT FROM c_sustentaciones INTO @Anio, @Semestre, @Modalidad, @Cantidad, @Titulo_Proyecto, @Autor;

-- Recorrer el cursor y mostrar resultados
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Mostrar resultados o realizar acciones según tus necesidades
    PRINT 'Año: ' + CAST(@Anio AS VARCHAR) + ', Semestre: ' + @Semestre + ', Modalidad: ' + @Modalidad + ', Cantidad: ' + CAST(@Cantidad AS VARCHAR) + ', Titulo: ' + @Titulo_Proyecto + ', Autor: ' + @Autor;

    -- Obtener el siguiente registro
    FETCH NEXT FROM c_sustentaciones INTO @Anio, @Semestre, @Modalidad, @Cantidad, @Titulo_Proyecto, @Autor;
END

-- Cerrar y desocupar el cursor
CLOSE c_sustentaciones;
DEALLOCATE c_sustentaciones;



----------------------------------------------------------------------------------


                    --  4. INSERCION DE DATOS

	
----------------------------------------------------------------------------------
	-- Inserción de datos en la tabla Sede
INSERT INTO Sede (Cod_sede, Nombre_sede, Ubicacion)
VALUES
    ('001', 'Centro Regional de Azuero', 'Azuero'),
    ('002', 'Centro Regional de Bocas del Toro', 'Bocas del Toro Centro'),
    ('003', 'Centro Regional de Chiriqui', 'Chiriqui'),
    ('004', 'Centro Regional de Cocle', 'Cocle'),
    ('005', 'Centro Regional de Colon', 'Colon'),
    ('006', 'Centro Regional de Panamá Oeste', 'Panama Oeste'),
    ('007', 'Centro Regional de Veraguas', 'Veraguas'),
	('008', 'Campus Victor Levi Sasso', 'Bethania'),
	('009', 'Sede Howard', 'Panama-Pacifico'),
	('010', 'Sede Tocumen', 'Tocumen');


	                 SELECT* FROM SEDE

-- Inserción de datos en la tabla empresa
INSERT INTO empresa (cod_empresa, nombre_empresa)
VALUES
    (1, 'ACP'),
    (2, 'MELO'),
    (3, 'INFOSGROUP'),
    (4, 'GDP'),
    (5, 'MEDUCA'),
    (6, 'INFORMATICA'),
    (7, 'CSS')
    

	       SELECT * FROM Empresa
		  
-- Inserción de datos  en la tabla Supervisor
INSERT INTO Supervisor (Cod_supervisor, Nombre_supervisor, Apellido_supervisor, Cod_empresa)
VALUES
    ('1000', 'Juan', 'Perez', '3'),
    ('1001', 'Rosa', 'Fuentes', '2'),
    ('1002', 'Lilibeth', 'Espinosa', '4'),
    ('1003', 'Pedro', 'Vazques', '1'),
    ('1004', 'Martha', 'Betancourt', '1'),
    ('1005', 'Mirtha', 'Moreno', '5'),
    ('1006', 'Pablo', 'Bonilla', '6'),
    ('1007', 'Victor', 'Murgas', '7'),
    ('1008', 'Priscilla', 'Bustamante', '2')
    

	    SELECT * FROM Supervisor

	-- Insertar datos en la tabla departamentos
	
	ALTER TABLE Departamento
	nocheck CONSTRAINT fk_profesor_departamento
	---- se debe quitar  el constraint antes para introducir los datos a la tabla
	
	ALTER TABLE Departamento
	check CONSTRAINT fk_profesor_departamento
	---- se debe quitar  el constraint antes para introducir los datos a la tabla
	

INSERT INTO departamento (Cod_depto, Nombre_depto,Cod_Profesor_jefe)
VALUES
    ('10001', 'Departamento de Arquitectura y Redes de Computadoras','001'),
    ('10002', 'Departamento de Computación y Simulación de Sistemas','002'),
    ('10003', 'Departamento de Ingeniería de Software','003'),
    ('10004', 'Departamento de Programación de Computadoras','004'),
    ('10005', 'Departamento de Sistemas de Información, Control y Evaluación de Recursos Informáticos','005')
 

	                  SELECT * FROM Departamento

ALTER TABLE Profesor
	nocheck CONSTRAINT fk_profesor_depto
	---- se debe quitar  el constraint antes para introducir los datos a la tabla

	ALTER TABLE Profesor
	check CONSTRAINT fk_profesor_depto


	-- Inserción de datos en la tabla Profesor
INSERT INTO Profesor (Cod_Profesor, Nombre_prof, Apellido_prof, Tipo_prof, Cod_depto)
VALUES
    ('001', 'Amarilis', 'Alvarado de Araya', 'Tiempo Completo', '10001'),
('002', 'Martín', 'Arosemena', 'Tiempo Parcial', '10001'),
('003', 'Aris', 'Castillo de Valencia', 'Tiempo Completo', '10001'),
('004', 'Sergio', 'Cotes', 'Tiempo Parcial', '10001'),
('005', 'Emilio', 'Dutari', 'Tiempo Completo', '10001'),
('006', 'Ernesto', 'García', 'Tiempo Parcial', '10001'),
('007', 'Giovana', 'Carrido', 'Tiempo Completo', '10001'),
('008', 'Alcides', 'Guerra', 'Tiempo Parcial', '10001'),
('009', 'Armando', 'Jipsion', 'Tiempo Completo', '10001'),
('010', 'Julio', 'Lezcano', 'Tiempo Parcial', '10001'),
('011', 'Roberto', 'Madrid', 'Tiempo Completo', '10001'),
('012', 'José', 'Moreno', 'Tiempo Parcial', '10001'),
('013', 'Euclides', 'Serracín', 'Tiempo Completo', '10001'),
('014', 'Lydia', 'de Toppin', 'Tiempo Parcial', '10001'),
('015', 'Miguel', 'Vargas', 'Tiempo Completo', '10001'),
('016', 'José', 'Achurra', 'Tiempo Parcial', '10001'),
('017', 'Carlos', 'Ávila', 'Tiempo Completo', '10001'),
('018', 'Ricardo', 'Brunel', 'Tiempo Parcial', '10001'),
('019', 'Marquela', 'Contreras', 'Tiempo Completo', '10001'),
('020', 'Mildred', 'Echezano', 'Tiempo Parcial', '10001'),
('021', 'Edsel', 'García', 'Tiempo Completo', '10001'),
('022', 'Jesús', 'González', 'Tiempo Parcial', '10001'),
('023', 'José', 'Grimaldo', 'Tiempo Completo', '10001'),
('024', 'Gina', 'Harris', 'Tiempo Parcial', '10001'),
('025', 'Kathya', 'Hart', 'Tiempo Completo', '10001'),
('026', 'Ricardo', 'Haynes', 'Tiempo Parcial', '10001'),
('027', 'Luis', 'Abdiel Julio', 'Tiempo Completo', '10001'),
('028', 'Isabel', 'Leguías', 'Tiempo Parcial', '10001'),
('029', 'Gustavo', 'Martínez', 'Tiempo Completo', '10001'),
('030', 'Genier', 'Miranda', 'Tiempo Parcial', '10001'),
('031', 'Néstor', 'Morales', 'Tiempo Completo', '10001'),
('032', 'Rubiel', 'Pérez', 'Tiempo Parcial', '10001'),
('033', 'Oscar', 'Torres', 'Tiempo Completo', '10001'),
('034', 'Xavier', 'Trujillo', 'Tiempo Parcial', '10001'),
('035', 'Armando', 'Zurita', 'Tiempo Completo', '10001'),
('036', 'Modaldo', 'Tuñón', 'Tiempo Parcial', '10002'),
('037', 'Raúl', 'Barahona','tiempo completo','10002'),
('038', 'Doris', 'Cueto', 'Tiempo Completo', '10002'),
('039', 'Yolanda', 'de Miguelena', 'Tiempo Parcial', '10002'),
('040', 'Nicolás', 'Samaniego', 'Tiempo Completo', '10002'),
('041', 'Jacqueline', 'de Ching', 'Tiempo Parcial', '10002'),
('042', 'Euclides', 'Samaniego', 'Tiempo Completo', '10002'),
('043', 'Elia', 'Cano', 'Tiempo Parcial', '10002'),
('044', 'Crispina', 'Ramos', 'Tiempo Completo', '10002'),
('045', 'Doris', 'Gutiérrez', 'Tiempo Parcial', '10002'),
('046', 'Nicholas', 'Beliz Osorio', 'Tiempo Completo', '10002'),
('047', 'Carlos', 'Rovetto', 'Tiempo Parcial', '10002'),
('048', 'Samuel', 'Jiménez', 'Tiempo Completo', '10002'),
('049', 'Sharon', 'Pérez', 'Tiempo Parcial', '10002'),
('050', 'Tomás', 'Concepción', 'Tiempo Completo', '10002'),
('051', 'Aly', 'Martin', 'Tiempo Parcial', '10002'),
('052', 'Iván', 'Rojas', 'Tiempo Completo', '10002'),
('053', 'Ezequiel', 'Aguilar', 'Tiempo Parcial', '10002'),
('054', 'Manuel', 'Flores', 'Tiempo Completo', '10002'),
('055', 'Alexis', 'Espinosa', 'Tiempo Parcial', '10002'),
('056', 'José', 'Rangel', 'Tiempo Completo', '10056'),
('057', 'Javier', 'Sánchez Galán', 'Tiempo Parcial', '10002'),
('058', 'Christofher', 'Cárdenas', 'Tiempo Completo', '10002'),
('059', 'Mirna', 'Samaniego', 'Tiempo Parcial', '10002'),
('060', 'Karla', 'Arosemena', 'Tiempo Completo', '10003'),
('061', 'Belén', 'Bonilla', 'Tiempo Parcial', '10003'),
('062', 'Vanessa', 'Castillo', 'Tiempo Completo', '10003'),
('063', 'Eduardo', 'Caballero', 'Tiempo Parcial', '10003'),
('064', 'Geovanny', 'Caballero', 'Tiempo Completo', '10003'),
('065', 'Evet', 'Clachar', 'Tiempo Parcial', '10003'),
('066', 'Clifton E.', 'Clunie B.', 'Tiempo Completo', '10003'),
('067', 'Ana Gloria', 'Cordero de Hernández', 'Tiempo Parcial', '10003'),
('068', 'Amílcar', 'Díaz', 'Tiempo Completo', '10003'),
('069', 'Geralis', 'Garrido', 'Tiempo Parcial', '10003'),
('070', 'José', 'Mendoza', 'Tiempo Completo', '10003'),
('071', 'Jeanette', 'Riley', 'Tiempo Parcial', '10003'),
('072', 'Juan', 'Saldaña', 'Tiempo Completo', '10003'),
('073', 'Gisela', 'Torres de Clunie', 'Tiempo Parcial', '10003'),
('074', 'Elba', 'Valderrama', 'Tiempo Completo', '10003'),
('075', 'María', 'Vélez', 'Tiempo Parcial', '10003'),
('076', 'Rebeca', 'Vergara', 'Tiempo Completo', '10003'),
('077', 'Nilda', 'Yangüez', 'Tiempo Parcial', '10003'),
('078', 'Germán', 'Alonso', 'Tiempo Completo', '10003'),
('079', 'Gionella', 'Araujo', 'Tiempo Parcial', '10003'),
('080', 'Gloria', 'Bennet', 'Tiempo Completo', '10003'),
('081', 'Teodolinda', 'Brinceño', 'Tiempo Parcial', '10003'),
('082', 'Sonia', 'Camarena', 'Tiempo Completo', '10003'),
('083', 'Pedro', 'Castillo', 'Tiempo Parcial', '10003'),
('084', 'Danis', 'Chiari', 'Tiempo Completo', '10003'),
('085', 'Milka', 'de Gracia', 'Tiempo Parcial', '10003'),
('086', 'María', 'De Jesús Díaz', 'Tiempo Completo', '10003'),
('087', 'Manuel', 'Estévez', 'Tiempo Parcial', '10003'),
('088', 'Belén', 'González', 'Tiempo Completo', '10003'),
('089', 'Elida', 'González', 'Tiempo Parcial', '10003'),
('090', 'Elisleila', 'González', 'Tiempo Completo', '10003'),
('091', 'José', 'González', 'Tiempo Parcial', '10003'),
('092', 'Serafina', 'González', 'Tiempo Completo', '10003'),
('093', 'José', 'Grimaldo', 'Tiempo Parcial', '10003'),
('094', 'Nadia', 'Lee', 'Tiempo Completo', '10003'),
('095', 'Thelma', 'López', 'Tiempo Parcial', '10003'),
('096', 'Andrés', 'Miranda', 'Tiempo Completo', '10003'),
('097', 'Mitzi', 'Miranda', 'Tiempo Parcial', '10003'),
('098', 'Maritza', 'Morales', 'Tiempo Completo', '10003'),
('099', 'Sidia', 'Moreno', 'Tiempo Parcial', '10003'),
('100', 'Yuraisma', 'Moreno', 'Tiempo Completo', '10003'),
('101', 'Modul', 'Nunehar', 'Tiempo Parcial', '10004'),
('102', 'Carmen', 'Ortega', 'Tiempo Completo', '10004'),
('103', 'Yamileth', 'Quezada', 'Tiempo Parcial', '10004'),
('104', 'Ericka', 'Quintero', 'Tiempo Completo', '10004'),
('105', 'Hilda', 'Quiróz', 'Tiempo Parcial', '10004'),
('106', 'Liliana', 'Reyes', 'Tiempo Completo', '10004'),
('107', 'Celsa', 'Sánchez', 'Tiempo Parcial', '10004'),
('108', 'Ensy', 'Santamaría de Tello', 'Tiempo Completo', '10004'),
('109', 'Eduardo', 'Snape', 'Tiempo Parcial', '10004'),
('110', 'Lineth', 'Tristán', 'Tiempo Completo', '10004'),
('111', 'Julio', 'Urriola', 'Tiempo Parcial', '10004'),
('112', 'Domingo', 'Villagra', 'Tiempo Completo', '10004'),
('113', 'Janitza', 'Barraza de Justiniani', 'Tiempo Parcial', '10004'),
('114', 'Felicita', 'Castillo de Krol', 'Tiempo Completo', '10004'),
('115', 'José', 'Chirú', 'Tiempo Parcial', '10004'),
('116', 'Ludia', 'Gómez', 'Tiempo Completo', '10004'),
('117', 'Giankaris', 'Moreno', 'Tiempo Parcial', '10004'),
('118', 'Paulo', 'Picota', 'Tiempo Completo', '10004'),
('119', 'Kexy', 'Rodríguez', 'Tiempo Parcial', '10004'),
('120', 'Marlina', 'Sánchez', 'Tiempo Completo', '10004'),
('121', 'Mitzi', 'de Velásquez', 'Tiempo Parcial', '10004'),
('122', 'Rodrigo', 'Yángüez', 'Tiempo Completo', '10004'),
('123', 'Juan', 'Zamora', 'Tiempo Parcial', '10004'),
('124', 'Manuel', 'Adames', 'Tiempo Completo', '10004'),
('125', 'Erick', 'Agrazal', 'Tiempo Parcial', '10004'),
('126', 'Anna', 'Araba de Ruiz', 'Tiempo Completo', '10004'),
('127', 'Emilio', 'Batista', 'Tiempo Parcial', '10004'),
('128', 'Biel', 'Bernal', 'Tiempo Completo', '10004'),
('129', 'Nelson', 'Carrizo', 'Tiempo Parcial', '10004'),
('130', 'Ricardo', 'Chan', 'Tiempo Completo', '10004'),
('131', 'Miguel', 'Díaz', 'Tiempo Parcial', '10004'),
('132', 'Cindy', 'Esquivel', 'Tiempo Completo', '10004'),
('133', 'Irving', 'Ferguson', 'Tiempo Parcial', '10004'),
('134', 'Leonardo', 'Fields', 'Tiempo Completo', '10004'),
('135', 'Eduardo', 'Griffith', 'Tiempo Parcial', '10004'),
('136', 'Joice', 'Guerra', 'Tiempo Completo', '10004'),
('137', 'Lourdes', 'Jaramillo', 'Tiempo Parcial', '10004'),
('138', 'Jaime', 'Pérez', 'Tiempo Completo', '10004'),
('139', 'Regis', 'Rivera', 'Tiempo Parcial', '10004'),
('140', 'Reinel', 'Rodríguez', 'Tiempo Completo', '10004'),
('141', 'Giovani', 'Sánchez', 'Tiempo Parcial', '10004'),
('142', 'Migdalia', 'Testa', 'Tiempo Completo', '10004'),
('143', 'Miriam', 'de Trujillo', 'Tiempo Parcial', '10004'),
('144', 'Giselle', 'Ulloa', 'Tiempo Completo', '10004'),
('145', 'Julián', 'Velásquez', 'Tiempo Parcial', '10004'),
('146', 'Jayguer', 'Vásquez', 'Tiempo Completo', '10004'),
('147', 'Yasmina', 'Villarreal', 'Tiempo Parcial', '10004'),
('148', 'Julio', 'Vivero', 'Tiempo Completo', '10004'),
('149', 'Darling', 'Zelaya', 'Tiempo Parcial', '10004'),
('150', 'Dilsa E.', 'Vergara D.', 'Tiempo Completo', '10004'),
('151', 'Henry', 'Lezcano', 'Tiempo Parcial', '10005'),
('152', 'Iván', 'Ho', 'Tiempo Completo', '10005'),
('153', 'Jeannette', 'Johnson de Herrera', 'Tiempo Parcial', '10005'),
('154', 'Jeremías', 'Herrera', 'Tiempo Completo', '10005'),
('155', 'José', 'Moreno', 'Tiempo Parcial', '10005'),
('156', 'Laila', 'Vargas de Fuertes', 'Tiempo Completo', '10005'),
('157', 'Ramfis', 'Miguelena L.', 'Tiempo Parcial', '10005'),
('158', 'Víctor A.', 'Fuentes T.', 'Tiempo Completo', '10005'),
('159', 'Víctor', 'López C.', 'Tiempo Parcial', '10005'),
('160', 'Walter', 'Bonilla', 'Tiempo Completo', '10005'),
('161', 'Aldo', 'Afranchi', 'Tiempo Parcial', '10005'),
('162', 'Alexis', 'Moscote', 'Tiempo Completo', '10005'),
('163', 'Amilkar', 'Herrera', 'Tiempo Parcial', '10005'),
('164', 'Ángela', 'Almengor de Chanis', 'Tiempo Completo', '10005'),
('165', 'Ariadne', 'Jaén', 'Tiempo Parcial', '10005'),
('166', 'Arturo', 'Murillo', 'Tiempo Completo', '10005'),
('167', 'Carlos', 'Bermúdez', 'Tiempo Parcial', '10005'),
('168', 'Carlos', 'Díaz', 'Tiempo Completo', '10005'),
('169', 'Erika', 'Quintero', 'Tiempo Parcial', '10005'),
('170', 'Giselle', 'Ballesteros de Franco', 'Tiempo Completo', '10005'),
('171', 'Iván', 'Clarence', 'Tiempo Parcial', '10005'),
('172', 'José A.', 'Jiménez', 'Tiempo Completo', '10005'),
('173', 'José', 'McLean', 'Tiempo Parcial', '10005'),
('174', 'José', 'Ortiz', 'Tiempo Completo', '10005'),
('175', 'Juan', 'Mariñas', 'Tiempo Parcial', '10005'),
('176', 'Luis', 'Martínez', 'Tiempo Completo', '10005'),
('177', 'Marelisa', 'Saldarriaga', 'Tiempo Parcial', '10005'),
('178', 'María', 'Díaz', 'Tiempo Completo', '10005'),
('179', 'Maylín', 'Chérigo', 'Tiempo Parcial', '10005'),
('180', 'Omaira', 'Ruiloba', 'Tiempo Completo', '10005'),
('181', 'Roger', 'Zambrano', 'Tiempo Parcial', '10005'),
('182', 'Stephanie', 'Sánchez', 'Tiempo Completo', '10005')


	                      SELECT * FROM Profesor  


delete Proyecto
alter table proyecto
nocheck constraint fech_entrega_ck
alter table proyecto
nocheck constraint f_verifica_ck
alter table proyecto
nocheck constraint f_evalua_ck
alter table proyecto
nocheck constraint f_Aprobacion_ck
alter table proyecto
nocheck constraint f_sustentacion_ck

INSERT INTO Proyecto (Cod_proyecto, Titulo_proyecto, cod_profesor,Fecha_entrega, Fecha_verificacion, Fecha_evaluacion, Fecha_aprobacion,Fecha_sustentacion, Tipo_Proyecto)
VALUES
    ('TT-2021-0001', 'Marketing de contenidos: Uberflip', '001', '2021-01-10', '2021-01-11', '2021-01-12', '2021-01-15', '2021-11-23', 'TT'),
    ('TP-2021-0002', 'Generación de contenidos: Articoolo', '002', '2021-03-11', '2021-03-25', '2021-03-26', '2021-02-28', '2021-12-01', 'TP'),
    ('PP-2022-0003', 'Generación de contenidos: Buzzsumo', '003', '2022-02-11', '2022-02-11', '2022-02-12', '2022-02-17', '2022-10-20', 'PP'),
    ('TT-2022-0004', 'Generación de contenidos: Jasper', '004', '2022-08-11', '2022-08-25', '2022-08-29', '2022-08-28', '2022-12-01', 'TT'),
    ('TP-2022-0005', 'Creación de contenidos: Concured', '001', '2022-09-01', '2022-09-10', '2022-09-10', '2022-09-15', '2022-12-01', 'TP'),
    ('PP-2023-0006', 'Redes sociales: Cortex', '002', '2023-02-01', '2023-02-02', '2023-02-05', '2023-02-05', '2023-12-01', 'PP'),
    ('TT-2023-0007', 'Email marketing: Phrasee', '003', '2023-03-01', '2023-03-02', '2023-03-05', '2023-03-05', '2023-10-15', 'TT'),
    ('PP-2023-0008', 'Email marketing: Persado', '004', '2023-03-10', '2023-03-11', '2023-03-11', '2023-03-12', '2023-08-15', 'PP'),
    ('PP-2023-0009', 'Publicidad online: Adext AI', '005', '2023-04-09', '2023-04-09', '2023-04-10', '2023-04-10', NULL, 'PP'),
    ('TT-2023-0010', 'Generación de clientes potenciales: Node', '006', '2023-05-09', '2023-05-09', '2023-05-15', '2023-05-15', NULL, 'TT'),
    ('PP-2023-0011', 'Videomarketing y redes sociales: Lumen5', '007', '2023-06-03', '2023-06-05', '2023-06-05', '2023-06-15', NULL, 'PP'),
    ('PP-2023-0012', 'Chatbots: Liveperson', '001', '2023-06-09', '2023-06-09', '2023-06-15', '2023-06-15', NULL, 'PP'),
    ('TT-2023-0013', 'Desarrollo web: Wix ADI', '002', '2023-07-11', '2023-07-12', '2023-07-12', '2023-07-14', NULL, 'TT'),
    ('TP-2023-0014', 'Toma de decisiones: RapidMiner', '003', '2023-09-30', '2023-09-30', '2023-09-30', '2023-10-01', NULL, 'TP'),
    ('PP-2023-0015', 'Alineamiento de contenido: Acrolinx', '004', '2023-10-20', '2023-10-20', '2023-10-21', '2023-10-21', NULL, 'PP'),
    ('TT-2023-0016', 'Influencers: IMAI', '005', '2023-11-22', '2023-11-23', '2023-11-23', NULL, NULL, 'TT'),
    ('PP-2023-0017', 'Email marketing: Seventh Sense', '006', '2023-12-01', '2023-12-01', '2023-12-02', NULL, NULL, 'PP'),
    ('PP-2023-0018', 'Aprendizaje Automático y IA.', '007', '2023-12-01', '2023-12-01', '2023-12-02', NULL, NULL, 'PP'),
    ('TT-2023-0019', 'Desarrollo en la Nube.', '008', '2023-12-02', '2023-12-02', '2023-12-04', NULL, NULL, 'TT'),
    ('TP-2023-0020', 'Programación en tiempo real.', '009', '2023-12-02', '2023-12-02', '2023-12-04', NULL, NULL, 'TP'),
    ('PP-2023-0021', 'Aplicaciones Móviles.', '002', '2023-12-02', '2023-12-02', NULL, NULL, NULL, 'PP'),
    ('TT-2023-0022', 'Realidad Virtual y Aumentada.', '003', '2023-12-02', '2023-12-02', NULL, NULL, NULL, 'TT'),
    ('TP-2023-0023', 'Criptomonedas y Blockchain.', '004', '2023-12-03', '2023-12-03', NULL,NULL,NULL,'TP'),
	('PP-2023-0024', 'Desallorro de microservicios', '005', '04-12-2023', NULL, NULL,NULL,NULL,'PP'),
	('TT-2023-0025', 'Programacion Edge Computing', '006', '5-12-2023',NULL, NULL,NULL,NULL,'TT')

	
	 
	                                 SELECT * FROM PROYECTO

	--Inserción de datos en la tabla Practica_profesional 
INSERT INTO Practica_profesional (Cod_proyecto, Cod_supervisor)
VALUES
    ('PP-2022-0003', '1000'),
    ('PP-2023-0006', '1004'),
    ('PP-2023-0008', '1003'),
    ('PP-2023-0009', '1002'),
    ('PP-2023-0011', '1005'),
    ('PP-2023-0012', '1003'),
    ('PP-2023-0015', '1000'),
    ('PP-2023-0017', '1006'),
    ('PP-2023-0018', '1002'),
    ('PP-2023-0021', '1008'),
    ('PP-2023-0024', '1007');


    
   SELECT *FROM Practica_profesional 
    
	-- Inserción de datos en la tabla Proyecto_profesor_sustenta
INSERT INTO Proyecto_profesor_sustenta (Cod_Profesor, Cod_proyecto, Lugar, Nota_asignada)
VALUES
    ('001', 'PP-2022-0003', 'Lab01', '85.5'),
    ('002', 'PP-2023-0006', 'SL03', '72.8'),
    ('003', 'PP-2023-0008', 'Lab05', '94.2'),
    ('004', 'TP-2021-0002', 'SL07', '68.9'),
    ('005', 'TP-2022-0005', 'Lab02', '76.3'),
    ('006', 'TT-2021-0001', 'SL09', '89.1'),
    ('007', 'TT-2022-0004', 'Lab04', '62.7'),
    ('008', 'TT-2023-0007', 'SL01', '78.4')
    

   

	                          SELECT * FROM Proyecto_profesor_sustenta

	-- Inserción de datos adicionales en la tabla Carrera
INSERT INTO Carrera (Cod_carrera, Nombre_carrera, Cod_depto)
VALUES
    ('001', 'Licenciatura en Ingeniería de Sistemas de Información',' 10001'),
    ('002', 'Licenciatura en Ingeniería de Sistemas de Información Gerencial', '10001'),
    ('003', 'Licenciatura en Ingeniería de Sistemas y Computación', '10001'),
    ('004', 'Licenciatura en Ingeniería de Software',' 10002'),
    ('005', 'Licenciatura en Ciberseguridad',' 10002'),
    ('006', 'Licenciatura en Ciencias de la Computación',' 10002'),
    ('007', 'Licenciatura en Desarrollo y Gestión de Software','10003'),
    ('008', 'Licenciatura en Informática Aplicada a la Educación', '10003'),
    ('009', 'Licenciatura en Redes Informáticas', '10004'),
    ('010', 'Técnico en Informática para la Gestión Empresarial', '10004'),
    ('011', 'Licenciatura en Ingeniería en Administración de Proyectos de Construcción', '10005'),
    ('012', 'Licenciatura en Ingeniería Ambiental', '10005')
    
	

	                          SELECT * FROM Carrera


-- Inserción de datos en la tabla Estudiante
INSERT INTO Estudiante (Cedula, Pri_nom, Seg_nom, Pri_apellido, Seg_apellido, Año_cursa, Semestre, Indice, Cod_proyecto, Cod_carrera, Cod_sede)
VALUES
    ('10-0001-0000', 'Maria', 'Carine', 'Anders', 'Schmitt', '4', '1', '2', 'TT-2021-0001', '001', '001'),
    ('01-0001-0001', 'Ana', 'Paola', 'Trujillo', 'Accorti', '5', '1', '2.5', 'TP-2021-0002', '002', '002'),
    ('08-0003-3333', 'Pedro', 'Paul', 'Piñones', 'López', '5', '1', '2', 'TP-2021-0002', '003', '003'),
    ('07-0001-0002', 'Antonio', 'Lino', 'Moreno', 'Rodriguez', '4', '1', '2.7', 'PP-2022-0003', '004', '004'),
    ('08-0001-0003', 'Thomas', 'Eduardo', 'Pinilla', 'Saavedra', '5', '1', '2', 'TT-2022-0004', '005', '005'),
    ('01-0001-0004', 'Christina', 'Johana', 'Torres', 'Pedro', '5', '1', '1.5', 'TP-2022-0005', '006', '006'),
    ('04-0001-0005', 'Hanna', 'Andrea', 'Moos', 'Fonseca', '4', '2', '2', 'PP-2023-0006', '007', '007'),
    ('02-0001-0006', 'Federico', 'Manuel', 'Vergara', 'Espino', '4', '2', '2.5', 'TT-2023-0007', '008', '008'),
    ('03-0001-0007', 'Martín', 'Erasmo', 'Perez', 'Pereira', '5', '2', '2.7', 'PP-2023-0008', '009', '009'),
    ('05-0001-0008', 'Laurence', 'Mario', 'Meneses', 'Pontes', '5', '2', '2.2', 'PP-2023-0009', '010', '010'),
    ('10-0001-1111', 'Miguel', 'Nando', 'Barahona', 'Park', '5', '2', '1.5', 'TT-2023-0010', '011', '001'),
    ('08-0001-0009', 'Carla', 'Elizabeth', 'Lincoln', 'Hernández', '5',' 1', '1.5', 'TT-2023-0010', '012', '002'),
    ('10-0001-0010', 'Victoria', 'Yoshi', 'Gonzalez', 'López', '5', '1', '1.9', 'PP-2023-0011', '001', '003'),
    ('20-0001-0011', 'Patricio', 'Ernesto', 'Simpson', 'Salado', '5', '1', '1', 'PP-2023-0012', '002', '004'),
    ('01-0001-0012', 'Francisco', 'José', 'Chang', 'Bennett',' 5', '1', '1.8', 'TT-2023-0013', '003', '005'),
    ('12-0001-0013', 'Yang', 'Philip', 'Wang', 'Céspedes','4', '1', '1.3', 'TP-2023-0014', '004', '006'),
    ('01-0001-0014', 'Pedro', 'Daniel', 'Afonso', 'Tonini', '4', '1', '1.7', 'PP-2023-0015', '005', '007'),
    ('02-0001-0015', 'Elizabeth', 'Annette', 'Brown', 'NuLL',NULL,NULL,NULL,NULL,NULL,NULL)
    


	    SELECT * FROM Estudiante


	-- Inserción de datos en la tabla Telf_Estud
INSERT INTO Telf_Estud (Cedula, Telefono)
VALUES
    ('01-0001-0001', '6727-2826'),
    ('01-0001-0004', '6901-7534'),
    ('01-0001-0012', '6345-2345'),
    ('01-0001-0014', '6578-1234'),
    ('02-0001-0006', '6830-3245'),
    ('02-0001-0015', '6109-4321'),
    ('03-0001-0007', '6654-5678'),
    ('04-0001-0005', '6789-4562'),
    ('05-0001-0008', '6123-9012'),
    ('07-0001-0002', '6234-7890'),
    ('08-0001-0003', '6345-2345'),
    ('08-0001-0009', '6578-1234'),
    ('08-0003-3333', '6727-2826'),
    ('10-0001-0000', '6789-4562'),
    ('10-0001-0010', '6345-2345'),
    ('10-0001-1111', '6727-2826'),
    ('12-0001-0013', '6109-4321'),
    ('20-0001-0011', '6234-7890')
    
	Select * from Telf_Estud


	-- Inserción de datos en la tabla Correo_estud
INSERT INTO Correo_estud (Cedula, Correo)
VALUES
('01-0001-0001', 'ana.trujillo@utp.ac.pa'),
('01-0001-0004', 'christina.torres@utp.ac.pa'),
('01-0001-0012', 'francisco.chang@utp.ac.pa'),
('01-0001-0014', 'pedro.afonso@utp.ac.pa'),
('02-0001-0006', 'federico.vergara@utp.ac.pa'),
('02-0001-0015', 'elizabeth.brown@utp.ac.pa'),
('03-0001-0007', 'martin.perez@utp.ac.pa'),
('04-0001-0005', 'hanna.moos@utp.ac.pa'),
('05-0001-0008', 'laurence.meneses@utp.ac.pa'),
('07-0001-0002', 'antonio.moreno@utp.ac.pa'),
('08-0001-0003', 'thomas.pinilla@utp.ac.pa'),
('08-0001-0009', 'carla.lincoln@utp.ac.pa'),
('08-0003-3333', 'pedro.pinones@utp.ac.pa'),
('10-0001-0000', 'maria.anders@utp.ac.pa'),
('10-0001-0010', 'victoria.gonzalez@utp.ac.pa'),
('10-0001-1111', 'miguel.barahona@utp.ac.pa'),
('12-0001-0013', 'yang.wang@utp.ac.pa'),
('20-0001-0011', 'patricio.simpson@utp.ac.pa');


  SELECT * from Correo_estud


  -- Insertar datos en la tabla Evaluacion
INSERT INTO Evaluacion (Cod_proyecto, Fecha_evaluación, Evaluacion)
VALUES
    ('TT-2021-0001', '2021-01-11', '95'),
    ('TP-2021-0002', '2021-03-25',' 87'),
    ('PP-2022-0003', '2022-02-11', '92'),
    ('TT-2022-0004', '2022-08-25', '89'),
    ('TP-2022-0005', '2022-09-10', '88'),
    ('PP-2023-0006', '2023-02-02', '94'),
    ('TT-2023-0007', '2023-03-02', '96'),
    ('PP-2023-0008', '2023-03-11', '91');

	SELECT * FROM Evaluacion

	----------------------------------------


	-- Insertar datos en la tabla Proyecto
INSERT INTO Proyecto (Titulo_proyecto, cod_profesor, Fecha_entrega, Fecha_verificacion, Fecha_evaluacion, Fecha_aprobacion, Fecha_sustentacion, Tipo_Proyecto)
VALUES
    ('Software de Enseñanza', '051', '2023-02-04', '2023-04-20', '2023-05-15', '2023-06-10', '2023-10-03', 'TT');

	SELECT * FROM PROYECTO


INSERT INTO Proyecto (Titulo_proyecto, cod_profesor, Fecha_entrega, Fecha_verificacion, Fecha_evaluacion, Fecha_aprobacion, Fecha_sustentacion, Tipo_Proyecto)
VALUES
    ('BD de conocimiento', '012', '2023-01-01', '2023-01-15', '2023-02-01', '2023-02-15', '2023-03-01', 'PP');
