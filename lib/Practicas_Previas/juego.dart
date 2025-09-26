import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart'; // Para usar AppDrawer

/// Juego de Piedra, Papel o Tijera con marcador - Interfaz mejorada
class JuegoRPS extends StatefulWidget {
  const JuegoRPS({super.key});

  @override
  State<JuegoRPS> createState() => _JuegoRPSState();
}

class _JuegoRPSState extends State<JuegoRPS> {
  final List<String> opciones = ["🗿 Piedra", "📄 Papel", "✂️ Tijera"];
  String eleccionUsuario = "";
  String eleccionApp = "";
  String resultado = "";
  int marcadorUsuario = 0;
  int marcadorApp = 0;
  int empates = 0;

  /// Determinar el ganador de la ronda
  String determinarGanador(String usuario, String app) {
    if (usuario == app) {
      empates++;
      return "⚖️ Empate";
    } else if ((usuario.contains("Piedra") && app.contains("Tijera")) ||
        (usuario.contains("Papel") && app.contains("Piedra")) ||
        (usuario.contains("Tijera") && app.contains("Papel"))) {
      marcadorUsuario++;
      return "🎉 ¡Ganaste!";
    } else {
      marcadorApp++;
      return "💥 Perdiste";
    }
  }

  /// Ejecutar una jugada
  void jugar(String eleccion) {
    final random = Random();
    String appChoice = opciones[random.nextInt(opciones.length)];

    setState(() {
      eleccionUsuario = eleccion;
      eleccionApp = appChoice;
      resultado = determinarGanador(eleccionUsuario, eleccionApp);
    });
  }

  /// Reiniciar el marcador completo
  void reiniciarMarcador() {
    setState(() {
      marcadorUsuario = 0;
      marcadorApp = 0;
      empates = 0;
      eleccionUsuario = "";
      eleccionApp = "";
      resultado = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piedra, Papel o Tijera'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      drawer: const AppDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header del juego mejorado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.sports_esports,
                        size: 28,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Piedra, Papel o Tijera',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Elige tu jugada para comenzar',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Marcador mejorado
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMarcadorItem(
                      'Tú',
                      marcadorUsuario,
                      Colors.green,
                      Icons.person,
                    ),
                    _buildMarcadorItem(
                      'Empates',
                      empates,
                      Colors.blue,
                      Icons.balance,
                    ),
                    _buildMarcadorItem(
                      'App',
                      marcadorApp,
                      Colors.red,
                      Icons.smart_toy,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Instrucciones
              Text(
                "Elige tu jugada:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              // Botones de opciones mejorados
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: opciones.map((opcion) {
                    return _buildBotonJugada(opcion);
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),

              // Resultado de la jugada actual
              if (eleccionUsuario.isNotEmpty && eleccionApp.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _getColorResultado(),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorResultado().withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultado,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildResultadoItem(
                            "Tú elegiste:",
                            eleccionUsuario,
                            Icons.person,
                          ),
                          _buildResultadoItem(
                            "App eligió:",
                            eleccionApp,
                            Icons.smart_toy,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Estado inicial mejorado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 60,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Selecciona una jugada para comenzar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Botón de reinicio mejorado
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: reiniciarMarcador,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar Marcador'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget para construir items del marcador mejorados
  Widget _buildMarcadorItem(
    String titulo,
    int valor,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Widget para construir botones de jugada mejorados
  Widget _buildBotonJugada(String opcion) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => jugar(opcion),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Text(
                opcion.split(' ')[0], // Solo el emoji
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          opcion.split(' ')[1], // Solo el texto
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// Widget para items del resultado
  Widget _buildResultadoItem(String titulo, String valor, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(height: 4),
        Text(
          titulo,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Obtener color según el resultado
  Color _getColorResultado() {
    if (resultado.contains("Ganaste")) return Colors.green;
    if (resultado.contains("Perdiste")) return Colors.red;
    return Colors.blue;
  }
}
