import 'package:fitlog_app/widgets/calendario.dart';
import 'package:flutter/material.dart';
import 'package:fitlog_app/widgets/seleccion_hora.dart';
import 'package:fitlog_app/services/user_session.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String _actividad = 'Clases dirigidas de Crossfit';
  TimeOfDay _hora = TimeOfDay.now();
  DateTime _fecha = DateTime.now();

  Future<void> enviarActividad() async {
    final String url = "http://10.0.2.2:3000/actividades";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${UserSession().token}",
        },
        body: jsonEncode({
          "nombre": _actividad,
          "fecha": _fecha.toIso8601String(),
          "hora": "${_hora.hour}:${_hora.minute}",
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Actividad creada con éxito")),
        );
      }
    } catch (e) {
      print("Error al crear actividad: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Actividad nueva
              const Text(
                "Crear una nueva actividad:",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),

              const SizedBox(height: 20),

              const Text(
                "Tipo de actividad:",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              _buildDropdown(), // Llamada a selector de tipo de actividad

              const SizedBox(height: 20),

              const Text(
                "Hora de la actividad:",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Seleccion de hora
              SeleccionHora(
                hora: _hora,
                onCambio: (nuevaHora) => setState(() => _hora = nuevaHora),
              ),

              const SizedBox(height: 20),

              const Text(
                "Fecha de la actividad:",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Seleccion de fecha
              Calendario(onFechaSeleccionada: (fecha) {}),

              const SizedBox(height: 20),
              _buildSubmitButton(), // Llamada a boton
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xF8CD472A), width: 2),
      ),
      child: DropdownButton<String>(
        value: _actividad,
        dropdownColor: Colors.black,
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox(),
        isExpanded: true,
        items: [
          'Clases dirigidas de Crossfit',
          'Clases dirigidas de Body Pump',
          'Clases de iniciación al Yoga',
          'Clases guiadas de Spinning',
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => setState(() => _actividad = val!),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xF8CD472A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => enviarActividad(),
        child: const Text(
          "GUARDAR ACTIVIDAD",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
