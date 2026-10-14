import 'package:flutter/material.dart';
import '../colores_entrenador.dart';

class VistaClientes extends StatelessWidget {
  final List<Map<String, String>> clientes;
  final VoidCallback solicitarCliente;
  final Function(Map<String, String>) verDetallesCliente;

  const VistaClientes({super.key, required this.clientes, required this.solicitarCliente, required this.verDetallesCliente});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mis Clientes', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: ColoresEntrenador.verde),
                onPressed: solicitarCliente,
                icon: const Icon(Icons.person_add, color: Colors.black),
                label: const Text('Solicitar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final client = clientes[index];
                return Card(
                  color: ColoresEntrenador.tarjeta,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: ColoresEntrenador.verde,
                      child: Text(client['name']![0], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(client['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('${client['plan']} \nEstado: ${client['status']}', style: const TextStyle(color: Colors.grey)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                    onTap: () => verDetallesCliente(client),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}