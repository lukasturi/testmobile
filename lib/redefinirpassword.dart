import 'package:flutter/material.dart';
import 'package:greencode/login.dart';

class RedefinirPassword extends StatefulWidget {
  const RedefinirPassword({super.key});

  @override
  State<RedefinirPassword> createState() => _RedefinirPasswordState();
}

class _RedefinirPasswordState extends State<RedefinirPassword> {
  final TextEditingController _emailController = TextEditingController();

  void _mostrarAlerta(String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sucesso'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _redefinirSenha() {
    if (_emailController.text.trim().isNotEmpty) {
      _mostrarAlerta('E-mail enviado com sucesso.');
    } else {
      _mostrarAlerta('Por favor, preencha o campo de e-mail.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greencode', style: TextStyle(fontSize: 35)),
        backgroundColor: const Color.fromARGB(255, 13, 199, 112),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Redefinir Senha',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Informe o e-mail para o qual deseja redefinir a sua senha:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: Text('E-mail'),
                suffixIcon: Icon(Icons.email),
                contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 4, color: const Color.fromARGB(255, 67, 96, 107)),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(35),
                    right: Radius.circular(35),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 4, color: const Color.fromARGB(255, 67, 96, 107)),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(35),
                    right: Radius.circular(35),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _redefinirSenha,
                child: Text(
                  'Redefinir Senha',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 22,
                    color: const Color.fromARGB(255, 4, 167, 59),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              'Voltar ao Login',
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 96, 207, 226),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
