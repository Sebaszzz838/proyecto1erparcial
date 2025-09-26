import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Aplicación de notas rápidas con persistencia local
class NotasRapidas extends StatefulWidget {
  const NotasRapidas({super.key});

  @override
  State<NotasRapidas> createState() => _NotasRapidasState();
}

class _NotasRapidasState extends State<NotasRapidas> {
  final TextEditingController _controller = TextEditingController();
  List<String> _notas = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Cargar notas desde SharedPreferences al iniciar
  Future<void> _cargarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notas = prefs.getStringList('notas') ?? [];
    });
  }

  /// Guardar notas en SharedPreferences
  Future<void> _guardarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notas', _notas);
  }

  /// Agregar una nueva nota a la lista
  void _agregarNota() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _notas.insert(0, texto); // Agregar al inicio para mostrar primero
      _controller.clear();
    });

    _guardarNotas();
    _focusNode.unfocus(); // Ocultar teclado

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Nota agregada correctamente'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Editar una nota existente
  void _editarNota(int index) {
    _controller.text = _notas[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar nota'),
          content: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Modifica tu nota',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _controller.clear();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final nuevoTexto = _controller.text.trim();
                if (nuevoTexto.isNotEmpty) {
                  setState(() {
                    _notas[index] = nuevoTexto;
                  });
                  _guardarNotas();
                }
                _controller.clear();
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    ).then((_) => _focusNode.requestFocus());
  }

  /// Eliminar una nota específica
  void _borrarNota(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar la nota "${_notas[index]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notas.removeAt(index);
              });
              _guardarNotas();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nota eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  /// Eliminar todas las notas
  void _borrarTodasNotas() {
    if (_notas.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar todas las notas (${_notas.length})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notas.clear();
              });
              _guardarNotas();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las notas han sido eliminadas'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar Todo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas Rápidas'),
        centerTitle: true,
        elevation: 2,
        actions: [
          if (_notas.isNotEmpty)
            IconButton(
              onPressed: _borrarTodasNotas,
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Eliminar todas las notas',
            ),
          IconButton(
            onPressed: _cargarNotas,
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar notas',
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
                      Icons.note_alt,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mis Notas',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _notas.isEmpty
                                ? 'Comienza agregando una nota'
                                : '${_notas.length} nota${_notas.length == 1 ? '' : 's'} guardada${_notas.length == 1 ? '' : 's'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Campo para agregar nueva nota
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Nueva nota',
                          hintText: 'Escribe tu nota aquí...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                        ),
                        onSubmitted: (_) => _agregarNota(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: _agregarNota,
                      mini: true,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Lista de notas
            Expanded(
              child: _notas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add,
                            size: 80,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay notas aún',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agrega tu primera nota usando el campo de arriba',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.4),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: _notas.length,
                        itemBuilder: (context, index) {
                          return _buildItemNota(index);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget para construir cada item de nota en la lista
  Widget _buildItemNota(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.2),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          _notas[index],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          'Creada: ${DateTime.now().toString().substring(0, 10)}',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _editarNota(index),
              tooltip: 'Editar nota',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () => _borrarNota(index),
              tooltip: 'Eliminar nota',
            ),
          ],
        ),
      ),
    );
  }
}
