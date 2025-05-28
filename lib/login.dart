import 'package:flutter/material.dart';
import 'package:greencode/redefinirpassword.dart';  // Tela para inserir email e gerar token
import 'package:greencode/Cadastro.dart';
import 'package:greencode/transitionmaterial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dadosbase.dart'; // para getUserByEmail

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    // Chama a verificação após o frame inicial ser renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoggedUser();
    });
  }

  // Função para salvar o usuário logado no SharedPreferences
  Future<void> saveLoggedUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_user_email', email);
  }

  // Função para buscar o usuário logado no SharedPreferences
  Future<String?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('logged_user_email');
  }

  // Verifica se já existe usuário logado e navega direto
  Future<void> _checkLoggedUser() async {
    final email = await getLoggedUser();
    if (email != null) {
      final user = await getUserByEmail(email);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TransitionMaterial()),
        );
      }
    }
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(
                      Icons.recycling,
                      size: 200,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        suffixIcon: const Icon(Icons.mail_lock),
                        label: const Text('E-mail'),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 4,
                              color: Color.fromARGB(255, 67, 96, 107)),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(35), right: Radius.circular(35)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 4,
                              color: Color.fromARGB(255, 67, 96, 107)),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(35), right: Radius.circular(35)),
                        ),
                      ),
                      style: const TextStyle(fontSize: 25),
                      controller: _controllerEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        suffixIcon: IconButton(
                          onPressed: _toggleVisibility,
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        label: const Text('Senha'),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 4,
                              color: Color.fromARGB(255, 67, 96, 107)),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(35), right: Radius.circular(35)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 4,
                              color: Color.fromARGB(255, 67, 96, 107)),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(35), right: Radius.circular(35)),
                        ),
                      ),
                      style: const TextStyle(fontSize: 25),
                      controller: _controllerSenha,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = _controllerEmail.text.trim();
                          final senha = _controllerSenha.text;

                          try {
                            final user = await getUserByEmail(email);
                            if (user != null && user['senha'] == senha) {
                              await saveLoggedUser(email);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TransitionMaterial()),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Erro'),
                                  content: const Text('Email ou senha inválidos.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Erro'),
                                content: Text('Erro ao validar usuário: $e'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            letterSpacing: 10,
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Corrigido para ir para a tela correta de inserir email para token
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RedefinirPassword()),
                      );
                    },
                    child: const Text(
                      'Recuperar a Senha',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 74, 110, 76),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Cadastro()),
                      );
                    },
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 74, 110, 76),
                        fontWeight: FontWeight.bold,
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
