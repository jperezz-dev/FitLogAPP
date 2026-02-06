import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { connectDB } from "./db.js";
import rutas from "../rutas/itemRutas.js"

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

app.use(rutas);

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