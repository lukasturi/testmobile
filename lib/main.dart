import 'package:flutter/material.dart';
import 'package:greencode/inicio.dart';
import 'package:greencode/redefinirpasswordfinale.dart'; // contém RedefinirNovaSenha
import 'package:greencode/inserttoken.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Greencode',
      home: const Inicio(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/inserirToken': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return InserirToken(email: args['email'], token: args['token']);
        },
        '/redefinirNovaSenha': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return RedefinirNovaSenha(email: args['email']);
        },
      },
    ),
  );
}
