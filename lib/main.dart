import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sessionUser/login.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://zzfoxilhmmmgankupofr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6Zm94aWxobW1tZ2Fua3Vwb2ZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTg0Mjk3NzksImV4cCI6MjAxNDAwNTc3OX0.tF2Wm6DW_XiC88UXxE50dBPMWk3wwy6moOPb5qgeFRI',
    debug: true,
  );
  runApp(const MyApp());
}

final SupabaseClient supabaseClient = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const LoginScreen(),
    );
  }
}
