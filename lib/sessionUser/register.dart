import 'package:flutter/material.dart';
import '../main.dart'; // Make sure Supabase is initialized here

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String? _selectedCarrera;
  List<String> _carreraOptions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCarreras();
  }

  Future<void> _fetchCarreras() async {
    setState(() => _isLoading = true);
    final response =
        await supabaseClient.from('carrera').select('nombre').execute();

    setState(() => _isLoading = false);
    if (response.data != null) {
      final List data = response.data as List;
      setState(() {
        _carreraOptions =
            data.map((carrera) => carrera['nombre'] as String).toList();
      });
    } else {
      // Handle the error here
      print('Error al obtener carreras');
    }
  }

  Future<void> _insertData() async {
    final response = await supabaseClient.from('estudiante').insert({
      'nombre': _nombreController.text.trim(),
      'rut': _rutController.text.trim(),
      'correo': _correoController.text.trim(),
      'contrasena': _contrasenaController.text.trim(),
      'carrera': _selectedCarrera?.trim(),
    }).execute();

    if (response.data != null) {
      // Handle success here
      _nombreController.clear();
      _rutController.clear();
      _correoController.clear();
      _contrasenaController.clear();
      setState(() => _selectedCarrera = null);
      print('Datos insertados con éxito');
    } else {
      // Handle the error here
      print('Error al insertar datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _rutController,
                      decoration: const InputDecoration(
                        labelText: 'Rut',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _correoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contrasenaController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCarrera,
                      hint: const Text('Carrera'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCarrera = newValue;
                        });
                      },
                      items: _carreraOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _insertData,
                      child: const Text('Registrar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
