import 'package:flutter/material.dart';
import 'agenda.dart';
import 'escanerqr.dart';
import 'inicio.dart'; // Asegúrate de que este archivo contiene HomeWidget

class BottomNavigation extends StatefulWidget {
  final Map<String, dynamic> estudianteData;

  const BottomNavigation({
    super.key,
    required this.estudianteData,
  });

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late List<Map<String, Widget>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': HomeWidget(estudianteData: widget.estudianteData),
      },
      {
        'page': const EscanerQr(),
      },
      {
        'page': const SelectableCalendar(),
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utiliza MediaQuery para adaptar el tamaño de los elementos
    final Size screenSize = MediaQuery.of(context).size;
    final double iconSize = screenSize.width *
        0.06; // Tamaño de los íconos basado en el ancho de la pantalla

    return Scaffold(
      body: _pages[_selectedPageIndex]['page']!,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 1),
              border: const Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 0,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: iconSize),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(null),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_alarm, size: iconSize),
                  label: 'Clases',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FloatingActionButton(
          hoverElevation: 1,
          splashColor: Colors.cyan,
          tooltip: 'QR',
          elevation: 0.1,
          onPressed: () => _selectPage(1),
          child: const Icon(Icons.qr_code, size: 28),
        ),
      ),
    );
  }
}
