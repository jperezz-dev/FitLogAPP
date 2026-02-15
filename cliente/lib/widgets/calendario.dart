import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  final Function(DateTime) onFechaSeleccionada;
  final List<DateTime> diasConReservas; // Lista de dias con reservas

  const Calendario({
    super.key,
    required this.onFechaSeleccionada,
    this.diasConReservas = const [],
  });

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _diaEnfocado = DateTime.now();
  DateTime? _diaSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TableCalendar(
        calendarFormat: CalendarFormat.month,
        rowHeight: 40,
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _diaEnfocado,
        locale: 'es_ES',

        selectedDayPredicate: (day) => isSameDay(_diaSeleccionado, day),

        // Estilos del header
        headerStyle: const HeaderStyle(
          decoration: BoxDecoration(
            color: const Color(0xF8CD472A),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 4),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 20,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 20,
          ),
        ),

        // Estilo del contenedor de dias
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
          weekendTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
          outsideDaysVisible: false,

          selectedDecoration: const BoxDecoration(
            color: Color(0xF8CD472A),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          todayDecoration: BoxDecoration(
            border: Border.all(color: const Color(0xF8CD472A), width: 1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(color: Colors.white),

          markerDecoration: const BoxDecoration(
            color: Color(0xF8CD472A),
            shape: BoxShape.circle,
          ),
        ),

        eventLoader: (day) {
          return widget.diasConReservas
              .where((d) => isSameDay(d, day))
              .toList();
        },

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _diaSeleccionado = selectedDay;
            _diaEnfocado = focusedDay;
          });
          widget.onFechaSeleccionada(selectedDay);
        },
      ),
    );
  }
}
