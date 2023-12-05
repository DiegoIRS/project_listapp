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
    return Scaffold(
      body: _pages[_selectedPageIndex]['page']!,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              currentIndex: _selectedPageIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(null),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_alarm),
                  label: 'Agenda',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          hoverElevation: 1.0,
          splashColor: const Color.fromARGB(255, 255, 255, 255),
          tooltip: 'QR',
          elevation: 1,
          onPressed: () => _selectPage(1),
          child: const Icon(Icons.qr_code),
        ),
      ),
    );
  }
}
