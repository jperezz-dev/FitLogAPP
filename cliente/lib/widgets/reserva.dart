import 'package:flutter/material.dart';

class ReservaBanner extends StatelessWidget {
  final String titulo;
  final String actividad;
  final String hora;
  final int plazas;
  final String imagenPath;
  final VoidCallback onReserva;
  final bool esCancelacion;
  final bool? esAnterior;

  const ReservaBanner({
    super.key,
    required this.titulo,
    required this.actividad,
    required this.hora,
    required this.plazas,
    required this.imagenPath,
    required this.onReserva,
    this.esCancelacion = false,
    this.esAnterior = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              imagenPath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: '$titulo $hora\n',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: actividad,
                                  style: const TextStyle(
                                    color: Color(0xFFFF5733),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                if (!esAnterior! && !esCancelacion)
                                  TextSpan(
                                    text: '\nPlazas libres: $plazas',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botón de reserva
                    if (!esAnterior!)
                      ElevatedButton(
                        onPressed: onReserva,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(221, 255, 88, 51),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          esCancelacion ? 'Cancelar' : 'Reservar',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
