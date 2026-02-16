import 'package:fitlog_app/services/user_session.dart';
import 'package:flutter/material.dart';
import 'package:fitlog_app/widgets/reserva.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitlog_app/services/user_session.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  List<dynamic> _historial = []; // Lista de actividades filtrada
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  // Recibir historial de actividades
  Future<void> _cargarHistorial() async {
    final usuarioId = UserSession().id;
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/usuarios/$usuarioId/historial"),
      );
      if (response.statusCode == 200) {
        setState(() {
          _historial = jsonDecode(response.body);
          _cargando = false;
        });
      }
    } catch (e) {
      debugPrint("Error cargando historial: $e");
      setState(() => _cargando = false);
    }
  }

  String _obtenerImagenPath(String actividad) {
    switch (actividad.toLowerCase()) {
      case 'crossfit':
        return 'assets/imagen_crossfit.png';
      case 'body pump':
        return 'assets/imagen_body_pump.png';
      case 'yoga':
        return 'assets/imagen_yoga.png';
      case 'spinning':
        return 'assets/imagen_spinning.png';
      default:
        return 'assets/imagen_crossfit.png';
    }
  }

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
                  text:
                      UserSession().nombre ??
                      "No disponible", // ?? "No disponible" para Null safety
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
                  text:
                      UserSession().correo ??
                      "No disponible", // ?? "No disponible" para Null safety,
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
                  text:
                      "${fecha.day.toString().padLeft(2, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.year}", // padLeft para que no se quede 2-2-2024 sino 02-02-2024
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
          const SizedBox(height: 10),
          _cargando
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xF8CD472A)),
                )
              : _historial.isEmpty
              ? const Text(
                  "No hay reservas pasadas.",
                  style: TextStyle(color: Colors.grey),
                )
              : ListView.builder(
                  shrinkWrap:
                      true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _historial.length,
                  itemBuilder: (context, index) {
                    final reserva = _historial[index];
                    final DateTime dt =
                        DateTime.tryParse(reserva['fechaHora'] ?? "") ??
                        DateTime.now();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ReservaBanner(
                        titulo:
                            "${fecha.day.toString().padLeft(2, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.year}",
                        actividad: reserva['tipoActividad'] ?? "Actividad",
                        hora:
                            "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}",
                        plazas: 0,
                        imagenPath: _obtenerImagenPath(
                          reserva['tipoActividad'] ?? "",
                        ),
                        esCancelacion:
                            false,
                        esAnterior: true,
                        onReserva: () {},
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
