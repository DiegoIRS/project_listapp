import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/menu.dart';
import 'sessionUser.dart'; // Ajusta la ruta según tu estructura de archivos

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final response = await Supabase.instance.client
        .from('estudiante')
        .select()
        .eq('correo', _correoController.text.trim())
        .eq('contrasena', _contrasenaController.text.trim())
        .execute();

    print('Supabase Response: $response');

    setState(() => _isLoading = false);

    if (response.status >= 400) {
      // Error en la consulta
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
    } else if (response.data == null || response.data.isEmpty) {
      // No se encontraron datos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    } else {
      // Éxito en el inicio de sesión
      print('Successful login! Data: ${response.data[0]}');

      // Guardar id_estudiante como int en SessionUser
      SessionUser.idEstudiante = response.data[0]['id_estudiante'] as int?;

      // Navegar a la página principal
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            BottomNavigation(estudianteData: response.data[0]),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
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
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Iniciar Sesión'),
                  ),
                ],
              ),
            ),
    );
  }
}
