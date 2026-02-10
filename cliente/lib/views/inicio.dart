import 'package:flutter/material.dart';
import 'package:fitlog_app/widgets/actividad_banner.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0E0E0E),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  title: const Text(
                    '¡Bienvenido Nombre_Apellido!',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF0E0E0E),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      tooltip: 'Perfil',
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Anuncio spinning clases
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/spinning_anuncio_fondo.png',
                          height: 220,
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
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text.rich(
                                  textAlign: TextAlign.left,
                                  TextSpan(
                                    text:
                                        '¡Apuntate a nuestras \nnuevas clases de \n',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Spinning",
                                        style: TextStyle(
                                          color: const Color(0xFFFF5733),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        221,
                                        255,
                                        88,
                                        51,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 45,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      'Reservar',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //Texto actividades
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Actividades a tu\nmedida:',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

                const SizedBox(height: 20),

                // Actividad sugerida 1
                ActividadBanner(
                  titulo: 'Clases dirigidas de ',
                  actividad: 'Crossfit',
                  imagenPath: 'assets/imagen_crossfit.png',
                  onReserva: () => print("Reserva Crossfit pulsada"),
                ),

                const SizedBox(height: 20),

                // Actividad sugerida 2
                ActividadBanner(
                  titulo: 'Clases dirigidas de ',
                  actividad: 'Body pump',
                  imagenPath: 'assets/imagen_body_pump.png',
                  onReserva: () => print("Reserva Body pump"),
                ),

                const SizedBox(height: 20),

                // Actividad sugerida 3
                ActividadBanner(
                  titulo: 'Clases dirigidas de ',
                  actividad: 'Yoga',
                  imagenPath: 'assets/imagen_yoga.png',
                  onReserva: () => print("Reserva Yoga"),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xF8CD472A),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              );
            }
            return const TextStyle(color: Colors.grey, fontSize: 12);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(size: 30, color: Color(0xF8CD472A));
            }
            return const IconThemeData(size: 24, color: Colors.white);
          }),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              paginaActual = index;
            });
          },
          indicatorColor: Colors.transparent,
          backgroundColor: const Color(0xFF0E0E0E),
          selectedIndex: paginaActual,
          destinations: const <Widget>[
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
