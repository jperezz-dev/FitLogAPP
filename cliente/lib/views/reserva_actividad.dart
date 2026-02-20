import 'package:flutter/material.dart';
import 'package:fitlog_app/widgets/calendario.dart';
import 'package:fitlog_app/widgets/reserva.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitlog_app/services/user_session.dart';

class ReservaActividad extends StatefulWidget {
  final String tipoActividad; // Actividad recibida desde actividades

  const ReservaActividad({super.key, required this.tipoActividad});

  @override
  State<ReservaActividad> createState() => _ReservaActividadState();
}

class _ReservaActividadState extends State<ReservaActividad> {
  DateTime _fechaSeleccionada =
      DateTime.now(); // Fecha seleccionada en calendario
  List<dynamic> _clasesDisponibles = []; // Lista filtrada
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _obtenerClases(); // Carga clases el dia de hoy
  }

  // Imagenes para banner reserva
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

  // Obtención de actividades desde express
  Future<void> _obtenerClases() async {
    final String fechaStr =
        "${_fechaSeleccionada.year}-${_fechaSeleccionada.month.toString().padLeft(2, '0')}-${_fechaSeleccionada.day.toString().padLeft(2, '0')}";
    final url = Uri.parse(
      "http://10.0.2.2:3000/actividades/buscar?tipo=${widget.tipoActividad}&fecha=$fechaStr",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() => _clasesDisponibles = jsonDecode(response.body));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al buscar clases: $e")));
    } finally {
      setState(() => _cargando = false);
    }
  }

  // Reserva de actividad
  Future<void> _realizarReserva(String actividadId) async {
    final url = Uri.parse("http://10.0.2.2:3000/actividades/reservar");
    final usuarioId = UserSession().id;

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"actividadId": actividadId, "usuarioId": usuarioId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("¡Reserva confirmada!")));
        _obtenerClases(); // Actualizar lista
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error en reserva: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Clases de ${widget.tipoActividad}",
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Calendario(
              onFechaSeleccionada: (fecha) {
                setState(() => _fechaSeleccionada = fecha);
                _obtenerClases();
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Horarios disponibles:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xF8CD472A)),
                  )
                : _clasesDisponibles.isEmpty
                ? const Center(
                    child: Text(
                      "No hay clases para este día",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _clasesDisponibles.length,
                    itemBuilder: (context, index) {
                      final clase = _clasesDisponibles[index];

                      final int plazasMax = clase['plazasMaximas'] ?? 0;
                      final List inscritos = clase['usuariosInscritos'] ?? [];
                      final int plazasCalculadas = plazasMax - inscritos.length;

                      final DateTime dt = DateTime.parse(clase['fechaHora']);
                      final String horaFormateada =
                          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ReservaBanner(
                          titulo: "Clase a las",
                          actividad: widget.tipoActividad,
                          hora: horaFormateada,
                          plazas: plazasCalculadas,
                          imagenPath: _obtenerImagenPath(widget.tipoActividad),
                          esCancelacion: false,
                          esAnterior: false,
                          onReserva: () {
                            _realizarReserva(clase['_id']);
                          },
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
