import 'package:flutter/material.dart';

class SeleccionHora extends StatelessWidget {
  final TimeOfDay hora;
  final Function(TimeOfDay) onCambio;

  const SeleccionHora({
    super.key,
    required this.hora,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? seleccionado = await showTimePicker(
          context: context,
          initialTime: hora,
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xF8CD472A),
                  onPrimary: Colors.white,
                  surface: Color(0xFF1E1E1E),
                ),
              ),
              child: child!,
            );
          },
        );
        if (seleccionado != null) onCambio(seleccionado);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xF8CD472A), width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              hora.format(context),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}