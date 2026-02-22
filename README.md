# FitLog App

FitLog App es la extensión móvil de tu gimnasio, diseñada para que tanto socios como administradores gestionen su actividad diaria desde la palma de la mano. Desarrollada con Flutter, ofrece una experiencia fluida, rápida y con un diseño moderno en "Modo Oscuro" con toques naranja cálido.

## Características:

- **Listado de actividades y clases:** Consulta la lista de clases disponibles de cada actividad existente en el gimnasio a traves de una interfaz cómoda y limpia.
- **Sistema de reservas:** Reserva plazas en clases desde la aplicación, el sistema evita las reservas duplicadas y permite gestionar (Cancelar) tus reservas existentes.
- **Perfil:** Consulta tus datos de usuarios desde el apartado de "Perfil", donde además puedes consultar tu histórico de reservas.
- **Selección de fecha y hora:** Selección de fecha y hora a traves de widgets completamente personalizados para la aplicación manteniendo el estilo y la paleta de colores.
- **Cancelación tardía:** Si cancelas una clase a 15 minutos de su inicio la plaza no se libera, como si ocurre con las cancelaciones normales.
- **Panel de administración:** Los usuarios con rol de administrador tienen acceso a un panel especial donde crear y modificar actividades.
- **Validación de datos:** Los datos se validan en el backend a empleando ZOD.

## Flujo de datos:

La aplicación utiliza un sistema de rutas de Flutter que gestiona el estado de la navegación, permitiendo retroceder de forma segura y limpiar el historial de rutas durante el Cierre de Sesión (Logout) para evitar accesos no autorizados.

## Tecnologías utilizadas:

- **Framework Frontend:** Flutter (Dart)
- **Backend:** Node.js / Express
- **Base de Datos:** MongoDB (Mongoose)
- **Gestión de Estado:** Patrón Singleton para sesiones y manejo de estados nativos.
- **Comunicación:** Protocolo HTTP con interceptación de tokens JWT.

## Imágenes en ejecución:

## Instalación y ejecución:

Para poner en marcha la aplicación, sigue estos pasos:

### Requisitos Previos
Flutter SDK instalado y configurado en tu máquina.

Node.js y MongoDB instalados para el funcionamiento del backend.

Un emulador (Android/iOS) o un dispositivo físico conectado.

### Configuración del Backend

1. Navega a la carpeta "server"

2. Instala las dependencias: `npm install`

3. Configura el .env siguiendo el siguiente ejemplo:

```
// Mongo
MONGO_URI=
PORT=
// Ingest
EMAIL_USER=
EMAIL_PASS=
// JWT
JWT_ACCESS_SECRET=
JWT_ACCESS_EXPIRES_IN=
```

4. Asegúrate de que tu base de datos MongoDB esté activa.

5. Inicia el servidor de express e ingest: `npm run dev`