import 'package:flutter/material.dart';

// Enumeración para el estado de la clase.
enum ClassStatus { attended, absent, inProgress, upcoming }

class CustomContainerWidget extends StatelessWidget {
  final String clase;
  final String profesor;
  final String sala;
  final String horario;
  final ClassStatus estado;

  const CustomContainerWidget({
    super.key,
    required this.clase,
    required this.profesor,
    required this.sala,
    required this.horario,
    required this.estado,
  });

  Color getStatusColor(ClassStatus status) {
    switch (status) {
      case ClassStatus.attended:
        return Colors.green;
      case ClassStatus.absent:
        return Colors.red;
      case ClassStatus.inProgress:
        return Colors.blue;
      case ClassStatus.upcoming:
        return Colors.orange;
      default:
        return Colors.grey; // Default color in case of an undefined status
    }
  }

  String getStatusText(ClassStatus status) {
    switch (status) {
      case ClassStatus.attended:
        return 'Asistido';
      case ClassStatus.absent:
        return 'Ausente';
      case ClassStatus.inProgress:
        return 'En Curso';
      case ClassStatus.upcoming:
        return 'Próximo';
      default:
        return 'Indefinido'; // Default text in case of an undefined status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromARGB(255, 245, 246, 247),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Sombra semi-transparente
              spreadRadius: 0,
              blurRadius: 4, // El radio de difuminado de la sombra
              offset: const Offset(0, 3), // Cambios de posición de la sombra
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clase,
                style: const TextStyle(
                  color: Color(0xFF0F1113),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profesor,
                style: const TextStyle(
                  color: Color(0xFF57636C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sala,
                style: const TextStyle(
                  color: Color(0xFF57636C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(
                height: 24,
                thickness: 1,
                color: Color(0xFFE0E3E7),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hora',
                    style: TextStyle(
                      color: Color(0xFF0F1113),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    horario,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 32,
                    decoration: BoxDecoration(
                      color: getStatusColor(estado),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getStatusText(estado),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
