import 'package:flutter/material.dart';
import '../main.dart';

/// Hub de prácticas - Versión simplificada
class HubPracticas extends StatelessWidget {
  const HubPracticas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prácticas de Aprendizaje'),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prácticas de Flutter',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Selecciona una práctica para comenzar',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Lista de prácticas usando las rutas definidas en main.dart
              Expanded(
                child: ListView(
                  children: [
                    _buildPracticaSimple(
                      context,
                      Icons.assignment,
                      'Formulario de Registro',
                      'Aprende validación de formularios',
                      Colors.blue,
                      '/formulario',
                    ),
                    _buildPracticaSimple(
                      context,
                      Icons.toggle_on,
                      'Práctica 3 - Estado',
                      'Manejo básico de estado',
                      Colors.green,
                      '/practica3',
                    ),
                    _buildPracticaSimple(
                      context,
                      Icons.list_alt,
                      'Práctica 4 - Listas',
                      'Listas dinámicas y actualizaciones',
                      Colors.orange,
                      '/practica4',
                    ),
                    _buildPracticaSimple(
                      context,
                      Icons.casino,
                      'Juego: Piedra, Papel, Tijera',
                      'Juego interactivo con estado',
                      Colors.purple,
                      '/juego',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPracticaSimple(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
    String route,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
