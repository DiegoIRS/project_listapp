// custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String nombreEstudiante; // Agrega esta línea
  final String correoEstudiante; // Agrega esta línea

  const CustomAppBar({
    super.key,
    required this.nombreEstudiante, // Agrega esta línea
    required this.correoEstudiante, // Agrega esta línea
  })  : preferredSize = const Size.fromHeight(90.0);

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

              // Modifica aquí para usar los datos pasados
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        nombreEstudiante, // Usa la variable para el nombre
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    correoEstudiante, // Usa la variable para el correo
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
