import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitlog_app/views/registro.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controladores
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  // Envio de datos al backend
  Future<void> loginUsuario() async {
    const String url = "http://10.0.2.2:3000/login"; 

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "correoUsuario": _emailCtrl.text,
          "contrasenhaUsuario": _passCtrl.text,
        }),
      );

      if (response.statusCode == 201) {
        print("Usuario logeado!");
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
            
            // Input de Email
            TextField(
              controller: _emailCtrl, // Controlador de email
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
              controller: _passCtrl, // Controlador de contraseña
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

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  
                },
                child: const Text(
                  "¿Contraseña olvidada?",
                  style: TextStyle(color: Colors.white)),
                ),
              ),
            
            const SizedBox(height: 15),

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
                onPressed: () => loginUsuario(),
                child: const Text("Iniciar sesión", style: TextStyle(fontSize: 20)),
              ),
            ),
            
            // Link a Registro
            TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Registro())),
            child: Text.rich(
              TextSpan(
                text: "¿No tienes cuenta? ",
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: "Regístrate",
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