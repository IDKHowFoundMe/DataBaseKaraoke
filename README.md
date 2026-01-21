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
   Lista las canciones cuyos álbumes fueron lanzados en un año específico.

3. **sp_artistas_por_pais**  
   Muestra los artistas según su país de origen.

---

## 🚨 Triggers (Disparadores)
Los triggers permiten ejecutar acciones automáticas ante eventos sobre la tabla **CANCION**, garantizando **integridad, validación y auditoría** de los datos.

### 🗂️ Tabla de Auditoría
**AUDITORIA_CANCION**  
Almacena un registro histórico de las operaciones realizadas sobre la tabla `CANCION`, incluyendo el tipo de acción y la fecha.

---

### 🔹 Trigger BEFORE INSERT – Validación
**trg_validar_letra**

- Se ejecuta **antes de insertar** una canción.
- Verifica que el campo `LETRACANCION` no sea nulo ni vacío.
- Si la validación falla, se lanza un error y se cancela la inserción.

📌 **Objetivo:**  
Garantizar la calidad e integridad de los datos almacenados.

---

### 🔹 Trigger AFTER INSERT – Auditoría
**trg_insert_cancion**

- Se ejecuta **después de insertar** una canción.
- Registra automáticamente la acción `INSERT` en la tabla de auditoría.

📌 **Objetivo:**  
Llevar un historial automático de las canciones agregadas al sistema.

---

### 🔹 Trigger AFTER DELETE – Auditoría
**trg_delete_cancion**

- Se ejecuta **después de eliminar** una canción.
- Registra automáticamente la acción `DELETE` en la tabla de auditoría.

📌 **Objetivo:**  
Mantener trazabilidad y control de eliminaciones realizadas en la base de datos.

---

## 🧪 Pruebas
Cada vista, función, procedimiento y trigger cuenta con scripts de prueba que permiten verificar su correcto funcionamiento, incluyendo:

- Inserciones válidas e inválidas.
- Eliminaciones controladas.
- Consultas a la tabla de auditoría.
- Verificación de errores lanzados por triggers de validación.

---

## 🛠️ Tecnologías utilizadas
- **MySQL**
- **DataGrip**
- **Git / GitHub**

---

## 📌 Conclusión
Este proyecto demuestra el uso de características avanzadas de bases de datos relacionales, tales como vistas, funciones, procedimientos almacenados y triggers, aplicadas a un caso realista de gestión musical.  
La implementación garantiza integridad, reutilización de consultas, automatización y trazabilidad de la información.

---

📚 *Proyecto desarrollado con fines académicos.*
