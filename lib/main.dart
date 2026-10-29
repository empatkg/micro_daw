import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/project_controller.dart';
import 'ui/screens/daw_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MicroDawApp());
}

class MicroDawApp extends StatelessWidget {
  const MicroDawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micro DAW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF181818),
        colorScheme: const ColorScheme.dark(primary: Colors.orange),
      ),
      home: const Bootstrap(),
    );
  }
}

class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  ProjectController? _controller;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  Future<void> _initEngine() async {
    final c = ProjectController();
    await c.init();
    if (mounted) setState(() => _controller = c);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }
    return DawScreen(controller: _controller!);
  }
}
