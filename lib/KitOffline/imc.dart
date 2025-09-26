import 'package:flutter/material.dart';

/// Calculadora de Índice de Masa Corporal (IMC) con validaciones
class CalculadoraIMC extends StatefulWidget {
  const CalculadoraIMC({super.key});

  @override
  State<CalculadoraIMC> createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final _formKey = GlobalKey<FormState>();
  final _estaturaController = TextEditingController();
  final _pesoController = TextEditingController();
  double? _imcResultado;
  String? _categoriaIMC;

  /// Calcular el IMC y determinar la categoría
  void _calcularIMC() {
    if (!_formKey.currentState!.validate()) return;

    final double estatura = double.parse(_estaturaController.text);
    final double peso = double.parse(_pesoController.text);
    final double imc = peso / (estatura * estatura);

    String categoria = '';
    Color colorCategoria = Colors.grey;

    if (imc < 18.5) {
      categoria = 'Bajo peso';
      colorCategoria = Colors.blue;
    } else if (imc < 25) {
      categoria = 'Peso normal';
      colorCategoria = Colors.green;
    } else if (imc < 30) {
      categoria = 'Sobrepeso';
      colorCategoria = Colors.orange;
    } else {
      categoria = 'Obesidad';
      colorCategoria = Colors.red;
    }

    setState(() {
      _imcResultado = imc;
      _categoriaIMC = categoria;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_getIconoCategoria(categoria), color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tu IMC: ${imc.toStringAsFixed(2)} → $categoria',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: colorCategoria,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Obtener icono según la categoría del IMC
  IconData _getIconoCategoria(String categoria) {
    switch (categoria) {
      case 'Bajo peso':
        return Icons.arrow_downward;
      case 'Peso normal':
        return Icons.check_circle;
      case 'Sobrepeso':
        return Icons.warning;
      case 'Obesidad':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  /// Limpiar todos los campos y resultados
  void _limpiar() {
    _formKey.currentState!.reset();
    _estaturaController.clear();
    _pesoController.clear();
    setState(() {
      _imcResultado = null;
      _categoriaIMC = null;
    });
  }

  /// Validación para campos numéricos positivos
  String? _validarNumeroPositivo(String? value, String campo) {
    if (value == null || value.isEmpty) return 'La $campo es obligatoria';
    if (double.tryParse(value) == null) return 'Ingresa un número válido';
    if (double.parse(value) <= 0) return 'Debe ser mayor a 0';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
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
            children: [
              // Header informativo
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monitor_weight,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calculadora de IMC',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Índice de Masa Corporal',
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

              // Formulario de entrada
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de estatura
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _estaturaController,
                          decoration: InputDecoration(
                            labelText: 'Estatura (metros)',
                            hintText: 'Ej: 1.75',
                            prefixIcon: const Icon(Icons.height),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              _validarNumeroPositivo(val, 'estatura'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campo de peso
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: _pesoController,
                          decoration: InputDecoration(
                            labelText: 'Peso (kilogramos)',
                            hintText: 'Ej: 68.5',
                            prefixIcon: const Icon(Icons.line_weight),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              _validarNumeroPositivo(val, 'peso'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Resultado del IMC
              if (_imcResultado != null) ...[
                Card(
                  elevation: 4,
                  color: _getColorCategoria(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'RESULTADO',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _imcResultado!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _categoriaIMC!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildBarraIMC(_imcResultado!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calcularIMC,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calcular IMC'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _limpiar,
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpiar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Información sobre IMC
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📊 Escala del IMC',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildItemEscala(
                        'Bajo peso',
                        'Menos de 18.5',
                        Colors.blue,
                      ),
                      _buildItemEscala('Normal', '18.5 - 24.9', Colors.green),
                      _buildItemEscala('Sobrepeso', '25 - 29.9', Colors.orange),
                      _buildItemEscala('Obesidad', '30 o más', Colors.red),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget para construir la barra visual del IMC
  Widget _buildBarraIMC(double imc) {
    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          // Fondo de la barra con segmentos
          Row(
            children: [
              Expanded(flex: 185, child: Container(color: Colors.blue)),
              Expanded(flex: 65, child: Container(color: Colors.green)),
              Expanded(flex: 50, child: Container(color: Colors.orange)),
              Expanded(flex: 100, child: Container(color: Colors.red)),
            ],
          ),
          // Indicador de posición actual
          Align(
            alignment: Alignment((imc.clamp(15, 40) - 15) / 25 * 2 - 1, 0),
            child: Container(width: 4, height: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  /// Widget para items de la escala del IMC
  Widget _buildItemEscala(String categoria, String rango, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              categoria,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            rango,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Obtener color según la categoría del IMC
  Color _getColorCategoria() {
    switch (_categoriaIMC) {
      case 'Bajo peso':
        return Colors.blue;
      case 'Peso normal':
        return Colors.green;
      case 'Sobrepeso':
        return Colors.orange;
      case 'Obesidad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
