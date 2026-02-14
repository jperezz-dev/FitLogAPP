# Implementación de zod a FitLog App:

Para la validación de datos en el backend, he implementado Zod para permitirme definir esquemas para los datos que recibo tanto de la aplicación móvil (Flutter) como de la aplicación de escritorio (Vue), asegurando que la información sea correcta antes de interactuar con la base de datos MongoDB.

## Proceso de implementación de inngest:

### Instalación de paquetes:

Para integrar las validaciones en mi servidor Express, solo es necesario instalar el paquete core de Zod:

`npm install zod`

### Creación de los esquemas de validación::

He creado un archivo centralizado para validar los datos de los usuario:

```
const { z } = require("zod")

import { z } from "zod";

// Esquema del registro
export const RegistroSchema = z.object({
  nombreUsuario: z
    .string()
    .min(3, "El nombre debe tener al menos 3 caracteres")
    .max(20, "El nombre es demasiado largo"),
  correoUsuario: z
    .string()
    .email("Formato de correo inválido"),
  contrasenhaUsuario: z
    .string()
    .min(6, "La contraseña debe tener al menos 6 caracteres"),
});

// Esquema login
export const LoginSchema = z.object({
  correoUsuario: z.string().email("Correo inválido"),
  contrasenhaUsuario: z.string().min(1, "La contraseña es requerida"),
});

// Formatear errores
export function formatZodErrors(error) {
  return error.issues.map((issue) => ({
    campo: issue.path.join("."),
    mensaje: issue.message,
  }));
}
```

### Aplicación en las rutas de Express:

En el archivo de rutas, utilizo el método safeParse para validar el cuerpo de la petición. Si la validación falla, devuelvo un código de estado 400 (Error de cliente) con los errores detallados:

```
  const validacion = RegistroSchema.safeParse(req.body); // Safeparse para recibir booleano como respuesta y evitar try/cath

  if (!validacion.success) {
    // Si los datos no cumplen con el formato envíamos error de cliente al front
    return res.status(400).json({
      message: "Datos de registro inválidos",
      errors: formatZodErrors(validacion.error),
    });
  }
```

```
  const validacion = LoginSchema.safeParse(req.body);

  if (!validacion.success) {
    // Si los datos no cumplen con el formato envíamos error de cliente al front
    return res.status(400).json({
      message: "Datos de acceso inválidos",
      errors: formatZodErrors(validacion.error),
    });
  }
```