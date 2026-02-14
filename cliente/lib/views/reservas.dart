import 'package:fitlog_app/widgets/calendario.dart';
import 'package:flutter/material.dart';

class Reservas extends StatelessWidget {
  const Reservas({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Texto actividades
          const Text(
            'Reservas activas:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Calendario de reservas
          Calendario(
            onFechaSeleccionada: (fecha) {
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
