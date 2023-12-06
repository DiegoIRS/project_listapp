import 'package:flutter/material.dart';
// Asegúrate de tener estas clases definidas en sus respectivos archivos y que tengan los constructores correctos.
import 'widget_Agenda/clase_Event.dart';
import 'widget_Agenda/dialog.dart';
import 'widget_Agenda/nextEventScreen.dart'; // Asegúrate de importar este archivo.

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedDay = DateTime.now().weekday;
  List<String> _weekDays = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie'];
  Map<int, List<Event>> _eventsByDay = {};

  @override
  void initState() {
    super.initState();
    // Inicializa los eventos para cada día de la semana.
    _weekDays.asMap().forEach((index, _) {
      _eventsByDay[index + 1] = [];
    });
  }

  void _addEvent(String title) {
    if (title.isNotEmpty) {
      final DateTime now = DateTime.now();
      final Event newEvent = Event(
          title: title,
          dateTime: now); // Usa la fecha actual para el nuevo evento.

      setState(() {
        _eventsByDay[_selectedDay]!.add(newEvent);
      });

      // Aquí puedes agregar la lógica para guardar el evento en tu base de datos.
    }
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        onAddEvent: (String eventTitle) {
          _addEvent(eventTitle);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barra de Navegación Semanal'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _weekDays.asMap().entries.map((entry) {
              int index = entry.key;
              String day = entry.value;
              bool isSelected =
                  index + 1 == _selectedDay; // Ajuste por índice base 0
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = index + 1; // Ajuste por índice base 0
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: NextEventScreen(
              events: _eventsByDay[_selectedDay] ?? [],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
