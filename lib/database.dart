import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserBasic(String nome, String email, String senha, String telefone) async {
  final prefs = await SharedPreferences.getInstance();
  final usersJson = prefs.getString('users_basic');

  List<dynamic> users = [];
  if (usersJson != null) {
    users = jsonDecode(usersJson);
  }

  // Verifica se usuário já existe
  final index = users.indexWhere((u) => u['email'] == email);
  if (index >= 0) {
    // Atualiza usuário existente
    users[index] = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
    };
  } else {
    // Adiciona novo usuário
    users.add({
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
    });
  }

  await prefs.setString('users_basic', jsonEncode(users));
}

Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  final usersJson = prefs.getString('users_basic');

  if (usersJson == null) {
    return null;
  }

  List<dynamic> users = jsonDecode(usersJson);
  final user = users.firstWhere(
    (u) => u['email'].toString().toLowerCase() == email.toLowerCase(),
    orElse: () => null,
  );

  if (user == null) return null;

  return {
    'nome': user['nome'],
    'email': user['email'],
    'senha': user['senha'],
    'telefone': user['telefone'],
  };
}
