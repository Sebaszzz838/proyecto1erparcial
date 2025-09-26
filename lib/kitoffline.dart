import 'package:flutter/material.dart';
import 'package:proyecto1erparcial/galeria.dart';
import 'package:proyecto1erparcial/CalculadoraIMC.dart';
import 'package:proyecto1erparcial/juego_par_impar.dart';
import 'package:proyecto1erparcial/notas_rapidas.dart';
import '../main.dart';

class KitOffline extends StatelessWidget {
  const KitOffline({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kit Offline - Herramientas'),
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
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header informativo
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kit de Herramientas Offline',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Funcionalidades disponibles sin conexión',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Grid de herramientas offline
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildToolCard(
                      context,
                      Icons.calculate,
                      'Calculadora IMC',
                      'Índice de Masa Corporal',
                      Colors.purple,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalculadoraIMC(),
                        ),
                      ),
                    ),
                    _buildToolCard(
                      context,
                      Icons.note_add,
                      'Notas Rápidas',
                      'Toma notas offline',
                      Colors.green,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotasRapidas(),
                        ),
                      ),
                    ),
                    _buildToolCard(
                      context,
                      Icons.photo_library,
                      'Galería',
                      'Ver imágenes guardadas',
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GaleriaLocal(),
                        ),
                      ),
                    ),
                    _buildToolCard(
                      context,
                      Icons.casino,
                      'Juego Par/Impar',
                      'Juego simple de números',
                      Colors.red,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JuegoParImpar(),
                        ),
                      ),
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

  /// Widget para construir tarjetas de herramientas
  Widget _buildToolCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
