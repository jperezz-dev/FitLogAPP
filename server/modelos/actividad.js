import mongoose from "mongoose";

const ActividadEsquema = new mongoose.Schema(
  {
    tipoActividad: {
      type: String,
      required: true,
      enum: ["Yoga", "Crossfit", "Spinning", "Body pump"], // Enum para limitar opciones
    },
    fechaHora: { type: Date, required: true },
    plazasMaximas: { type: Number, required: true },
    usuariosInscritos: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Usuario", // Guarda la referencia del usuario inscrito
      },
    ],
  }
);

ActividadEsquema.virtual('plazasLibres').get(function() {
    return this.plazasMaximas - this.usuariosInscritos.length; // Calcula cuantas plazas quedan libres
});

const Actividades = mongoose.model("Actividad", ActividadEsquema);

export default Actividades;
