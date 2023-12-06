import 'package:flutter/material.dart';
import '../../sessionUser/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String nombreEstudiante;
  final String correoEstudiante;

  const CustomAppBar({
    Key? key,
    required this.nombreEstudiante,
    required this.correoEstudiante,
  }) : preferredSize = const Size.fromHeight(90.0);

  void _logout(BuildContext context) async {
    // Operaciones de cierre de sesión
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
          child: Row(
            children: [
              // ... Icono y espaciado aquí ...

              // Datos del estudiante
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text('Bienvenido',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(width: 4),
                      Text(nombreEstudiante,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ],
                  ),
                  Text(correoEstudiante,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 8),
                ],
              ),
              Spacer(), // Empuja todo a la izquierda
              IconButton(
                icon: Icon(Icons.logout, color: Colors.red),
                onPressed: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
