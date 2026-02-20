import 'package:fitlog_app/widgets/calendario.dart';
import 'package:fitlog_app/widgets/reserva.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitlog_app/services/user_session.dart';

class Reservas extends StatefulWidget {
  const Reservas({super.key});

  @override
  State<Reservas> createState() => _ReservasState();
}

class _ReservasState extends State<Reservas> {
  DateTime _fechaSeleccionada = DateTime.now(); // Fecha actual
  List<dynamic> _misReservas = []; // Lista de reservas filtrada
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _obtenerMisReservas();
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

  Future<void> _obtenerMisReservas() async {
    setState(() => _cargando = true);
    final usuarioId = UserSession().id;
    final fechaStr =
        "${_fechaSeleccionada.year}-${_fechaSeleccionada.month.toString().padLeft(2, '0')}-${_fechaSeleccionada.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2:3000/usuarios/$usuarioId/reservas?fecha=$fechaStr",
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> datos = jsonDecode(response.body);
        setState(() => _misReservas = jsonDecode(response.body));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _cancelarReserva(String actividadId) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/actividades/cancelar"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "actividadId": actividadId,
          "usuarioId": UserSession().id,
        }),
      );
      if (response.statusCode == 200) {
        _obtenerMisReservas(); // Recargar reservas
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Reserva cancelada")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cancelar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              setState(() {
                _fechaSeleccionada = fecha;
                _obtenerMisReservas();
              });
            },
          ),

          const SizedBox(height: 20),

          // Reservas
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xF8CD472A)),
                  )
                : _misReservas.isEmpty
                ? const Center(
                    child: Text(
                      "No tienes reservas para este día",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _misReservas.length,
                    itemBuilder: (context, index) {
                      final reserva = _misReservas[index];

                      // Parseo de fecha
                      DateTime dt =
                          DateTime.tryParse(
                            reserva['fechaHora']?.toString() ?? "",
                          ) ??
                          _fechaSeleccionada;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ReservaBanner(
                          titulo: "Clase a las",
                          actividad: reserva['tipoActividad'] ?? "Actividad",
                          hora:
                              "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}",
                          plazas: 0,

                          imagenPath: _obtenerImagenPath(
                            reserva['tipoActividad']?.toString() ?? "",
                          ),
                          esCancelacion: true,
                          esAnterior: false,
                          onReserva: () => _cancelarReserva(reserva['_id']),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
