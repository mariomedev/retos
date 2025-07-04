import 'package:flutter/material.dart';

class Dia6 extends StatefulWidget {
  const Dia6({super.key});

  @override
  State<Dia6> createState() => _Dia6State();
}

class _Dia6State extends State<Dia6> {
  final TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == "") return 'El Campo no puede se nulo';
    if (value!.contains('@') && value.contains('.')) return null;
    return 'Formulario inválido';
  }

  String? _validateAge(String? value) {
    if (value == "") return 'El Campo no puede se nulo';
    if (int.parse(value!) >= 18) return null;
    return 'Verifica la edad (Tienes que ser mayor a 18 años)';
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso'),
        ),
      );
      _cleanField();
    }
  }

  void _cleanField() {
    nameController.clear();
    ageController.clear();
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Día 6'),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                validator: (value) => _validateEmail(value),
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextFormField(
                controller: ageController,
                validator: (value) => _validateAge(value),
                decoration: const InputDecoration(hintText: 'Age'),
              ),
              ElevatedButton(
                onPressed: () => _register(context),
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
