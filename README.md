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

### Ventana de login
<img width="437" height="901" alt="{2D7478E0-BF5F-48FF-96ED-8E3B4FC36629}" src="https://github.com/user-attachments/assets/fc48c62f-7f76-4aac-a6e9-a2b03132bb3b" />

### Ventana de registro
<img width="438" height="902" alt="{3ECB3CCB-3FF7-44FB-9BC1-76101C0B1760}" src="https://github.com/user-attachments/assets/d53c0ed0-a4f8-44ef-beb5-90f1b2c812c3" />

### Ventana de inicio
<img width="437" height="896" alt="{C9A92C56-BE91-44DD-82EE-7A81625C049E}" src="https://github.com/user-attachments/assets/0fcf26a2-bc0d-4817-a3a5-d1dd903fe003" />

### Ventana actividades
<img width="434" height="903" alt="{5D056E56-DB8F-4681-ABE9-EA87D5FC0B02}" src="https://github.com/user-attachments/assets/7ac8c778-06bc-4402-b6da-37bdff9d5654" />

### Ventana de reservas
<img width="442" height="909" alt="{ABF0AA25-CC9D-4C69-BF45-FB5A1EDDEE39}" src="https://github.com/user-attachments/assets/4732f656-dd96-423a-9d5b-ef24caa454c7" />

### Ventana de realizar reserva
<img width="433" height="901" alt="{C707ACE1-F349-4226-9E42-C1298CBCF977}" src="https://github.com/user-attachments/assets/19bf9bf9-8bc4-4bc9-8540-550ef545acea" />

### Ventana de perfil
<img width="442" height="903" alt="{0267755A-4CDA-48F9-9B14-0185233FDEF3}" src="https://github.com/user-attachments/assets/2b0e7793-f714-47e2-a86d-25b8dcc14b91" />

### Panel administrativo
<img width="445" height="907" alt="{025E13E0-E85B-43BA-9C98-13B918B47779}" src="https://github.com/user-attachments/assets/edf34d2b-c3ff-440e-ae49-2235c54b942c" />

### Ventana de inicio

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
