import 'package:flutter/material.dart';
//import 'pages/clases.dart';
//import 'pages/escanerqr.dart';
//import 'pages/inicio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Bar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.cyan,
        ),
      ),
      home: BottomBarScreen(),
    );
  }
}

class BottomBarScreen extends StatefulWidget {
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late List<Map<String, Widget>> _pages;

  @override
  void initState() {
    _pages = [
      //{'page': Inicio()},
      //{'page': EscanerQr()},
      //{'page': Clases()},
    ];
    super.initState();
  }

  int _selectedPageIndex = 0;

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
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              border: Border(
                top: BorderSide(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              currentIndex: _selectedPageIndex,
              items: [
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
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          hoverElevation: 1.0,
          splashColor: Color.fromARGB(255, 255, 255, 255),
          tooltip: 'QR',
          elevation: 1,
          onPressed: () => _selectPage(1),
          child: Icon(Icons.qr_code),
        ),
      ),
    );
  }
}