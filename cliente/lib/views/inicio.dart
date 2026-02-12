import 'package:flutter/material.dart';
import 'package:fitlog_app/widgets/actividad_banner.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Anuncio spinning clases
          _buildAnuncioSpinning(),

          const SizedBox(height: 30),

          // Texto actividades
          const Text(
            'Actividades a tu\nmedida:',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 22, 
              fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height: 20),

          // Lista de actividades sugeridas
          ActividadBanner(
            titulo: 'Clases dirigidas de ',
            actividad: 'Crossfit',
            imagenPath: 'assets/imagen_crossfit.png',
            onReserva: () => print("Reserva Crossfit pulsada"),
          ),
          const SizedBox(height: 20),

          ActividadBanner(
            titulo: 'Clases dirigidas de ',
            actividad: 'Body pump',
            imagenPath: 'assets/imagen_body_pump.png',
            onReserva: () => print("Reserva Body pump"),
          ),
          const SizedBox(height: 20),

          ActividadBanner(
            titulo: 'Clases de iniciación al ',
            actividad: 'Yoga',
            imagenPath: 'assets/imagen_yoga.png',
            onReserva: () => print("Reserva Yoga"),
          ),
        ],
      ),
    );
  }

  Widget _buildAnuncioSpinning() {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              'assets/spinning_anuncio_fondo.png',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text.rich(
                    TextSpan(
                      text: '¡Apúntate a nuestras \nnuevas clases de \n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "Spinning",
                          style: TextStyle(
                            color: Color(0xFFFF5733),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "!"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5733),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Reservar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}