import 'package:fitlog_app/services/user_session.dart';
import 'package:flutter/material.dart';
import 'package:fitlog_app/views/inicio.dart';
import 'package:fitlog_app/views/actividades.dart';
import 'package:fitlog_app/views/reservas.dart';
import 'package:fitlog_app/views/perfil.dart';
import 'package:fitlog_app/views/admin.dart';

class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  int paginaActual = 0;
  bool? esAdministrador =
      UserSession().administrador; // Detecta el administrador (nullsafe)

  // Lista de vistas
  final List<Widget> paginas = [
    const Inicio(),
    const Actividades(),
    const Reservas(),
    const Perfil(),
    const Admin(),
  ];

  @override
  Widget build(BuildContext context) {
    bool esPerfil =
        paginaActual == 3; // Booleando para saber si estamos en el perfil
    bool esAdminVista =
        paginaActual ==
        4; // Booleano para saber si estamos en la vista de admin

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),

      // Barra superior
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          paginaActual == 0
              ? "Bienvenido ${UserSession().nombre ?? 'No disponible'}"
              : paginaActual == 1
              ? 'Actividades'
              : paginaActual == 2
              ? 'Mis reservas'
              : paginaActual == 3
              ? 'Mi Perfil'
              : 'Panel administrativo',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0E0E0E),
        actions: [
          if (esAdministrador == true)
            IconButton(
              icon: Icon(
                Icons.admin_panel_settings_outlined,
                color: esAdminVista
                    ? const Color(0xF8CD472A)
                    : Colors
                          .white, // Color resaltado al estar en vista de administrador
                size: 35,
              ),
              onPressed: () => setState(() {
                paginaActual = 4;
              }),
            ),
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
              color: esPerfil
                  ? const Color(0xF8CD472A)
                  : Colors.white, // Color resaltado al estar en perfil
              size: 35,
            ),
            onPressed: () => setState(() {
              paginaActual = 3;
            }),
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
            if (paginaActual == 3 || paginaActual == 4) {
              return const TextStyle(color: Colors.white, fontSize: 12);
            } // En el indice 3 todos los textos blancos

            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xF8CD472A),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              );
            }
            return const TextStyle(color: Colors.white, fontSize: 12);
          }),
          // Estilo de los iconos según el estado
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (paginaActual == 3 || paginaActual == 4) {
              return const IconThemeData(
                size: 24,
                color: Colors.white,
              ); // En el indice 3 todos los iconos blancos
            }

            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(size: 30, color: Color(0xF8CD472A));
            }
            return const IconThemeData(size: 24, color: Colors.white);
          }),
        ),
        child: NavigationBar(
          selectedIndex: paginaActual > 2 ? 0 : paginaActual,
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
