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
      body: ListView(
        children: [
          // --- DATOS DE MONITOREO ---
          
          // Si falló, mostramos un encabezado fijo (bloqueado)
          if (_isMonitoreoFallido)
            Column(
              children: [
                Container(
                  color: const Color(0xFFFF4B61), // Fondo rojo
                  child: const ListTile(
                    leading: Icon(
                      Icons.assignment_outlined, 
                      size: 28,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Datos de Monitoreo',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w500,
                        color: Colors.white, 
                      ),
                    ),
                  ),
                ),
                // Contenido del formulario
                _buildFormularioDatosMonitoreo(),
              ],
            )
            
          // Si NO falló, mostramos el ExpansionTile normal (que se puede abrir y cerrar)
          else
            ExpansionTile(
              initiallyExpanded: true,
              iconColor: Colors.blueAccent,
              collapsedIconColor: Colors.blueAccent,
              leading: const Icon(
                Icons.assignment_outlined, 
                size: 28,
                color: Colors.blueAccent,
              ),
              title: const Text(
                'Datos de Monitoreo',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w500,
                  color: Colors.white, 
                ),
              ),
              children: [
                _buildFormularioDatosMonitoreo(),
              ],
            ),

          // Ocultar las siguientes secciones si el monitoreo falló
          if (!_isMonitoreoFallido) ...[
            _buildSectionHeader('Multiparámetro'),
            _buildSectionHeader('Turbiedad'),
            _buildSectionHeader('Muestreo'),
          ],
        ],
      ),
    );
  }

  // --- MÉTODOS Y HELPERS ---

  Widget _buildFormularioDatosMonitoreo() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildFormRow(label: 'Programa', value: 'Mauro 2025', isValid: true),
          _buildFormRow(label: 'Inspector', value: 'Seleccione inspector', isValid: false),
          _buildFormRow(label: 'Punto de Control', value: 'Seleccione estación', isValid: false),
          _buildFormRow(label: 'Matriz de Aguas', value: 'Seleccione Tipo de Aguas', isValid: false),
          
          // Fila de Fecha y Hora actualizada
          _buildFormRow(
            label: 'Hora y Fecha de Muestreo', 
            // Si la variable es nula, muestra el texto por defecto, si no, muestra la fecha formateada
            value: _fechaYHoraMuestreo == null 
                ? 'Seleccione Hora y Fecha' 
                : _formatearFechaYHora(_fechaYHoraMuestreo!), 
            isValid: _fechaYHoraMuestreo != null, // Se pone verde si ya hay una fecha
            showArrow: false,
            onTap: _seleccionarFechaYHora, // Llama a nuestro nuevo método
          ),
          
          _buildFormRow(
            label: 'Monitoreo Fallido',
            value: _isMonitoreoFallido ? 'SI' : 'NO',
            isValid: !_isMonitoreoFallido,
            customIcon: _isMonitoreoFallido ? Icons.error : Icons.check_circle,
            customIconColor: _isMonitoreoFallido ? const Color(0xFFFF4B61) : Colors.greenAccent,
            onTap: _mostrarDialogoFallo,
          ),

          if (_isMonitoreoFallido)
            _buildFormRow(
              label: 'Descripción / Observación',
              value: 'Ingrese observación / descripción',
              isValid: false,
              showArrow: false,
            ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // --- NUEVA FUNCIONALIDAD: FECHA Y HORA ---
  
  // Método para abrir el DatePicker y luego el TimePicker
  Future<void> _seleccionarFechaYHora() async {
    // 1. Mostrar selector de fecha
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaYHoraMuestreo ?? DateTime.now(),
      firstDate: DateTime(2000), // Rango mínimo
      lastDate: DateTime(2100),  // Rango máximo
    );

    // Si el usuario cancela la fecha, no hacemos nada
    if (fechaSeleccionada == null) return;

    // 2. Mostrar selector de hora
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: _fechaYHoraMuestreo != null 
          ? TimeOfDay.fromDateTime(_fechaYHoraMuestreo!) 
          : TimeOfDay.now(),
    );

    // Si el usuario cancela la hora, no hacemos nada
    if (horaSeleccionada == null) return;

    // 3. Unimos la fecha y la hora y actualizamos el estado
    setState(() {
      _fechaYHoraMuestreo = DateTime(
        fechaSeleccionada.year,
        fechaSeleccionada.month,
        fechaSeleccionada.day,
        horaSeleccionada.hour,
        horaSeleccionada.minute,
      );
    });
  }

  // Pequeño helper para que la fecha se vea bonita (ej. 10/03/2026 14:30)
  String _formatearFechaYHora(DateTime fecha) {
    final String dia = fecha.day.toString().padLeft(2, '0');
    final String mes = fecha.month.toString().padLeft(2, '0');
    final String anio = fecha.year.toString();
    final String hora = fecha.hour.toString().padLeft(2, '0');
    final String minuto = fecha.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$anio $hora:$minuto';
  }

  // --- FIN NUEVA FUNCIONALIDAD ---

  Future<void> _mostrarDialogoFallo() async {
    bool tempValue = _isMonitoreoFallido;

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( 
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Monitoreo Fallido'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<bool>(
                    title: const Text('NO'),
                    value: false,
                    groupValue: tempValue,
                    onChanged: (bool? value) {
                      setStateDialog(() => tempValue = value!);
                    },
                  ),
                  RadioListTile<bool>(
                    title: const Text('SI'),
                    value: true,
                    groupValue: tempValue,
                    onChanged: (bool? value) {
                      setStateDialog(() => tempValue = value!);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text('CANCELAR', style: TextStyle(color: Colors.blueAccent)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, tempValue), 
                  child: const Text('OK', style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result != _isMonitoreoFallido) {
      setState(() {
        _isMonitoreoFallido = result;
      });
    }
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
