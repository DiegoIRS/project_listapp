import 'package:flutter/material.dart';
import 'widget_Inicio/CustomContainerWidget.dart';
import 'widget_Inicio/MyCustomAppBar.dart';

class HomeWidget extends StatelessWidget {
  final Map<String, dynamic> estudianteData;

  const HomeWidget({super.key, required this.estudianteData});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de cómo podrías acceder a los datos del estudiante
    String nombreEstudiante =
        estudianteData['nombre'] ?? 'Nombre no disponible';
    String correoEstudiante =
        estudianteData['correo'] ?? 'Correo no disponible';

    return DefaultTabController(
      length: 2, // Tenemos 2 tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          nombreEstudiante: nombreEstudiante,
          correoEstudiante: correoEstudiante,
        ), // Asegúrate de que MyCustomAppBar acepte estos parámetros
        body: Column(
          children: <Widget>[
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Hoy'),
                Tab(text: 'Historial'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Vista para la pestaña "Hoy"
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        5, // Número de elementos, reemplaza con tu lista dinámica si es necesario
                    itemBuilder: (context, index) {
                      // Puedes personalizar los datos por índice
                      return CustomContainerWidget(
                        clase: 'Cálculo',
                        profesor: 'Profesor Ejemplo',
                        sala: 'Sala F-208',
                        horario: '10:50am - 11:50am',
                        estado: index % 2 == 0
                            ? ClassStatus.inProgress
                            : ClassStatus.upcoming,
                      );
                    },
                  ),
                  // Vista para la pestaña "Historial"
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        5, // Número de elementos, reemplaza con tu lista dinámica si es necesario
                    itemBuilder: (context, index) {
                      return CustomContainerWidget(
                        clase: 'Álgebra',
                        profesor: 'Profesor Historial',
                        sala: 'Sala H-101',
                        horario: '09:00am - 10:00am',
                        estado: index % 2 == 0
                            ? ClassStatus.attended
                            : ClassStatus.absent,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
