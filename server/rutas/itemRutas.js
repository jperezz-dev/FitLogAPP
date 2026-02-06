import express from "express";
import Usuario from "../modelos/usuarios.js";
import bcrypt from "bcryptjs";

const router = express.Router();

// --- REGISTRO ---
router.post("/registro", async (req, res) => {
  try {
    const { nombreUsuario, correoUsuario, contrasenhaUsuario } = req.body;

    // Comprobación de usuario existente
    const usuarioExistente = await Usuario.findOne({ correoUsuario });
    if (usuarioExistente) return res.status(400).json({ message: "Ya hay un usuario registrado con ese correo." });

    // Contraseña encriptada
    const salt = await bcrypt.genSalt(10); // Salificacion de contraseña
    const hashedPassword = await bcrypt.hash(contrasenhaUsuario, salt); // Hasheo de contraseña + sal única

    const nuevoUsuario = new Usuario({
      nombreUsuario,
      correoUsuario,
      contrasenhaUsuario: hashedPassword
    });

    await nuevoUsuario.save();
    res.status(201).json({ message: "Usuario creado con éxito" });
    console.log(`Usuario registrado: ${nombreUsuario}`);

  } catch (error) {
    res.status(500).json({ message: "Error en el servidor" });
  }
});

// Ruta para crear usuarios
router.post("/login", async (req, res) => {
  try {
    const { correoUsuario, contrasenhaUsuario } = req.body;

    // Busca usuario
    const usuario = await Usuario.findOne({ correoUsuario });
    if (!usuario) return res.status(400).json({ message: "Usuario inexistente" });

    // Compara contraseñas
    const isMatch = await bcrypt.compare(contrasenhaUsuario, usuario.contrasenhaUsuario);
    if (!isMatch) return res.status(400).json({ message: "Contraseña incorrecta" });

    console.log(`Login exitoso: ${usuario.nombreUsuario}`);
    res.json({
      message: "Inicio de sesión correcto",
      user: { 
        id: usuario._id, 
        nombre: usuario.nombreUsuario, 
        correo: usuario.correoUsuario 
      }
    });

  } catch (error) {
    res.status(500).json({ message: "Error al iniciar sesión" });
  }
});

export default router;
