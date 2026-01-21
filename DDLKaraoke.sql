DROP DATABASE IF EXISTS databasekaraoke;
CREATE DATABASE databasekaraoke;
USE databasekaraoke;

DROP TABLE IF EXISTS CANCION_ARTISTA;
DROP TABLE IF EXISTS ARTISTA_AGRUPACION;
DROP TABLE IF EXISTS AGRUPACION;
DROP TABLE IF EXISTS ARTISTA;
DROP TABLE IF EXISTS CANCION;
DROP TABLE IF EXISTS ALBUM;
DROP TABLE IF EXISTS GENERO;

-- Notacion SQL
-- CREATE TABLE AGRUPACION (
--    "IDAGRUPACION" INTEGER PRIMARY KEY ,
--    NOMBREAGRUPACION TEXT NOT NULL
-- );

 -- Notacion MySQL

CREATE TABLE AGRUPACION (
    IDAGRUPACION INT AUTO_INCREMENT PRIMARY KEY,
    NOMBREAGRUPACION VARCHAR(100) NOT NULL
);
CREATE TABLE GENERO (
    IDGENERO INT AUTO_INCREMENT PRIMARY KEY,
    TIPOGENERO VARCHAR(100) NOT NULL
);

CREATE TABLE ALBUM (
    IDALBUM INT AUTO_INCREMENT PRIMARY KEY,
    NOMBREALBUM VARCHAR(100) NOT NULL,
    AÑOALBUM INTEGER
);

CREATE TABLE CANCION (
    IDCANCION INT AUTO_INCREMENT PRIMARY KEY,
    IDALBUM INT NOT NULL,
    IDGENERO INT NOT NULL,
    NOMBRECANCION VARCHAR(100) NOT NULL,
    LETRACANCION TEXT NOT NULL,
    FOREIGN KEY (IDALBUM) REFERENCES ALBUM(IDALBUM),
    FOREIGN KEY (IDGENERO) REFERENCES GENERO(IDGENERO)
);

CREATE TABLE ARTISTA (
    IDARTISTA INT AUTO_INCREMENT PRIMARY KEY,
    NOMBREARTISTA VARCHAR(100) NOT NULL,
    PAISARTISTA VARCHAR(100) NOT NULL,
    BIOGRAFIAARTISTA TEXT,
    TIPOARTISTA VARCHAR(100) NOT NULL
);

CREATE TABLE CANCION_ARTISTA (
    IDCANCION INT,
    IDARTISTA INT,
    PRIMARY KEY (IDCANCION, IDARTISTA),
    FOREIGN KEY (IDCANCION) REFERENCES CANCION(IDCANCION),
    FOREIGN KEY (IDARTISTA) REFERENCES ARTISTA(IDARTISTA)
);

CREATE TABLE ARTISTA_AGRUPACION (
    IDARTISTA INT,
    IDAGRUPACION INT,
    PRIMARY KEY (IDARTISTA,IDAGRUPACION),
    FOREIGN KEY (IDARTISTA) REFERENCES ARTISTA(IDARTISTA),
    FOREIGN KEY (IDAGRUPACION) REFERENCES AGRUPACION(IDAGRUPACION)
);

-- BUSQUEDAS SIMPLES

-- Lista las canciones cuyos álbumes fueron lanzados un año específico.
SELECT
    c.NOMBRECANCION,
    al.AÑOALBUM
    FROM CANCION c JOIN ALBUM al
    ON c.IDALBUM = al.IDALBUM
    WHERE al.AÑOALBUM = 2023;

-- Listar todas las agrupaciones a las que pertenece cada artista.
SELECT
    A.NOMBREARTISTA,
    G.NOMBREAGRUPACION
    FROM ARTISTA A JOIN ARTISTA_AGRUPACION AG
       ON A.IDARTISTA = AG.IDARTISTA
       JOIN AGRUPACION G ON AG.IDAGRUPACION = G.IDAGRUPACION
       ORDER BY A.NOMBREARTISTA;

-- Buscar todas las canciones cuyo nombre empiece con s
SELECT
    c.NOMBRECANCION
FROM CANCION c
WHERE c.NOMBRECANCION LIKE 's%';

-- Buscar todas las canciones de shakira con su genero y album
SELECT
    C.NOMBRECANCION,
    G.TIPOGENERO,
    AL.NOMBREALBUM
FROM CANCION C JOIN GENERO G ON C.IDGENERO = G.IDGENERO
JOIN ALBUM  AL ON C.IDALBUM = AL.IDALBUM
JOIN CANCION_ARTISTA CA on C.IDCANCION = CA.IDCANCION
JOIN ARTISTA A on CA.IDARTISTA = A.IDARTISTA
WHERE A.NOMBREARTISTA LIKE '%Residente%';

-- BUSCA CANCIONES DE REGUETON
SELECT
    C.NOMBRECANCION,
    G.TIPOGENERO
    FROM CANCION C JOIN GENERO G ON C.IDGENERO = G.IDGENERO
    WHERE G.TIPOGENERO = 'Regueton';

-- CANCIONES DE RIHANNA
SELECT
    A.NOMBREARTISTA,
    A.PAISARTISTA,
    C.NOMBRECANCION
FROM ARTISTA A JOIN CANCION_ARTISTA CA on A.IDARTISTA = CA.IDARTISTA
JOIN CANCION C on CA.IDCANCION = C.IDCANCION
WHERE NOMBREARTISTA = 'Rihanna';

-- Obtener todos los álbumes creados entre LOS años (por ejemplo 2000 y 2010).
SELECT
    AL.AÑOALBUM,
    AL.NOMBREALBUM
FROM ALBUM AL
WHERE AL.AÑOALBUM BETWEEN 2000 AND 2010
ORDER BY AÑOALBUM;

-- BUSQUEDAS AVANZADAS
-- Obtén los artistas que han pertenecido a más de una agrupación.
SELECT
    a.NOMBREARTISTA,
    COUNT(DISTINCT ag.NOMBREAGRUPACION) AS "Numero de AGRUPACIONES"
FROM ARTISTA a
JOIN ARTISTA_AGRUPACION a_a ON a.IDARTISTA = a_a.IDARTISTA
JOIN AGRUPACION ag ON ag.IDAGRUPACION = a_a.IDAGRUPACION
GROUP BY a.NOMBREARTISTA
HAVING COUNT(DISTINCT ag.NOMBREAGRUPACION) > 1;

-- Listar artistas con su nacionalidad y el número total de canciones que han grabado.
SELECT
    A.NOMBREARTISTA,
    COUNT(DISTINCT C.IDCANCION) AS CantidadCanciones
FROM ARTISTA A
JOIN CANCION_ARTISTA CA ON A.IDARTISTA = CA.IDARTISTA
JOIN CANCION C ON CA.IDCANCION = C.IDCANCION
GROUP BY A.IDARTISTA, A.NOMBREARTISTA, A.PAISARTISTA
ORDER BY A.PAISARTISTA;

-- Cantidad de artistas en cada agrupación (bandas)
SELECT
    AG.NOMBREAGRUPACION,
    COUNT(DISTINCT A.IDARTISTA)
FROM ARTISTA A JOIN ARTISTA_AGRUPACION AA on A.IDARTISTA = AA.IDARTISTA
JOIN AGRUPACION AG on AA.IDAGRUPACION = AG.IDAGRUPACION
GROUP BY AG.NOMBREAGRUPACION;

-- Géneros con más de 2 canciones almacenadas
SELECT
    G.TIPOGENERO,
    COUNT(DISTINCT C.IDCANCION) AS CANTIDADCANCIONES
    FROM CANCION C JOIN GENERO G on C.IDGENERO = G.IDGENERO
    GROUP BY G.TIPOGENERO;


-- Contar cuántos álbumes existen por año
SELECT
    A.AÑOALBUM,
    COUNT(DISTINCT A.NOMBREALBUM)
    FROM ALBUM A
    GROUP BY A.AÑOALBUM
    ORDER BY AÑOALBUM;

-- Obtén los artistas que han cantado canciones de 2 o más géneros distintos, mostrando:
SELECT
    A.NOMBREARTISTA,
    COUNT(DISTINCT  C.IDGENERO) AS NumeroGeneros
    FROM ARTISTA A JOIN CANCION_ARTISTA CA on A.IDARTISTA = CA.IDARTISTA
    JOIN CANCION C on CA.IDCANCION = C.IDCANCION
    JOIN  GENERO G on C.IDGENERO = G.IDGENERO
    GROUP BY A.NOMBREARTISTA
    HAVING NumeroGeneros >= 2
    ORDER BY NumeroGeneros DESC;


-- Genera un listado de artistas ordenado del más productivo al menos productivo,
SELECT
    A.NOMBREARTISTA,
    COUNT(DISTINCT C.IDCANCION) AS Productividad
    FROM ARTISTA A JOIN  CANCION_ARTISTA CA on A.IDARTISTA = CA.IDARTISTA
    JOIN CANCION C on CA.IDCANCION = C.IDCANCION
    GROUP BY NOMBREARTISTA
    ORDER BY Productividad DESC;
--

-- OBJETIVO:
-- Mostrar el detalle completo de las canciones incluyendo artista, álbum, año y género.

DROP VIEW IF EXISTS vw_canciones_detalle;

CREATE VIEW vw_canciones_detalle AS
SELECT
    c.IDCANCION,
    c.NOMBRECANCION,
    al.NOMBREALBUM,
    al.AÑOALBUM,
    g.TIPOGENERO,
    a.NOMBREARTISTA
FROM CANCION c
JOIN ALBUM al ON c.IDALBUM = al.IDALBUM
JOIN GENERO g ON c.IDGENERO = g.IDGENERO
JOIN CANCION_ARTISTA ca ON c.IDCANCION = ca.IDCANCION
JOIN ARTISTA a ON ca.IDARTISTA = a.IDARTISTA;

-- Ejecución de la vista
SELECT * FROM vw_canciones_detalle;

-- OBJETIVO:
-- Obtener el número total de canciones que ha grabado cada artista.

DROP VIEW IF EXISTS vw_artistas_cantidad_canciones;

CREATE VIEW vw_artistas_cantidad_canciones AS
SELECT
    a.IDARTISTA,
    a.NOMBREARTISTA,
    COUNT(ca.IDCANCION) AS TOTAL_CANCIONES
FROM ARTISTA a
LEFT JOIN CANCION_ARTISTA ca ON a.IDARTISTA = ca.IDARTISTA
GROUP BY a.IDARTISTA, a.NOMBREARTISTA;

-- Ejecución de la vista
SELECT * FROM vw_artistas_cantidad_canciones;


-- OBJETIVO:
-- Mostrar las agrupaciones musicales junto con la cantidad de integrantes que poseen.

DROP VIEW IF EXISTS vw_agrupaciones_integrantes;

CREATE VIEW vw_agrupaciones_integrantes AS
SELECT
    ag.NOMBREAGRUPACION,
    COUNT(aa.IDARTISTA) AS TOTAL_INTEGRANTES
FROM AGRUPACION ag
JOIN ARTISTA_AGRUPACION aa ON ag.IDAGRUPACION = aa.IDAGRUPACION
GROUP BY ag.NOMBREAGRUPACION;

-- Ejecución de la vista
SELECT * FROM vw_agrupaciones_integrantes;

-- OBJETIVO:
-- Calcular la cantidad total de canciones grabadas por un artista específico.

DROP FUNCTION IF EXISTS fn_canciones_por_artista;
DELIMITER $$

CREATE FUNCTION fn_canciones_por_artista(p_id_artista INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM CANCION_ARTISTA
    WHERE IDARTISTA = p_id_artista;
    RETURN total;
END$$

DELIMITER ;

-- Prueba de la función
SELECT fn_canciones_por_artista(1) AS Canciones_Adele;

-- OBJETIVO:
-- Calcular el número de agrupaciones a las que pertenece un artista.

DROP FUNCTION IF EXISTS fn_agrupaciones_por_artista;
DELIMITER $$

CREATE FUNCTION fn_agrupaciones_por_artista(p_id_artista INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM ARTISTA_AGRUPACION
    WHERE IDARTISTA = p_id_artista;
    RETURN total;
END$$

DELIMITER ;

-- Prueba de la función
SELECT fn_agrupaciones_por_artista(47) AS Agrupaciones_Shakira;


-- OBJETIVO:
-- Retornar un conjunto de canciones filtradas por género.
-- En MySQL se implementa mediante un PROCEDURE debido a que no soporta funciones tabulares.

DROP PROCEDURE IF EXISTS sp_canciones_por_genero;
DELIMITER $$

CREATE PROCEDURE sp_canciones_por_genero(IN p_genero VARCHAR(100))
BEGIN
    SELECT
        c.NOMBRECANCION,
        al.NOMBREALBUM,
        a.NOMBREARTISTA
    FROM CANCION c
    JOIN ALBUM al ON c.IDALBUM = al.IDALBUM
    JOIN GENERO g ON c.IDGENERO = g.IDGENERO
    JOIN CANCION_ARTISTA ca ON c.IDCANCION = ca.IDCANCION
    JOIN ARTISTA a ON ca.IDARTISTA = a.IDARTISTA
    WHERE g.TIPOGENERO = p_genero;
END$$

DELIMITER ;

-- Ejecución
CALL sp_canciones_por_genero('Pop');

-- OBJETIVO:
-- Obtener un resumen de un artista mostrando el total de canciones que ha grabado.

DROP PROCEDURE IF EXISTS sp_resumen_artista;
DELIMITER $$

CREATE PROCEDURE sp_resumen_artista(IN p_id_artista INT)
BEGIN
    SELECT
        a.NOMBREARTISTA,
        COUNT(ca.IDCANCION) AS TotalCanciones
    FROM ARTISTA a
    JOIN CANCION_ARTISTA ca ON a.IDARTISTA = ca.IDARTISTA
    WHERE a.IDARTISTA = p_id_artista
    GROUP BY a.NOMBREARTISTA;
END$$

DELIMITER ;

CALL sp_resumen_artista(4);

-- OBJETIVO:
-- Listar las canciones cuyos álbumes fueron lanzados en un año específico.

DROP PROCEDURE IF EXISTS sp_canciones_por_anio;
DELIMITER $$

CREATE PROCEDURE sp_canciones_por_anio(IN p_anio INT)
BEGIN
    SELECT
        c.NOMBRECANCION,
        al.AÑOALBUM
    FROM CANCION c
    JOIN ALBUM al ON c.IDALBUM = al.IDALBUM
    WHERE al.AÑOALBUM = p_anio;
END$$

DELIMITER ;

CALL sp_canciones_por_anio(2023);

-- OBJETIVO:
-- Obtener el listado de artistas según su país de origen.

DROP PROCEDURE IF EXISTS sp_artistas_por_pais;
DELIMITER $$

CREATE PROCEDURE sp_artistas_por_pais(IN p_pais VARCHAR(100))
BEGIN
    SELECT
        NOMBREARTISTA,
        TIPOARTISTA
    FROM ARTISTA
    WHERE PAISARTISTA = p_pais;
END$$

DELIMITER ;

CALL sp_artistas_por_pais('Estados Unidos');

-- OBJETIVO:
-- Almacenar un historial de las inserciones y eliminaciones realizadas
-- sobre la tabla CANCION, incluyendo la fecha.

DROP TABLE IF EXISTS AUDITORIA_CANCION;

CREATE TABLE AUDITORIA_CANCION (
    IDAUDITORIA INT AUTO_INCREMENT PRIMARY KEY,
    ACCION VARCHAR(50),
    IDCANCION INT,
    FECHA TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_insert_cancion;
DROP TRIGGER IF EXISTS trg_delete_cancion;
DROP TRIGGER IF EXISTS trg_validar_letra;


-- OBJETIVO:
-- Registrar automáticamente en la tabla de auditoría cada canción
-- que sea insertada en la tabla CANCION.

DROP TRIGGER IF EXISTS trg_insert_cancion;
DELIMITER $$

CREATE TRIGGER trg_insert_cancion
AFTER INSERT ON CANCION
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_CANCION (ACCION, IDCANCION)
    VALUES ('INSERT', NEW.IDCANCION);
END$$

DELIMITER ;

-- OBJETIVO DE LA PRUEBA:
-- Verificar que al insertar una canción se registre automáticamente
-- un evento INSERT en la tabla AUDITORIA_CANCION.

INSERT INTO CANCION (IDALBUM, IDGENERO, NOMBRECANCION, LETRACANCION)
VALUES (1, 1, 'Prueba Trigger Insert', 'Letra de prueba para auditoría');

-- Verificar resultado
SELECT *
FROM AUDITORIA_CANCION
ORDER BY FECHA DESC;

-- OBJETIVO:
-- Registrar automáticamente en la tabla de auditoría cada canción
-- que sea eliminada de la tabla CANCION.

DROP TRIGGER IF EXISTS trg_delete_cancion;
DELIMITER $$

CREATE TRIGGER trg_delete_cancion
AFTER DELETE ON CANCION
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_CANCION (ACCION, IDCANCION)
    VALUES ('DELETE', OLD.IDCANCION);
END$$

DELIMITER ;

-- OBJETIVO DE LA PRUEBA:
-- Comprobar que al eliminar una canción se registre automáticamente
-- un evento DELETE en la tabla AUDITORIA_CANCION.

-- Identificar una canción reciente
SELECT IDCANCION, NOMBRECANCION
FROM CANCION
ORDER BY IDCANCION DESC
LIMIT 1;

-- Supongamos que el IDCANCION obtenido es 150
DELETE FROM CANCION
WHERE IDCANCION = 96;

-- Verificar auditoría
SELECT *
FROM AUDITORIA_CANCION
ORDER BY FECHA DESC;

-- OBJETIVO:
-- Evitar que se inserten canciones sin letra, garantizando
-- la integridad y calidad de los datos almacenados.

DROP TRIGGER IF EXISTS trg_validar_letra;
DELIMITER $$

CREATE TRIGGER trg_validar_letra
BEFORE INSERT ON CANCION
FOR EACH ROW
BEGIN
    IF NEW.LETRACANCION IS NULL OR NEW.LETRACANCION = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La letra de la canción no puede estar vacía';
    END IF;
END$$

DELIMITER ;

-- OBJETIVO DE LA PRUEBA:
-- Verificar que el trigger impide insertar canciones sin letra.

INSERT INTO CANCION (IDALBUM, IDGENERO, NOMBRECANCION, LETRACANCION)
VALUES (1, 1, 'Canción inválida', '');


SHOW TRIGGERS LIKE 'CANCION';
