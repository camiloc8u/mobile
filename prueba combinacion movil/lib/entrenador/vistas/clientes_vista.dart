import 'package:flutter/material.dart';
import '../widgets/entrenador_widgets.dart';

class ClientesVista extends StatelessWidget {
  final List<Map<String, String>> assignedClients;
  final VoidCallback onRequestClient;
  final Function(Map<String, String>) onClientTap;

  const ClientesVista({
    super.key,
    required this.assignedClients,
    required this.onRequestClient,
    required this.onClientTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Utilizamos EntrenadorWidgets
          Expanded(child: EntrenadorWidgets.buildClientsList(assignedClients, onClientTap)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: primaryGreen), minimumSize: const Size.fromHeight(45)),
            onPressed: onRequestClient,
            icon: const Icon(Icons.mail_outline, color: primaryGreen),
            label: const Text('Solicitar Más Usuarios al Admin', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}