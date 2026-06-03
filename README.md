## Configuración del proyecto

Antes de ejecutar el proyecto, realiza los siguientes pasos:

### 1. Restaurar dependencias

Abre una terminal en la carpeta `ControlVentasAPI` y ejecuta el siguiente comando:

```bash
dotnet restore
```

### 2. Configurar la conexión a la base de datos

Enel archivo:

```bash
appsettings.json
```

Modifica el valor de la cadena de conexión (`ConnectionString`) con los datos correspondientes de tu servidor y base de datos.

Ejemplo:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=TU_SERVIDOR;Database=BaseDeDatos;User Id=TuUsuario;Password=query_sql;"
}
```

Después de realizar estos pasos, el proyecto estará listo para ejecutarse.
