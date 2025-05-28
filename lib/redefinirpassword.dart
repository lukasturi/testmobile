import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dadosbase.dart';

class RedefinirPassword extends StatefulWidget {
  const RedefinirPassword({super.key});

  @override
  State<RedefinirPassword> createState() => _RedefinirPasswordState();
}

class _RedefinirPasswordState extends State<RedefinirPassword> {
  final TextEditingController _emailController = TextEditingController();

  String _gerarToken() {
    final random = Random();
    return List.generate(4, (_) => random.nextInt(10)).join();
  }

  Future<void> _mostrarAlerta(String titulo, String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _redefinirSenha() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      await _mostrarAlerta('Erro', 'Por favor, preencha o campo de e-mail.');
      return;
    }

    final user = await getUserByEmail(email);

    if (user == null) {
      await _mostrarAlerta('Erro', 'E-mail não cadastrado.');
      return;
    }

    final token = _gerarToken();

    // Salvar token no SharedPreferences vinculado ao usuário
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString('users_basic');

    if (usersJson != null) {
      List<dynamic> users = jsonDecode(usersJson);
      for (var usuario in users) {
        if (usuario['email'].toString().toLowerCase() == email.toLowerCase()) {
          usuario['resetToken'] = token;
          break;
        }
      }
      await prefs.setString('users_basic', jsonEncode(users));
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Token Gerado'),
        content: Text('Seu token para redefinição é:\n\n$token'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // fecha o alerta
              Navigator.pushNamed(
                context,
                '/inserirToken',
                arguments: {'email': email, 'token': token},
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Green Code',
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81C784),
                Color(0xFF388E3C),
                Color.fromARGB(255, 74, 110, 76),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.recycling, size: 200, color: Color(0xFF388E3C)),
              const SizedBox(height: 20),
              const Text(
                'Redefinir Senha',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Informe o e-mail para o qual deseja redefinir a sua senha:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: const Text('E-mail'),
                  suffixIcon: const Icon(Icons.mail_lock),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(35),
                      right: Radius.circular(35),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(35),
                      right: Radius.circular(35),
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _redefinirSenha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                  ),
                  child: const Text(
                    'Redefinir Senha',
                    style: TextStyle(
                      letterSpacing: 10,
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
}
