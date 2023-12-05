import 'package:flutter/material.dart';

class AddEventDialog extends StatefulWidget {
  final Function(String title) onAddEvent;

  const AddEventDialog({super.key, required this.onAddEvent});

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay? _timeOfDay;

  void _onSave() {
    if (_timeOfDay != null && _titleController.text.isNotEmpty) {
      final now = DateTime.now();
      final selectedDate = DateTime(
        now.year,
        now.month,
        now.day,
        _timeOfDay!.hour,
        _timeOfDay!.minute,
      );
      widget.onAddEvent(_titleController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir Evento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Nombre de la Actividad'),
          ),
          ListTile(
            title: Text('Hora: ${_timeOfDay?.format(context) ?? 'Seleccionar'}'),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null && pickedTime != _timeOfDay) {
                setState(() {
                  _timeOfDay = pickedTime;
                });
              }
            },
          ),
        ],
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
