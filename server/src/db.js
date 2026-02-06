import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config();

const uri = process.env.MONGO_URI;

export async function connectDB() {
  try {
    await mongoose.connect(uri, {});
    console.log("Base de datos MongoDB conectada");
  } catch (err) {
    console.error("Error conectándose a la base de datos MongoDB:", err);
    process.exit(1);
  }
}
