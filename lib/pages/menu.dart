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
        'page': MyHomePage(),
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
    final Size screenSize = MediaQuery.of(context).size;
    final double iconSize = screenSize.width * 0.06;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Evita que el Scaffold se redimensione cuando aparece el teclado
      body: _pages[_selectedPageIndex]['page']!,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: iconSize),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(null), // Espacio vacío para el botón flotante
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: iconSize),
            label: 'Clases',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectPage(1),
        child: const Icon(Icons.qr_code, size: 35),
        tooltip: 'QR',
        elevation: 4,
      ),
    );
  }
}
