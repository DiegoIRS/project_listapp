import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sessionUser/login.dart';
import 'pages/menu.dart';
import 'sessionUser/sessionUser.dart';

// Declarar la instancia global de SupabaseClient
final SupabaseClient supabaseClient = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://zzfoxilhmmmgankupofr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6Zm94aWxobW1tZ2Fua3Vwb2ZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTg0Mjk3NzksImV4cCI6MjAxNDAwNTc3OX0.tF2Wm6DW_XiC88UXxE50dBPMWk3wwy6moOPb5qgeFRI',
    debug: true,
  );

  final prefs = await SharedPreferences.getInstance();
  final idEstudiante = prefs.getInt('idEstudiante');

  SessionUser.idEstudiante = idEstudiante ?? 0;
  runApp(MyApp(loggedIn: idEstudiante != null, estudianteData: {
    'id_estudiante': idEstudiante ?? 0,
    'nombre': prefs.getString('nombre') ?? '',
    'correo': prefs.getString('correo') ?? '',  
  }));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  final Map<String, dynamic> estudianteData;

  const MyApp({
    Key? key,
    required this.loggedIn,
    required this.estudianteData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Bar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.cyan,
        ),
      ),
      supportedLocales: const [
        Locale('es', 'CL'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        if (locale != null &&
            locale.languageCode == 'es' &&
            locale.countryCode == 'CL') {
          return const Locale('es', 'CL');
        }
        return const Locale('es', 'CL');
      },
      home: loggedIn
          ? BottomNavigation(estudianteData: estudianteData)
          : const LoginScreen(),
    );
  }
}
