import mongoose from "mongoose";

const UsuarioEsquema = new mongoose.Schema({
  nombreUsuario: { type: String, required: true },
  correoUsuario: { type: String, required: true },
  contrasenhaUsuario: { type: String, required: true},
  fechaRegistro: { type: Date, default: Date.now },
  administrador: {type: Boolean, default: false, required: true},
});

const Usuarios =  mongoose.model("Usuario", UsuarioEsquema);

export default Usuarios;