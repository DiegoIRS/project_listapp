import 'package:flutter/material.dart';

import '../../main.dart';
import '../../sessionUser/sessionUser.dart';

class AddEventDialog extends StatefulWidget {
  final Function(String title) onAddEvent;

  const AddEventDialog({Key? key, required this.onAddEvent}) : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  String _selectedEvent = '';
  String? _eventType;
  List<String> _events = []; // Lista para almacenar eventos de la base de datos

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    // Utiliza la instancia existente del cliente de Supabase
    final response = await supabaseClient
        .from('asignatura')
        .select('nombre')
        .eq('id_carrera', SessionUser.idCarrera)
        .execute();

    if (response.status >= 200 &&
        response.status < 300 &&
        response.data != null) {
      setState(() {
        _events =
            List<String>.from(response.data.map((item) => item['nombre']));
        if (_events.isNotEmpty) {
          _selectedEvent = _events.first;
        }
      });
    } else {
      // Manejar el error
    }
  }

  void _onSave() {
    if (_hourController.text.isNotEmpty &&
        _minuteController.text.isNotEmpty &&
        _eventType != null) {
      String title =
          _selectedEvent == 'Otro' ? _titleController.text : _selectedEvent;

      widget.onAddEvent(title);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir Evento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedEvent,
              isExpanded: true, // Asegurando que el dropdown se expanda
              items: _events.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEvent = newValue!;
                });
              },
              decoration:
                  const InputDecoration(labelText: 'Seleccionar Evento'),
            ),
            _selectedEvent == 'Otro'
                ? TextField(
                    controller: _titleController,
                    decoration:
                        const InputDecoration(labelText: 'Nombre del Evento'),
                  )
                : Container(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hourController,
                    decoration: const InputDecoration(labelText: 'Hora (HH)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10), // Espaciado entre los campos
                Expanded(
                  child: TextField(
                    controller: _minuteController,
                    decoration: const InputDecoration(labelText: 'Minuto (MM)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _eventType,
              isExpanded: true, // Asegurando que el dropdown se expanda
              items: <String>[
                'Clase',
                'Laboratorio',
                'Taller',
                'Practica',
                'Actividad'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _eventType = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'Estado del Evento'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _onSave,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
