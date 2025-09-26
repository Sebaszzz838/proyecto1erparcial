import 'package:flutter/material.dart';
import '../main.dart';

/// Pantalla de ajustes y configuración de la aplicación
class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, _) {
            // Determinar si el modo actual es oscuro
            bool isDark =
                currentMode == ThemeMode.dark ||
                (currentMode == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header de ajustes
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Configuración',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Personaliza tu experiencia',
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

                // Sección: Apariencia
                _buildSectionHeader('APARIENCIA'),
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Modo oscuro'),
                        subtitle: const Text(
                          'Activa el tema oscuro para mejor visibilidad nocturna',
                        ),
                        value: isDark,
                        onChanged: (val) {
                          themeNotifier.value = val
                              ? ThemeMode.dark
                              : ThemeMode.light;
                        },
                        secondary: Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.contrast,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: const Text('Modo de tema'),
                        subtitle: Text(
                          currentMode == ThemeMode.system
                              ? 'Según sistema'
                              : currentMode == ThemeMode.dark
                              ? 'Oscuro'
                              : 'Claro',
                        ),
                        trailing: DropdownButton<ThemeMode>(
                          value: currentMode,
                          items: const [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text('Sistema'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text('Claro'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text('Oscuro'),
                            ),
                          ],
                          onChanged: (ThemeMode? newMode) {
                            if (newMode != null) {
                              themeNotifier.value = newMode;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Sección: Información
                _buildSectionHeader('INFORMACIÓN'),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Acerca de'),
                    subtitle: const Text(
                      'Información de la aplicación y desarrollador',
                    ),
                    onTap: () {
                      _mostrarDialogoAcercaDe(context);
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Información de versión
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flutter_dash,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Versión 1.0.0',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Widget para encabezados de sección
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Mostrar diálogo "Acerca de"
  void _mostrarDialogoAcercaDe(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Kit de Herramientas Flutter',
      applicationVersion: 'Versión 1.0.0',
      applicationIcon: const Icon(Icons.construction, size: 50),
      applicationLegalese:
          '© 2024 Fragoso Perez Sebastian. Todos los derechos reservados.',
      children: [
        const SizedBox(height: 16),
        const Text(
          'Esta aplicación fue desarrollada como proyecto de prácticas con Flutter.\n\n'
          'Incluye diversas herramientas y ejercicios para demostrar las capacidades '
          'del framework y el lenguaje Dart.',
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Text(
                  'Características principales:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildFeatureItem('✅ Formularios con validación'),
                _buildFeatureItem('✅ Juegos interactivos'),
                _buildFeatureItem('✅ Calculadora de IMC'),
                _buildFeatureItem('✅ Notas persistentes'),
                _buildFeatureItem('✅ Galería de imágenes'),
                _buildFeatureItem('✅ Tema claro/oscuro'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Widget para items de características
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
