import express from "express";
import Usuario from "../modelos/usuarios.js";
import bcrypt from "bcryptjs";
import { inngest } from "../inngest/funciones.js";
import Actividades from "../modelos/actividad.js";
import { RegistroSchema } from "../validaciones/autenticacion.js";
import { LoginSchema } from "../validaciones/autenticacion.js";
import { formatZodErrors } from "../validaciones/autenticacion.js";
import jwt from "jsonwebtoken";

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

    // Generación del token
    const token = jwt.sign(
      { id: usuario._id, admin: usuario.administrador },
      process.env.JWT_ACCESS_SECRET,
      { expiresIn: process.env.JWT_ACCESS_EXPIRES_IN },
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

// Ruta de filtrado de actividades
router.get("/actividades/buscar", async (req, res) => {
  try {
    const { tipo, fecha } = req.query;

    // Rango completo de horas
    const inicioDia = new Date(fecha);
    inicioDia.setHours(0, 0, 0, 0);
    const finDia = new Date(fecha);
    finDia.setHours(23, 59, 59, 999);

    const actividadesEncontradas = await Actividades.find({
      tipoActividad: tipo,
      fechaHora: {
        $gte: inicioDia,
        $lte: finDia,
      },
    });

    res.json(actividadesEncontradas);
  } catch (error) {
    console.error("Error al buscar actividades:", error);
    res.status(500).json({ message: "Error en el servidor al buscar clases" });
  }
});

// Ruta de filtrado de actividades de X dia en adelante
router.get("/actividades/disponibles", async (req, res) => {
  try {
    const { tipo } = req.query;
    const ahora = new Date();

    const query = {
      fechaHora: { $gte: ahora },
    };

    if (tipo) {
      query.tipoActividad = { $regex: new RegExp(tipo, "i") };
    }

    const actividades = await Actividades.find(query).sort({ fechaHora: 1 });

    if (actividades.length === 0) {
      return res
        .status(404)
        .json({ message: "No hay actividades disponibles" });
    }

    res.json(actividades);
  } catch (error) {
    console.error("Error en actividades disponibles:", error);
    res.status(500).json({ message: "Error en el servidor" });
  }
});

// Ruta inscripción actividad
router.post("/actividades/reservar", async (req, res) => {
  try {
    const { actividadId, usuarioId } = req.body;

    const actividad = await Actividades.findById(actividadId);

    // ¿Ya inscrito?
    if (actividad.usuariosInscritos.includes(usuarioId)) {
      return res
        .status(400)
        .json({ message: "Ya estás inscrito en esta clase" });
    }

    // ¿Plazas libres?
    if (actividad.usuariosInscritos.length >= actividad.plazasMaximas) {
      return res.status(400).json({ message: "No quedan plazas disponibles" });
    }

    actividad.usuariosInscritos.push(usuarioId);
    await actividad.save();

    res.json({ message: "Reserva realizada con éxito" });
  } catch (error) {
    res.status(500).json({ message: "Error al procesar la reserva" });
  }
});

// Ruta para recibir actividades inscritas
router.get("/usuarios/:usuarioId/reservas", async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const { fecha } = req.query;

    const inicioDia = new Date(fecha);
    const finDia = new Date(fecha);
    finDia.setHours(23, 59, 59, 999);

    const misReservas = await Actividades.find({
      usuariosInscritos: usuarioId,
      fechaHora: { $gte: inicioDia, $lte: finDia },
    });

    res.json(misReservas);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener tus reservas" });
  }
});

// Ruta de filtrado de actividades de X dia en adelante
router.get("/usuarios/:usuarioId/reservasDisponibles", async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const ahora = new Date();

    const misReservas = await Actividades.find({
      usuariosInscritos: usuarioId,
      fechaHora: { $gte: ahora }
    }).sort({ fechaHora: 1 });

    res.json(misReservas);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al obtener tus reservas" });
  }
});

// Ruta para cancelar reservas
router.post("/actividades/cancelar", async (req, res) => {
  try {
    const { actividadId, usuarioId } = req.body;
    await Actividades.findByIdAndUpdate(actividadId, {
      $pull: { usuariosInscritos: usuarioId },
    });
    res.json({ message: "Reserva cancelada correctamente" });
  } catch (error) {
    res.status(500).json({ message: "Error al cancelar" });
  }
});

// Ruta historial reservas
router.get("/usuarios/:usuarioId/historial", async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const ahora = new Date();

    const historial = await Actividades.find({
      usuariosInscritos: usuarioId,
      fechaHora: { $lt: ahora }, // $lt es menor que, es decir la dechahora será menor que la actual
    }).sort({ fechaHora: -1 }); // más recientes primero

    res.json(historial);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener historial" });
  }
});

export default router;
