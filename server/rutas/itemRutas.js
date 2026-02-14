import express from "express";
import Usuario from "../modelos/usuarios.js";
import bcrypt from "bcryptjs";
import { inngest } from "../inngest/funciones.js";
import Actividades from "../modelos/actividad.js";
import { RegistroSchema } from "../validaciones/autenticacion.js";

// 200 -> Petición correcta
// 201 -> Creación correcta
// 400 -> Error en cliente
// 500 -> Error en servidor

const router = express.Router();

// Ruta de registro
router.post("/registro", async (req, res) => {
  const validacion = RegistroSchema.safeParse(req.body); // Safeparse para recibir booleano como respuesta y evitar try/cath

  if (!validacion.success) {
    // Si los datos no cumplen con el formato envíamos error de cliente al front
    return res.status(400).json({
      message: "Datos de registro inválidos",
      errors: formatZodErrors(validacion.error),
    });
  }

  try {
    const { nombreUsuario, correoUsuario, contrasenhaUsuario } = req.body;

    // Comprobación de usuario existente
    const usuarioExistente = await Usuario.findOne({ correoUsuario });
    if (usuarioExistente)
      return res
        .status(400)
        .json({ message: "Ya hay un usuario registrado con ese correo." });

    // Contraseña encriptada
    const salt = await bcrypt.genSalt(10); // Salificacion de contraseña
    const hashedPassword = await bcrypt.hash(contrasenhaUsuario, salt); // Hasheo de contraseña + sal única

    const nuevoUsuario = new Usuario({
      nombreUsuario,
      correoUsuario,
      contrasenhaUsuario: hashedPassword,
    });

    await nuevoUsuario.save();
    res.status(201).json({ message: "Usuario creado con éxito" });
    console.log(`Usuario registrado: ${nombreUsuario}`);

    // Enviar evento a Inngest
    inngest
      .send({
        name: "app/usuario.registrado",
        data: { nombreUsuario, correoUsuario },
      })
      .catch((err) => console.error("Error enviando a Inngest:", err));
  } catch (error) {
    res.status(500).json({ message: "Error en el servidor" });
  }
});

// Ruta para crear usuarios
router.post("/login", async (req, res) => {
  const validacion = LoginSchema.safeParse(req.body);

  if (!validacion.success) {
    // Si los datos no cumplen con el formato envíamos error de cliente al front
    return res.status(400).json({
      message: "Datos de acceso inválidos",
      errors: formatZodErrors(validacion.error),
    });
  }

  try {
    const { correoUsuario, contrasenhaUsuario } = req.body;

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

    console.log(`Login exitoso: ${usuario.nombreUsuario}`);
    res.json({
      message: "Inicio de sesión correcto",
      user: {
        id: usuario._id,
        nombre: usuario.nombreUsuario,
        correo: usuario.correoUsuario,
        fechaCreacion: usuario.fechaRegistro,
        administrador: usuario.administrador,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Error al iniciar sesión" });
  }
});

// Ruta para añadir actividades
router.post("/actividades", async (req, res) => {
  try {
    const nuevaActividad = new Actividades(req.body);
    await nuevaActividad.save();
    res
      .status(201)
      .json({ message: "Actividad creada correctamente", nuevaActividad });
  } catch {
    res.status(400).json({ error: error.message });
  }
});

export default router;