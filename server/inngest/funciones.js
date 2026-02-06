import { Inngest } from "inngest";
import nodemailer from "nodemailer";

// Configuración de Nodemailer
const transporter = nodemailer.createTransport({
  service: "gmail", 
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// Cliente de inngest
export const inngest = new Inngest({ id: "fitlog-app" });

export const enviarCorreoBienvenida = inngest.createFunction(
  { id: "enviar-bienvenida" },
  { event: "app/usuario.registrado" },
  async ({ event, step }) => {
    const { correoUsuario, nombreUsuario } = event.data;

    await step.run("enviar-email", async () => {
      console.log(`Enviando correo de bienvenida a ${nombreUsuario} (${correoUsuario})...`);
      const mailOptions = {
        from: `"FitLog App" <${process.env.EMAIL_USER}>`,
        to: correoUsuario,
        subject: "¡Bienvenido a FitLog!",
        html: `
          <h1>Hola ${nombreUsuario},</h1>
          <p>Gracias por unirte a FitLog App. Desde nuestra aplicación podrás gestionar tu asistencia a las clases del gimnasio.</p>
          <p>¡A darle con todo!</p>
        `,
      };

      return await transporter.sendMail(mailOptions);
    });
  }
);