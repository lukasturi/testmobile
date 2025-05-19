import 'package:flutter/material.dart';
import 'perfil.dart';
import 'login.dart';

class AgendamentoColeta extends StatelessWidget {
  final String nomePerfil;

  const AgendamentoColeta({super.key, required this.nomePerfil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 199, 112),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 167, 59),
        title: const Text('Agendamento de coleta'),
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Perfil()),
                );
              } else if (value == 'sair') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sair',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sair'),
                ),
              ),
            ],
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Agendamento de coleta com $nomePerfil',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
