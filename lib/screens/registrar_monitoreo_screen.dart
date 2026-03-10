import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class RegistrarMonitoreoScreen extends StatelessWidget {
  const RegistrarMonitoreoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Monitoreo')),
      drawer: const AppDrawer(currentRoute: '/registrar_monitoreo'),
      body: const Center(
        child: Text(
          'Welcome to Registrar Monitoreo',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
