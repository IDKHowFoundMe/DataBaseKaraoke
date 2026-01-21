# 🎤 DataBaseKaraoke – Proyecto de Base de Datos (MySQL)

## 📌 Descripción general
Este proyecto implementa una base de datos relacional en **MySQL** para la gestión de un sistema de karaoke.  
El modelo permite administrar información relacionada con **artistas, agrupaciones, canciones, álbumes y géneros musicales**, incluyendo relaciones de muchos a muchos y mecanismos avanzados de base de datos.

El proyecto fue desarrollado y probado utilizando **MySQL** y **DataGrip**, cumpliendo con los requisitos académicos de creación y ejecución de **vistas, funciones, procedimientos almacenados y triggers**.

---

## 🧱 Modelo de Datos
La base de datos está compuesta por las siguientes entidades principales:

- **ARTISTA**: Información de artistas solistas.
- **AGRUPACION**: Bandas o grupos musicales.
- **ALBUM**: Álbumes musicales con su año de lanzamiento.
- **CANCION**: Canciones asociadas a álbumes y géneros.
- **GENERO**: Tipos de género musical.

### Tablas intermedias
- **CANCION_ARTISTA**: Relación muchos a muchos entre canciones y artistas.
- **ARTISTA_AGRUPACION**: Relación muchos a muchos entre artistas y agrupaciones.

---

## 👁️ Vistas (Views)
El proyecto incluye **tres vistas**, cuyo objetivo es facilitar consultas complejas y reutilizables:

1. **vw_canciones_detalle**  
   Muestra el detalle completo de cada canción incluyendo su artista, álbum, año y género.

2. **vw_artistas_cantidad_canciones**  
   Presenta el número total de canciones grabadas por cada artista.

3. **vw_agrupaciones_integrantes**  
   Lista las agrupaciones musicales junto con la cantidad de integrantes que poseen.

---

## 🔢 Funciones
Se implementan **tres funciones**, cumpliendo con el requisito de funciones escalares y tabulares (adaptadas a MySQL):

1. **fn_canciones_por_artista**  
   Retorna la cantidad de canciones asociadas a un artista específico.

2. **fn_agrupaciones_por_artista**  
   Retorna el número de agrupaciones a las que pertenece un artista.

3. **Función tabular (implementada como procedimiento)**  
   Debido a que MySQL no soporta funciones tabulares (`RETURNS TABLE`), se implementó el comportamiento equivalente mediante un procedimiento almacenado que retorna un conjunto de registros filtrados por género.

---

## ⚙️ Procedimientos Almacenados
El sistema incluye **tres procedimientos almacenados**, al menos uno con **parámetros de entrada y funciones de agregación**:

1. **sp_resumen_artista**  
   Devuelve un resumen de un artista mostrando el total de canciones que ha grabado.

2. **sp_canciones_por_anio**  
   Lista las canciones cuyos álbumes fueron lanzados en
