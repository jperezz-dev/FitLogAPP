# Implementación de Seguridad (Bcrypt & JWT) a FitLog App:

Para la seguridad de las credenciales y la gestión de sesiones de los usuarios, he implementado una combinación de Bcrypt y JSON Web Token (JWT) en el backend. Esta arquitectura permite proteger las contraseñas en la base de datos y manejar la autenticación de forma segura mediante tokens almacenados en memoria.

## Proceso de implementación de Bcrypt:

### Instalación de paquetes:

Para gestionar el cifrado de las contraseñas en el servidor Express, es necesario instalar la librería bcryptjs:

`npm install bcryptjs`

### Configuración en el Modelo de Usuario:

En el modelo de datos de MongoDB, la contraseña se define como un String obligatorio. Gracias a Bcrypt, este campo nunca contendrá la contraseña real, sino una representación cifrada irreversible.

### Hasheo en el Registro de Usuarios:

En la ruta de registro, antes de guardar el usuario en la base de datos, realizo el proceso de cifrado. Utilizo un "salt" (salificación) para añadir una capa extra de seguridad, asegurando que incluso contraseñas iguales tengan hashes diferentes:

```
    // Contraseña encriptada
    const salt = await bcrypt.genSalt(10); // Salificacion de contraseña
    const hashedPassword = await bcrypt.hash(contrasenhaUsuario, salt); // Hasheo de contraseña + sal única

    const nuevoUsuario = new Usuario({
      nombreUsuario,
      correoUsuario,
      contrasenhaUsuario: hashedPassword,
    });
```

### Verificación en el Login:

Para el inicio de sesión, Bcrypt permite comparar la contraseña introducida por el usuario con el hash almacenado en la base de datos sin necesidad de descifrarla:

```
    // Busca usuario
    const usuario = await Usuario.findOne({ correoUsuario });
    if (!usuario)
      return res.status(400).json({ message: "Usuario inexistente" });

    // Compara contraseñas
    const isMatch = await bcrypt.compare(
      contrasenhaUsuario,
      usuario.contrasenhaUsuario,
    );
    if (!isMatch)
      return res.status(400).json({ message: "Contraseña incorrecta" });
```

## Implementación de JSON Web Token (JWT):

Una vez que la identidad del usuario es verificada mediante Bcrypt, es necesario mantener la sesión activa sin solicitar las credenciales en cada petición. Para ello, he implementado JWT para generar tokens firmados por el servidor.

### Instalación de paquetes:

`npm install jsonwebtoken`

### Generación del Token en el Login:

Tras el login, el servidor genera un token que contiene información no sensible del usuario (como su ID y permiso) y lo firma con una clave secreta privada. Este token tiene una validez estipulada en el .env (En este caso 24h):

```
    // Generación del token
    const token = jwt.sign(
      { id: usuario._id, admin: usuario.administrador },
      process.env.JWT_ACCESS_SECRET,
      { expiresIn: process.env.JWT_ACCESS_EXPIRES_IN }
    );

    console.log(`Login exitoso: ${usuario.nombreUsuario}`);
    res.json({
      message: "Inicio de sesión correcto",
      token: token,
      user: {
        id: usuario._id,
        nombre: usuario.nombreUsuario,
        correo: usuario.correoUsuario,
        fechaCreacion: usuario.fechaRegistro,
        administrador: usuario.administrador,
      },
    });
```