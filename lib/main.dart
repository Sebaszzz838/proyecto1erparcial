import 'package:flutter/material.dart';
import 'package:proyecto1erparcial/KitOffline/galeria.dart';
import 'package:proyecto1erparcial/KitOffline/imc.dart';
import 'package:proyecto1erparcial/KitOffline/notas_rapidas.dart';

// Importar pantallas de la aplicación
import 'Practicas_Previas/Formulario.dart';
import 'Practicas_Previas/practica3.dart';
import 'Practicas_Previas/practica4.dart';
import 'Practicas_Previas/juego.dart';

import 'Hubs/kitoffline.dart';
import 'Ajustes/ajustes.dart';
import 'Hubs/hub_practicas.dart';

// Notificador global para control del tema (claro/oscuro/sistema)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Kit de Herramientas Flutter',
          theme: ThemeData.light(), // Tema claro por defecto
          darkTheme: ThemeData.dark(), // Tema oscuro
          themeMode: currentMode, // Modo actual del tema
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const HubScreen(),
            '/formulario': (context) => const Formulario(),
            '/practica3': (context) => const Practica3(),
            '/practica4': (context) => const Practica4(),
            '/juego': (context) => const JuegoRPS(),
            '/kitoffline': (context) => const KitOffline(),
            '/ajustes': (context) => const AjustesScreen(),
            '/practicas': (context) => const HubPracticas(),
            '/galeria': (context) => const GaleriaLocal(),
            '/imc': (context) => const CalculadoraIMC(),
            '/juego_par_impar': (context) => const JuegoRPS(),
            '/notas_rapidas': (context) => const NotasRapidas(),
          },
        );
      },
    );
  }
}

/// Pantalla principal con menú de navegación y grid de opciones
class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kit de Herramientas Flutter'),
        centerTitle: true,
        elevation: 4,
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
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header informativo mejorado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
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
                        Icons.rocket_launch,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Bienvenido!',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Text(
                            'Explora todas las herramientas disponibles',
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

              // Título de sección
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Funcionalidades Principales',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Grid de opciones principales mejorado
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildFeatureCard(
                      context,
                      Icons.school,
                      'Prácticas',
                      'Ejercicios de aprendizaje',
                      '/practicas',
                      Colors.blue,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.offline_bolt,
                      'Kit Offline',
                      'Herramientas sin conexión',
                      '/kitoffline',
                      Colors.green,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.settings,
                      'Ajustes',
                      'Personaliza la app',
                      '/ajustes',
                      Colors.orange,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.help_outline,
                      'Acerca de',
                      'Información de la app',
                      '/ajustes',
                      Colors.purple,
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

  /// Widget para construir tarjetas de características del grid principal
  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String route,
    Color color,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono con fondo circular
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),

              const SizedBox(height: 16),

              // Título
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtítulo
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),

              const SizedBox(height: 8),

              // Indicador de acción
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Drawer de navegación lateral reutilizable en toda la app
class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({super.key, this.currentRoute = '/'});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header del drawer con gradiente mejorado
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono principal
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.construction,
                      size: 32,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Título principal
                  Text(
                    "Kit Flutter",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Subtítulo
                  Text(
                    "Herramientas y prácticas",
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Sección: Navegación Principal
                _buildSectionHeader('NAVEGACIÓN PRINCIPAL'),
                _drawerItem(
                  context,
                  icon: Icons.home,
                  text: 'Inicio',
                  route: '/',
                ),

                const SizedBox(height: 8),

                // Sección: Prácticas
                _buildSectionHeader('PRÁCTICAS DE APRENDIZAJE'),
                _drawerItem(
                  context,
                  icon: Icons.assignment,
                  text: 'Formulario de Registro',
                  route: '/formulario',
                ),
                _drawerItem(
                  context,
                  icon: Icons.format_list_numbered,
                  text: 'Práctica 3 - Listas',
                  route: '/practica3',
                ),
                _drawerItem(
                  context,
                  icon: Icons.add_circle,
                  text: 'Práctica 4 - Contador',
                  route: '/practica4',
                ),
                _drawerItem(
                  context,
                  icon: Icons.casino,
                  text: 'Juego: Piedra, Papel, Tijera',
                  route: '/juego',
                ),

                const SizedBox(height: 16),

                // Sección: Herramientas
                _buildSectionHeader('HERRAMIENTAS OFFLINE'),
                _drawerItem(
                  context,
                  icon: Icons.offline_bolt,
                  text: 'Kit Offline Completo',
                  route: '/kitoffline',
                ),
                _drawerItem(
                  context,
                  icon: Icons.calculate,
                  text: 'Calculadora IMC',
                  route: '/imc',
                ),
                _drawerItem(
                  context,
                  icon: Icons.note_add,
                  text: 'Notas Rápidas',
                  route: '/notas_rapidas',
                ),
                _drawerItem(
                  context,
                  icon: Icons.photo_library,
                  text: 'Galería Local',
                  route: '/galeria',
                ),
                _drawerItem(
                  context,
                  icon: Icons.casino,
                  text: 'Juego Par/Impar',
                  route: '/juego_par_impar',
                ),

                const SizedBox(height: 16),

                // Sección: Configuración
                _buildSectionHeader('CONFIGURACIÓN'),
                _drawerItem(
                  context,
                  icon: Icons.settings,
                  text: 'Ajustes',
                  route: '/ajustes',
                ),
              ],
            ),
          ),

          // Footer del drawer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Versión 1.0',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                Icon(
                  Icons.flutter_dash,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para encabezados de sección en el drawer
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Widget para items del drawer con indicador de selección mejorado
  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
  }) {
    final bool isSelected = ModalRoute.of(context)?.settings.name == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              )
            : Icon(
                Icons.chevron_right,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
        onTap: () {
          Navigator.pop(context); // Cierra el drawer
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
