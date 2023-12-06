import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/menu.dart';  // Asegúrate de que esta ruta sea correcta
import 'register.dart';     // Asegúrate de que esta ruta sea correcta
import 'sessionUser.dart';  // Asegúrate de que esta ruta sea correcta

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

    setState(() => _isLoading = false);

    if (response.status >= 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
    } else if (response.data == null || response.data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    } else {
      final estudianteData = response.data[0];
      SessionUser.idEstudiante = estudianteData['id_estudiante'] as int;
      SessionUser.idCarrera = estudianteData['id_carrera'] as int; // Asegúrate de que esta columna exista

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('idEstudiante', SessionUser.idEstudiante!);
      prefs.setInt('idCarrera', SessionUser.idCarrera!);
      prefs.setString('nombre', estudianteData['nombre'] as String);
      prefs.setString('correo', estudianteData['correo'] as String);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavigation(estudianteData: {
          'id_estudiante': SessionUser.idEstudiante,
          'id_carrera': SessionUser.idCarrera,
          'nombre': estudianteData['nombre'],
          'correo': estudianteData['correo'],
        }),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  SizedBox(height: screenHeight * .12),
                  const Text(
                    'Bienvenido,',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * .01),
                  Text(
                    'Iniciar Sesión Para Continuar!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.6),
                    ),
                  ),
                  SizedBox(height: screenHeight * .12),
                  TextField(
                    controller: _correoController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: screenHeight * .025),
                  TextField(
                    controller: _contrasenaController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: screenHeight * .075),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * .02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      child: const Text(
                        '¿No estás registrado? Pulsa aquí',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
