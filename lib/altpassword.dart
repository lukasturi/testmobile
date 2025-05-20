import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dadosbase.dart'; // para usar getLoggedUserEmail() e getUserByEmail()
import 'login.dart'; // certifique-se de ter essa importação correta

class AltPassword extends StatefulWidget {
  const AltPassword({super.key});

  @override
  State<AltPassword> createState() => _AltPasswordState();
}

class _AltPasswordState extends State<AltPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _isLoading = true;
  String? _senhaAtualUsuario;

  @override
  void initState() {
    super.initState();
    _carregarSenhaAtual();
  }

  Future<void> _carregarSenhaAtual() async {
    String? emailLogado = await getLoggedUserEmail();
    if (emailLogado == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final user = await getUserByEmail(emailLogado);
    setState(() {
      _senhaAtualUsuario = user?['senha'];
      _isLoading = false;
    });
  }

  Future<void> _alterarSenha() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    String? emailLogado = await getLoggedUserEmail();
    if (emailLogado == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString('users_basic');
    if (usersJson == null) return;

    List<dynamic> users = jsonDecode(usersJson);
    int userIndex = users.indexWhere((u) => u['email'] == emailLogado);

    if (userIndex < 0) return;

    users[userIndex]['senha'] = _novaSenhaController.text;

    await prefs.setString('users_basic', jsonEncode(users));

    // Limpa os campos
    _senhaAtualController.clear();
    _novaSenhaController.clear();
    _confirmarSenhaController.clear();

    // Remove o usuário logado (logoff)
    await prefs.remove('logged_user_email');

    // Mostra o popup e redireciona
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sucesso'),
          content:
              const Text('Senha alterada com sucesso! Faça login novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // fecha o dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          const Login()), // ajuste se seu widget se chama diferente
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Alterar Senha',
          style: TextStyle(fontSize: 28, color: Colors.white),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                label: 'Senha Atual',
                controller: _senhaAtualController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a senha atual';
                  }
                  if (value != _senhaAtualUsuario) {
                    return 'Senha atual incorreta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                label: 'Nova Senha',
                controller: _novaSenhaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a nova senha';
                  }
                  if (value.length < 6) {
                    return 'A nova senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                label: 'Confirmar Nova Senha',
                controller: _confirmarSenhaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme a nova senha';
                  }
                  if (value != _novaSenhaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _alterarSenha();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Alterar Senha'),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF388E3C)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF388E3C)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF388E3C)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
