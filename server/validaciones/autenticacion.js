import { z } from "zod";

// Esquema del registro
export const RegistroSchema = z.object({
  nombreUsuario: z
    .string()
    .min(3, "El nombre debe tener al menos 3 caracteres")
    .max(20, "El nombre es demasiado largo"),
  correoUsuario: z
    .string()
    .email("Formato de correo inválido"),
  contrasenhaUsuario: z
    .string()
    .min(6, "La contraseña debe tener al menos 6 caracteres"),
});

// Esquema login
export const LoginSchema = z.object({
  correoUsuario: z.string().email("Correo inválido"),
  contrasenhaUsuario: z.string().min(1, "La contraseña es requerida"),
});

// Formatear errores
export function formatZodErrors(error) {
  return error.issues.map((issue) => ({
    campo: issue.path.join("."),
    mensaje: issue.message,
  }));
}