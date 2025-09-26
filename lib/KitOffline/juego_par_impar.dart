import 'dart:math';
import 'package:flutter/material.dart';

/// Juego de Par/Impar donde el usuario elige número y paridad
class JuegoParImpar extends StatefulWidget {
  const JuegoParImpar({super.key});

  @override
  State<JuegoParImpar> createState() => _JuegoParImparState();
}

class _JuegoParImparState extends State<JuegoParImpar> {
  String eleccionUsuario = 'Par';
  int numeroUsuario = 0;
  int numeroApp = 0;
  int marcadorUsuario = 0;
  int marcadorApp = 0;
  int rondasJugadas = 0;
  List<Map<String, dynamic>> historial = [];

  /// Ejecutar una jugada del juego
  void jugar() {
    final random = Random();
    numeroApp = random.nextInt(6);
    final suma = numeroUsuario + numeroApp;
    final esPar = suma % 2 == 0;

    bool usuarioGano =
        (esPar && eleccionUsuario == 'Par') ||
        (!esPar && eleccionUsuario == 'Impar');

    setState(() {
      if (usuarioGano) {
        marcadorUsuario++;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🎉 ¡Ganaste! Suma: $suma (${esPar ? 'Par' : 'Impar'})',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        marcadorApp++;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '💥 ¡Perdiste! Suma: $suma (${esPar ? 'Par' : 'Impar'})',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Agregar al historial
      historial.insert(0, {
        'ronda': rondasJugadas + 1,
        'usuario': numeroUsuario,
        'app': numeroApp,
        'suma': suma,
        'resultado': usuarioGano ? 'Ganó' : 'Perdió',
        'paridad': esPar ? 'Par' : 'Impar',
      });

      rondasJugadas++;
    });
  }

  /// Reiniciar el juego completamente
  void reiniciar() {
    setState(() {
      marcadorUsuario = 0;
      marcadorApp = 0;
      numeroUsuario = 0;
      rondasJugadas = 0;
      historial.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego Par/Impar'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header del juego
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.casino,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Juego Par/Impar',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Elige par/impar y un número del 0-5',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Selector de Par/Impar
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Elige Par o Impar:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: eleccionUsuario,
                          items: const [
                            DropdownMenuItem(value: 'Par', child: Text('Par')),
                            DropdownMenuItem(
                              value: 'Impar',
                              child: Text('Impar'),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              eleccionUsuario = val!;
                            });
                          },
                          underline: const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Selector de números
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Elige un número (0-5):',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(6, (i) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: numeroUsuario == i
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.3),
                            ),
                            onPressed: () {
                              setState(() {
                                numeroUsuario = i;
                              });
                              jugar();
                            },
                            child: Text(
                              '$i',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Marcador
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Marcador Actual',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPuntajeItem(
                            'Tú',
                            marcadorUsuario,
                            Colors.green,
                          ),
                          _buildPuntajeItem(
                            'Rondas',
                            rondasJugadas,
                            Colors.blue,
                          ),
                          _buildPuntajeItem('App', marcadorApp, Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Historial de jugadas
              if (historial.isNotEmpty) ...[
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Historial de Jugadas',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            itemCount: historial.length,
                            itemBuilder: (context, index) {
                              final jugada = historial[index];
                              return ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: jugada['resultado'] == 'Ganó'
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  child: Text(
                                    jugada['ronda'].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: jugada['resultado'] == 'Ganó'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Tú: ${jugada['usuario']} + App: ${jugada['app']} = ${jugada['suma']} (${jugada['paridad']})',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: Chip(
                                  label: Text(jugada['resultado']),
                                  backgroundColor: jugada['resultado'] == 'Ganó'
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Botón de reinicio
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: reiniciar,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar Juego'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget para construir items del puntaje
  Widget _buildPuntajeItem(String titulo, int valor, Color color) {
    return Column(
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            valor.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
