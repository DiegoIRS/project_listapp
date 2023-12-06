import 'package:flutter/material.dart';
import '../main.dart'; // Asegúrate de que Supabase esté inicializado aquí
import 'login.dart';

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
    setState(() => _isLoading = true);

    // Insertar datos en Supabase
    final response = await supabaseClient.from('estudiante').insert({
      'nombre': _nombreController.text.trim(),
      'rut': _rutController.text.trim(),
      'correo': _correoController.text.trim(),
      'contrasena': _contrasenaController.text.trim(),
      'carrera': _selectedCarrera,
    }).execute();

    setState(() => _isLoading = false);

    if (response.status != null && response.status! < 400) {
      // Si el estado es menor a 400, significa que la inserción fue exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );

      // Limpieza de campos
      _nombreController.clear();
      _rutController.clear();
      _correoController.clear();
      _contrasenaController.clear();
      setState(() => _selectedCarrera = null);

      // Regresar a la pantalla de inicio de sesión después de un retraso
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      });
    } else {
      // Manejo de error en la inserción basado en el estado HTTP
      String errorMessage = 'Error al registrar';

      if (response.status != null) {
        errorMessage += ': Error ${response.status}';
      }

      // Manejo de errores específicos si hay datos en la respuesta
      if (response.data != null && response.data is Map<String, dynamic>) {
        final errorData = response.data as Map<String, dynamic>;

        if (errorData.containsKey('error')) {
          final errorMessages = errorData['error'] as List<dynamic>?;
          if (errorMessages != null && errorMessages.isNotEmpty) {
            errorMessage += ': ${errorMessages.join(', ')}';
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: _contrasenaController,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          prefixIcon: Icon(Icons.lock),
        ),
        obscureText: true,
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCarrera,
      hint: const Text('Carrera'),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCarrera = newValue;
        });
      },
      items: _carreraOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _insertData,
      child: const Text('Registrar'),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  _buildTextField(_nombreController, 'Nombre', Icons.person),
                  _buildTextField(_rutController, 'Rut', Icons.credit_card),
                  _buildTextField(_correoController, 'Correo', Icons.email),
                  _buildPasswordField(),
                  _buildDropdown(),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
      ),
    );
  }
}
