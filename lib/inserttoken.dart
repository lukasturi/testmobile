import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InserirToken extends StatefulWidget {
  final String email;
  final String token; // Token recebido na navegação, usado para fallback

  const InserirToken({super.key, required this.email, required this.token});

  @override
  State<InserirToken> createState() => _InserirTokenState();
}

class _InserirTokenState extends State<InserirToken> {
  final TextEditingController _tokenController = TextEditingController();

  void _mostrarAlerta(String titulo, String mensagem) {
    showDialog(
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

  Future<void> _validarToken() async {
    final tokenDigitado = _tokenController.text.trim();

    if (tokenDigitado.isEmpty) {
      _mostrarAlerta('Erro', 'Por favor, insira o token recebido por e-mail.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users_basic');

    if (usersJson == null) {
      _mostrarAlerta('Erro', 'Erro interno: usuários não encontrados.');
      return;
    }

    List<dynamic> users = jsonDecode(usersJson);

    final user = users.firstWhere(
      (u) => u['email'].toString().toLowerCase() == widget.email.toLowerCase(),
      orElse: () => null,
    );

    if (user == null) {
      _mostrarAlerta('Erro', 'Usuário não encontrado.');
      return;
    }

    final tokenArmazenado = user['resetToken'] ?? '';

    if (tokenDigitado != tokenArmazenado) {
      _mostrarAlerta('Erro', 'Token inválido. Por favor, tente novamente.');
      return;
    }

    // Token válido, navega para a tela de redefinir senha,
    // passando o email como argumento
    Navigator.pushReplacementNamed(
      context,
      '/redefinirNovaSenha',
      arguments: {'email': widget.email},
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text('Inserir Token'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Insira o token que foi enviado para seu e-mail:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: 'Token',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              style: const TextStyle(fontSize: 22),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _validarToken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF04A73B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: const Text(
                  'Validar Token',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
