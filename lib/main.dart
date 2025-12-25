import 'package:flutter/material.dart';
import 'screens/todo_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TodoApp());
}

/// TodoApp with Dark Mode Support
class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List Pro',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: _themeMode,

      // Home screen with theme toggle
      home: Builder(
        builder: (context) => Scaffold(
          body: const TodoScreen(),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleTheme,
            tooltip: 'Toggle theme',
            child: Icon(
              _themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
        ),
      ),
    );
  }
}
