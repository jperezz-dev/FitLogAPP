import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitlog_app/views/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  // Controladores
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _passRepetidaCtrl = TextEditingController();

  // Envio de datos al backend
  Future<void> registrarUsuario() async {
    const String url = "http://10.0.2.2:3000/registro"; 

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombreUsuario": _nombreCtrl.text,
          "correoUsuario": _emailCtrl.text,
          "contrasenhaUsuario": _passCtrl.text,
        }),
      );

      if (response.statusCode == 201) {
        print("Usuario creado!");
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login())); // Vuelta al login
      } else {
        print("Error: ${jsonDecode(response.body)['message']}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo.png"),
            fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              height: 200,
              semanticsLabel: 'Logo de la App',
            ),
            
            const SizedBox(height: 48),

            // Input de nombre
            TextField(
              controller: _nombreCtrl, // Controlador del nombre
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Nombre",
                labelStyle: const TextStyle(color: Color(0xFFD7D7D7)),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.2),

                // Borde habilitado
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Border focus
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Icono
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),
            
            // Input de Email
            TextField(
              controller: _emailCtrl, // Controlador email
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Color(0xFFD7D7D7)),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.2),

                // Borde habilitado
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Border focus
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Icono
                prefixIcon: const Icon(
                  Icons.mail_outlined,
                  color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),
            
            // Input de Contraseña
            TextField(
              controller: _passCtrl, // Controlador contraseña
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Contraseña",
                labelStyle: const TextStyle(color: Color(0xFFD7D7D7)),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.2),

                // Borde habilitado
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Border focus
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Icono
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color:  Color(0xFFD7D7D7)),
              ),
            ),

            const SizedBox(height: 16),

            // Input de Contraseña repetida
            TextField(
              controller: _passRepetidaCtrl,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Repetir contraseña",
                labelStyle: const TextStyle(color: Color(0xFFD7D7D7)),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.2),

                // Borde habilitado
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Border focus
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: const Color(0xF8CD472A).withValues(alpha: 0.6),
                    width: 2),
                ),

                // Icono
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color:  Color(0xFFD7D7D7)),
              ),
            ),
            
            const SizedBox(height: 50),

            // Botón principal
            Container(
              width: 300,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(0, 5),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5733).withValues(alpha: 0.8),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => registrarUsuario(),
                child: const Text("Registrarse", style: TextStyle(fontSize: 20)),
              ),
            ),
            
            // Link a Registro
            TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Login())),
            child: Text.rich(
              TextSpan(
                text: "¿Ya tienes cuenta? ",
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: "Incio de sesión",
                    style: TextStyle(
                      color: const Color(0xFFFF5733),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}