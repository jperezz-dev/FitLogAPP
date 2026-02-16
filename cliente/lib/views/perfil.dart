import 'package:fitlog_app/services/user_session.dart';
import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {

    DateTime fecha = DateTime.parse(UserSession().fechaCreacion!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Nombre: ',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              children: [
                TextSpan(
                  text: UserSession().nombre ?? "No disponible", // ?? "No disponible" para Null safety
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text.rich(
            TextSpan(
              text: 'Email: ',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              children: [
                TextSpan(
                  text: UserSession().correo ?? "No disponible", // ?? "No disponible" para Null safety,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text.rich(
            TextSpan(
              text: 'Miembro desde: ',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              children: [
                TextSpan(
                  text: "${fecha.day.toString().padLeft(2, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.year}", // padLeft para que no se quede 2-2-2024 sino 02-02-2024
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          Text.rich(
            TextSpan(
              text: 'Historial de reservas: ',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
