import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'login.dart'; // importe a tela de login para poder navegar até ela

class RedefinirNovaSenha extends StatefulWidget {
  final String email;

  const RedefinirNovaSenha({super.key, required this.email});

  @override
  State<RedefinirNovaSenha> createState() => _RedefinirNovaSenhaState();
}

class _RedefinirNovaSenhaState extends State<RedefinirNovaSenha> {
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();

  bool _obscureNovaSenha = true;
  bool _obscureConfirmaSenha = true;

  void _toggleNovaSenha() {
    setState(() {
      _obscureNovaSenha = !_obscureNovaSenha;
    });
  }

  void _toggleConfirmaSenha() {
    setState(() {
      _obscureConfirmaSenha = !_obscureConfirmaSenha;
    });
  }

  void _mostrarAlerta(String titulo, String mensagem, {bool sucesso = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o alerta
              if (sucesso) {
                // Se foi sucesso, redireciona para login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmarRedefinicao() async {
    final novaSenha = _novaSenhaController.text;
    final confirmaSenha = _confirmaSenhaController.text;

    if (novaSenha.isEmpty || confirmaSenha.isEmpty) {
      _mostrarAlerta('Erro', 'Por favor, preencha ambos os campos.');
      return;
    }
    if (novaSenha != confirmaSenha) {
      _mostrarAlerta('Erro', 'As senhas não coincidem.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users_basic');

    if (usersJson == null) {
      _mostrarAlerta('Erro', 'Erro interno: usuários não encontrados.');
      return;
    }

    List<dynamic> users = jsonDecode(usersJson);

    final index = users.indexWhere(
      (u) => u['email'].toString().toLowerCase() == widget.email.toLowerCase(),
    );

    if (index == -1) {
      _mostrarAlerta('Erro', 'Usuário não encontrado.');
      return;
    }

    // Atualiza a senha do usuário
    users[index]['senha'] = novaSenha;

    // Remove o token de redefinição (se existir)
    users[index].remove('resetToken');

    // Salva as alterações no SharedPreferences
    await prefs.setString('users_basic', jsonEncode(users));

    // Atualiza o usuário logado, caso seja o mesmo que redefiniu a senha
    final loggedUserEmail = prefs.getString('logged_user_email');
    if (loggedUserEmail != null &&
        loggedUserEmail.toLowerCase() == widget.email.toLowerCase()) {
      await prefs.setString('logged_user_email', widget.email);
    }

    _mostrarAlerta('Sucesso', 'Senha redefinida com sucesso!', sucesso: true);
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
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_reset,
                    size: 120,
                    color: Color(0xFF388E3C),
                  ),
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
                    'Informe sua nova senha abaixo:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _novaSenhaController,
                    obscureText: _obscureNovaSenha,
                    decoration: InputDecoration(
                      label: const Text('Nova Senha'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNovaSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _toggleNovaSenha,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 4, color: Color.fromARGB(255, 67, 96, 107)),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(35),
                          right: Radius.circular(35),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 4, color: Color.fromARGB(255, 67, 96, 107)),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(35),
                          right: Radius.circular(35),
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _confirmaSenhaController,
                    obscureText: _obscureConfirmaSenha,
                    decoration: InputDecoration(
                      label: const Text('Confirmar Senha'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmaSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _toggleConfirmaSenha,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 4, color: Color.fromARGB(255, 67, 96, 107)),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(35),
                          right: Radius.circular(35),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 4, color: Color.fromARGB(255, 67, 96, 107)),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(35),
                          right: Radius.circular(35),
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmarRedefinicao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                      ),
                      child: const Text(
                        'Confirmar',
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
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
              child: Center(
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.contain,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
