import 'package:flutter/material.dart';

class AddEventDialog extends StatefulWidget {
  final Function(String title) onAddEvent;

  const AddEventDialog({super.key, required this.onAddEvent});

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  String _selectedEvent = '1';
  String? _eventType;

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
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedEvent,
                items: <String>['1', '2', '3', '4', '5', '6', 'Otro']
                    .map<DropdownMenuItem<String>>((String value) {
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
                  SizedBox(width: 10), // Espaciado entre los campos
                  Expanded(
                    child: TextField(
                      controller: _minuteController,
                      decoration:
                          const InputDecoration(labelText: 'Minuto (MM)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _eventType,
                items: <String>['Prueba', 'Trabajo', 'Tarea', 'Taller']
                    .map<DropdownMenuItem<String>>((String value) {
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
                decoration:
                    const InputDecoration(labelText: 'Estado del Evento'),
              ),
            ],
          ),
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
