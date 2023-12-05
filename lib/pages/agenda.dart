import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'widget_Agenda/dialog.dart';
import 'widget_Agenda/nextEventScreen.dart';
import 'widget_Agenda/clase_Event.dart';

class SelectableCalendar extends StatefulWidget {
  const SelectableCalendar({super.key});

  @override
  _SelectableCalendarState createState() => _SelectableCalendarState();
}

class _SelectableCalendarState extends State<SelectableCalendar> {
  late Map<DateTime, List<Event>> _events;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = {};
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    // No se muestra el diálogo aquí como se solicitó.
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        onAddEvent: (eventTitle) {
          _addNewEvent(eventTitle);
        },
      ),
    );
  }

  void _addNewEvent(String eventTitle) {
    final eventDate = _selectedDay;
    final newEvent = Event(title: eventTitle, dateTime: eventDate);

    setState(() {
      if (_events[eventDate] != null) {
        _events[eventDate]!.add(newEvent);
      } else {
        _events[eventDate] = [newEvent];
      }
    });
    // Aquí debes agregar la lógica para guardar el evento en tu base de datos.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: (day) => _events[day] ?? [],
            locale: 'es_ES',
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month', // Solo muestra el formato mensual
            },
            // Agrega aquí todas las configuraciones adicionales de TableCalendar.
          ),
          Expanded(
            child: NextEventScreen(
              events: _events[_selectedDay] ?? [],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
