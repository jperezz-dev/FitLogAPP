import 'package:flutter/material.dart';
import 'package:fitlog_app/widgets/actividad_banner.dart';

class Actividades extends StatefulWidget {
  const Actividades({super.key});

  @override
  State<Actividades> createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {
  // Controlador para capturar el texto
  final TextEditingController _searchController = TextEditingController();

  // Lista completa de actividades
  final List<Map<String, String>> actividadesLista = [
    {'titulo': 'Crossfit', 'imagen': 'assets/imagen_crossfit.png'},
    {'titulo': 'Body pump', 'imagen': 'assets/imagen_body_pump.png'},
    {'titulo': 'Yoga', 'imagen': 'assets/imagen_yoga.png'},
    {'titulo': 'Spinning', 'imagen': 'assets/imagen_spinning.png'},
  ];

  // 3. Lista de actividades filtradas
  List<Map<String, String>> actividadesFiltradas = [];

  @override
  void initState() {
    super.initState();
    actividadesFiltradas =
        actividadesLista; // Todas las actividades como filtradas inicialmente
  }

  // Filtrado de actividades
  void _filtrarActividades(String query) {
    setState(() {
      actividadesFiltradas = actividadesLista
          .where(
            (act) => act['titulo']!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de búsqueda
          SearchBar(
            controller: _searchController,
            hintText: 'Buscar actividad...',
            hintStyle: WidgetStateProperty.all(
              const TextStyle(color: Colors.grey),
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(color: Colors.white),
            ),
            backgroundColor: WidgetStateProperty.all(
              Colors.black.withValues(alpha: 0.3),
            ),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            leading: const Icon(Icons.search, color: Colors.white),
            onChanged: (value) => _filtrarActividades(value),
            side: WidgetStateProperty.all(
              const BorderSide(color: Color(0xF8CD472A), width: 1),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),

          const SizedBox(height: 30),

          // Carga de la lista filtrada
          if (actividadesFiltradas.isEmpty) // lista filtrada vacía
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "No se encontraron actividades",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else // Actividades filtradas existentes
            ...actividadesFiltradas.map(
              (act) => Column(
                children: [
                  ActividadBanner(
                    titulo: 'Clases dirigidas de ',
                    actividad: act['titulo']!,
                    imagenPath: act['imagen']!,
                    onReserva: () => print("Reserva ${act['titulo']}"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
