import 'package:flutter/material.dart';
import '../main.dart'; // Para usar AppDrawer

/// Pantalla de formulario de registro con validaciones - Interfaz mejorada
class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarController = TextEditingController();

  // Estados para controles visuales
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _aceptoTerminos = false;
  bool _intentoEnviar = false;

  @override
  void dispose() {
    // Limpiar controladores para evitar memory leaks
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  /// Validación personalizada para el campo nombre
  String? _validarNombre(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }

  /// Validación personalizada para el campo email
  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'El email es obligatorio';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) return 'Ingresa un email válido';
    return null;
  }

  /// Validación personalizada para el campo contraseña
  String? _validarPassword(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 6) return 'Debe tener al menos 6 caracteres';
    return null;
  }

  /// Validación para confirmar que las contraseñas coincidan
  String? _validarConfirmacion(String? value) {
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Procesar envío del formulario
  void _enviar() {
    setState(() {
      _intentoEnviar = true;
    });

    if (_formKey.currentState!.validate()) {
      if (!_aceptoTerminos) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes aceptar los términos y condiciones'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Procesar datos del formulario
      final nombre = _nombreController.text.trim();
      final email = _emailController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Registro exitoso: $nombre ($email)'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Limpiar todos los campos del formulario
  void _limpiar() {
    _formKey.currentState!.reset();
    _nombreController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmarController.clear();
    setState(() {
      _aceptoTerminos = false;
      _intentoEnviar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Registro'),
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
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header del formulario mejorado
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
                        Icons.person_add,
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
                            'Formulario de Registro',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Completa todos los campos obligatorios',
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

              // Formulario
              Form(
                key: _formKey,
                autovalidateMode: _intentoEnviar
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    // Campo: Nombre
                    _buildTextField(
                      controller: _nombreController,
                      label: 'Nombre completo',
                      icon: Icons.person,
                      validator: _validarNombre,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 20),

                    // Campo: Email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validarEmail,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 20),

                    // Campo: Contraseña
                    _buildPasswordField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      obscureText: _obscurePassword,
                      onToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: _validarPassword,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 20),

                    // Campo: Confirmar contraseña
                    _buildPasswordField(
                      controller: _confirmarController,
                      label: 'Confirmar contraseña',
                      obscureText: _obscureConfirm,
                      onToggle: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                      validator: _validarConfirmacion,
                      textInputAction: TextInputAction.done,
                    ),

                    const SizedBox(height: 24),

                    // Checkbox términos y condiciones
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _aceptoTerminos,
                            onChanged: (val) {
                              setState(() {
                                _aceptoTerminos = val ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Acepto términos y condiciones',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Debes aceptar para continuar',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _enviar,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                            ),
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _limpiar,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: Text(
                              'Limpiar',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  /// Widget para construir campos de texto normales
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        keyboardType: keyboardType,
        validator: validator,
        textInputAction: textInputAction,
      ),
    );
  }

  /// Widget para construir campos de contraseña
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        validator: validator,
        textInputAction: textInputAction,
      ),
    );
  }
}
