import 'package:flutter/material.dart';
import 'package:fitlog_app/views/inicio.dart';
import 'package:fitlog_app/views/actividades.dart'; 
import 'package:fitlog_app/views/reservas.dart';

class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  int paginaActual = 0;

  // Lista de vistas
  final List<Widget> paginas = [
    const Inicio(),
    const Actividades(),
    //const Reservas(),
  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      
      // Barra superior
      appBar: AppBar(
        title: Text(
          paginaActual == 0 ? '¡Bienvenido!' : 
          paginaActual == 1 ? 'Actividades' : 'Mis Reservas',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0E0E0E),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 35),
            onPressed: () => print("Perfil"),
          ),
        ],
      ),

      // Cuerpo (Carga las diferentes vistas)
      body: paginas[paginaActual],

      // Barra inferior
bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // Estilo del texto (Label) según el estado
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xF8CD472A), 
                fontSize: 14,             
                fontWeight: FontWeight.bold,
              );
            }
            return const TextStyle(
              color: Colors.grey,       
              fontSize: 12,               
            );
          }),
          // Estilo de los iconos según el estado
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(size: 30, color: Color(0xF8CD472A));
            }
            return const IconThemeData(size: 24, color: Colors.white);
          }),
        ),
        child: NavigationBar(
          selectedIndex: paginaActual,
          onDestinationSelected: (int index) {
            setState(() {
              paginaActual = index;
            });
          },
          indicatorColor: Colors.transparent, // Elimina el sombreado ovalado
          backgroundColor: const Color(0xFF0E0E0E),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined), 
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.backup_table_rounded), 
              label: 'Actividades',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined), 
              label: 'Reservas',
            ),
          ],
        ),
      ),
    );
  }
}