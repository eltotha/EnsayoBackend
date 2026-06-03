## Configuración del proyecto

Antes de ejecutar el proyecto, realiza los siguientes pasos:

### 1. Restaurar dependencias

Abre una terminal en la carpeta `ControlVentasAPI` y ejecuta el siguiente comando:

```bash
dotnet restore
```

### 2. Configurar la conexión a la base de datos

Ubica el archivo:

```bash
appsettings.json
```

Luego, modifica el valor de la cadena de conexión (`ConnectionString`) con los datos correspondientes de tu servidor y base de datos.

Ejemplo:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=TU_SERVIDOR;Database=TU_BASE_DE_DATOS;User Id=TU_USUARIO;Password=TU_PASSWORD;"
}
```

Después de realizar estos pasos, el proyecto estará listo para ejecutarse.
