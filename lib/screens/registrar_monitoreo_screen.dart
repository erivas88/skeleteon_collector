import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class RegistrarMonitoreoScreen extends StatefulWidget {
  const RegistrarMonitoreoScreen({super.key});

  @override
  State<RegistrarMonitoreoScreen> createState() => _RegistrarMonitoreoScreenState();
}

class _RegistrarMonitoreoScreenState extends State<RegistrarMonitoreoScreen> {
  // Variables de estado
  bool _isMonitoreoFallido = false;
  DateTime? _fechaYHoraMuestreo; // Guardará la fecha y hora seleccionadas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Monitoreo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/registrar_monitoreo'),
      body: const Center(
        child: Text(
          'Welcome to Registrar Monitoreo',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildFormRow({
    required String label,
    required String value,
    required bool isValid,
    bool showArrow = true,
    IconData? customIcon,
    Color? customIconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        customIcon ?? (isValid ? Icons.check_circle : Icons.cancel),
        color: customIconColor ?? (isValid ? Colors.greenAccent : Colors.grey.withOpacity(0.5)),
        size: 24,
      ),
      title: Text(label, style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 16, color: isValid || customIcon != null ? Colors.white : Colors.grey),
      ),
      trailing: showArrow ? const Icon(Icons.arrow_drop_down, color: Colors.grey) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      dense: true,
      onTap: onTap ?? () {
        print('Tapped on $label');
      },
    );
  }
}
