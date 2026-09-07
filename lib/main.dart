import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'login_page.dart';

// Global notifier for theme mode management
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const ResiTrackApp());
}

class ResiTrackApp extends StatelessWidget {
  const ResiTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'ResiTrack',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          
          // Warm Light Theme
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,   // Warmer primary
              secondary: Colors.amber,      // Warmer secondary
              tertiary: Colors.brown,       // Warmer tertiary
              error: Colors.redAccent,
              surface: Color(0xFFFFFBF0),   // Creamy surface
              onSurface: Color(0xFF3E2723), // Deep brown text
              outline: Colors.orangeAccent,
            ),
            scaffoldBackgroundColor: const Color(0xFFFFFBF0),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFFBF0),
              foregroundColor: Color(0xFF3E2723),
            ),
          ),

          // Warm Dark Theme
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: Colors.orangeAccent,
              secondary: Colors.amberAccent,
              tertiary: Colors.brown,
              error: Colors.redAccent,
              surface: Color(0xFF1B1612),   // Dark warm brown
              onSurface: Color(0xFFFDF5E6), // Off-white/Old Lace
              outline: Colors.orange,
            ),
            scaffoldBackgroundColor: const Color(0xFF1B1612),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1B1612),
              foregroundColor: Color(0xFFFDF5E6),
            ),
          ),
          home: const LandingPage(),
        );
      },
    );
  }
}
