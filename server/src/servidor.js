import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { connectDB } from "./db.js";
import rutas from "../rutas/itemRutas.js";
import { serve } from "inngest/express";
import { inngest, enviarCorreoBienvenida } from "../inngest/funciones.js";

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

app.use(rutas);

app.use("/api/inngest", serve({ client: inngest, functions: [enviarCorreoBienvenida] }));

const PORT = process.env.PORT || 3000;
export async function startServer() {
  try {
    await connectDB();

    app.listen(PORT, () => {
      console.log(`API en http://localhost:${PORT}`);
    });

  } catch (error) {
    console.error("Error iniciando servidor: ", error);
  }
}

startServer();