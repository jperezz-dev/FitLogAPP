import mongoose from "mongoose";

const UsuarioEsquema = new mongoose.Schema({
  nombreUsuario: { type: String, required: true },
  correoUsuario: { type: String, required: true },
  contrasenhaUsuario: { type: String, required: true},
  fechaRegistro: { type: Date, default: Date.now }
});

const Usuarios =  mongoose.model("Usuario", UsuarioEsquema);

export default Usuarios;