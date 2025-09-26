import 'package:flutter/material.dart';

/// Galería local de imágenes con visualización en modal
class GaleriaLocal extends StatelessWidget {
  const GaleriaLocal({super.key});

  // Lista de imágenes locales con rutas y títulos
  final List<Map<String, String>> imagenesAssets = const [
    {
      'ruta': 'assets/images/imagen_1.png',
      'titulo': 'Paisaje Natural',
      'descripcion': 'Hermoso paisaje con montañas y vegetación',
    },
    {
      'ruta': 'assets/images/imagen_2.png',
      'titulo': 'Arquitectura Moderna',
      'descripcion': 'Edificios contemporáneos con diseño innovador',
    },
    {
      'ruta': 'assets/images/imagen_3.jpg',
      'titulo': 'Arte Abstracto',
      'descripcion': 'Composición artística con colores vibrantes',
    },
    {
      'ruta': 'assets/images/imagen_4.jpg',
      'titulo': 'Tecnología Futurista',
      'descripcion': 'Conceptos tecnológicos avanzados',
    },
    {
      'ruta': 'assets/images/imagen_5.jpg',
      'titulo': 'Naturaleza Viva',
      'descripcion': 'Flora y fauna en su hábitat natural',
    },
    {
      'ruta': 'assets/images/imagen_6.jpg',
      'titulo': 'Ciudad Nocturna',
      'descripcion': 'Skyline urbano iluminado por la noche',
    },
  ];

  /// Mostrar imagen en modal/dialog con opciones
  void _mostrarImagen(
    BuildContext context,
    String ruta,
    String titulo,
    String descripcion,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header del modal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.photo_library,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          descripcion,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Imagen
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.asset(
                  ruta,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          const Text('Imagen no disponible'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Botones de acción
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Aquí iría la funcionalidad de compartir
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función de compartir')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Compartir'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Aquí iría la funcionalidad de descargar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función de descargar')),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Descargar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería Local'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Buscando imágenes...')),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
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
        child: Column(
          children: [
            // Header informativo
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_library,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Galería de Imágenes',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${imagenesAssets.length} imágenes disponibles',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid de imágenes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: imagenesAssets.length,
                  itemBuilder: (context, index) {
                    final imagen = imagenesAssets[index];
                    return _buildTarjetaImagen(context, imagen, index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget para construir tarjetas de imagen individuales
  Widget _buildTarjetaImagen(
    BuildContext context,
    Map<String, String> imagen,
    int index,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _mostrarImagen(
          context,
          imagen['ruta']!,
          imagen['titulo']!,
          imagen['descripcion']!,
        ),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Contenedor de la imagen
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  color: Colors.grey[100],
                  child: Image.asset(
                    imagen['ruta']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Imagen ${index + 1}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Información de la imagen
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    imagen['titulo']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    imagen['descripcion']!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
