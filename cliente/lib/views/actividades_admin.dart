import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitlog_app/services/user_session.dart';
import 'package:fitlog_app/widgets/calendario.dart';
import 'package:fitlog_app/widgets/seleccion_hora.dart';

class ActividadesAdmin extends StatefulWidget {
  const ActividadesAdmin({super.key});

  @override
  State<ActividadesAdmin> createState() => _ActividadesAdminState();
}

class _ActividadesAdminState extends State<ActividadesAdmin> {
  List<dynamic> _actividades = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _obtenerActividades();
  }

  Future<void> _obtenerActividades() async {
    const String url = "http://10.0.2.2:3000/actividades/disponiblesTodo";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${UserSession().token}"},
      );

      if (response.statusCode == 200) {
        setState(() {
          _actividades = jsonDecode(response.body);
          _cargando = false;
        });
      } else {
        setState(() => _cargando = false);
      }
    } catch (e) {
      setState(() => _cargando = false);
    }
  }

  Future<void> _eliminarActividad(String id) async {
    final String url = "http://10.0.2.2:3000/actividades/$id";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${UserSession().token}"},
      );

      if (response.statusCode == 200) {
        setState(() {
          _actividades.removeWhere((act) => act['_id'] == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Actividad eliminada correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al eliminar la actividad")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error de conexión: $e")));
    }
  }

  Future<void> _editarActividad(
    String id,
    String tipo,
    DateTime nuevaFecha,
    TimeOfDay nuevaHora,
  ) async {
    final String url = "http://10.0.2.2:3000/actividades/$id";

    final DateTime fechaHoraFinal = DateTime(
      nuevaFecha.year,
      nuevaFecha.month,
      nuevaFecha.day,
      nuevaHora.hour,
      nuevaHora.minute,
    );

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${UserSession().token}",
        },
        body: jsonEncode({
          "tipoActividad": tipo, // Aseguramos que el tipo se envíe de vuelta
          "fechaHora": fechaHoraFinal.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        // Opción A: Recargar todo (tu código actual)
        _obtenerActividades();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Actividad actualizada correctamente")),
        );
      } else {
        // Esto te ayudará a saber si el backend rechazó la petición
        print("Error del servidor: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error de conexión al editar: $e");
    }
  }

  void _mostrarPanelEdicion(BuildContext context, dynamic act) {
    DateTime fechaAct = DateTime.parse(act['fechaHora']);
    TimeOfDay horaAct = TimeOfDay.fromDateTime(fechaAct);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Editar ${act['tipoActividad']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Nueva Hora:",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  SeleccionHora(
                    hora: horaAct,
                    onCambio: (nuevaHora) =>
                        setModalState(() => horaAct = nuevaHora),
                  ),

                  const SizedBox(height: 20),

                  // Usamos tu componente Calendario
                  const Text(
                    "Nueva Fecha:",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Calendario(
                    onFechaSeleccionada: (nuevaFecha) =>
                        setModalState(() => fechaAct = nuevaFecha),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xF8CD472A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        _editarActividad(
                          act['_id'],
                          act['tipoActividad'],
                          fechaAct,
                          horaAct,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "GUARDAR CAMBIOS",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Gestión de Actividades",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xF8CD472A)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _actividades.length,
              itemBuilder: (context, index) {
                final act = _actividades[index];
                final DateTime dt = DateTime.parse(act['fechaHora']);

                final String fechaFormateada =
                    "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
                final String horaFormateada =
                    "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

                return Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.asset(
                          _obtenerImagenPath(act['tipoActividad']),
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: .8),
                                  Colors.black.withValues(alpha: 0.4),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      act['tipoActividad'],
                                      style: const TextStyle(
                                        color: Color(0xFFFF5733),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "$fechaFormateada - $horaFormateada",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFFFF5733),
                                    ),
                                    onPressed: () =>
                                        _mostrarPanelEdicion(context, act),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xFFFF5733),
                                    ),
                                    onPressed: () {
                                      _eliminarActividad(act['_id']);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
