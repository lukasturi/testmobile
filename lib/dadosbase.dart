import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Salva usuário completo (básico + endereço) na lista 'users_basic' no SharedPreferences
Future<void> saveUserBasic(Map<String, dynamic> user) async {
  final prefs = await SharedPreferences.getInstance();

  final String? usersJson = prefs.getString('users_basic');
  List<dynamic> users = [];

  if (usersJson != null) {
    final decoded = jsonDecode(usersJson);
    if (decoded is List) {
      users = decoded;
    }
  }

  // Verifica se o email já está cadastrado
  bool emailExiste = users.any((u) => u['email'] == user['email']);
  if (emailExiste) {
    throw Exception('Email já cadastrado');
  }

  // Adiciona o novo usuário
  users.add(user);

  // Salva a lista atualizada
  await prefs.setString('users_basic', jsonEncode(users));
}

// Busca usuário pelo email na lista 'users_basic' no SharedPreferences
Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();

  final String? usersJson = prefs.getString('users_basic');
  if (usersJson == null) return null;

  List<dynamic> users = [];
  final decoded = jsonDecode(usersJson);
  if (decoded is List) {
    users = decoded;
  }

  try {
    final user = users.firstWhere((u) => u['email'] == email);
    return Map<String, dynamic>.from(user);
  } catch (e) {
    return null; // usuário não encontrado
  }
}

// Salva o email do usuário logado para manter a sessão ativa
Future<void> saveLoggedUser(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('logged_user_email', email);
}

// Recupera o email do usuário logado (se houver)
Future<String?> getLoggedUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('logged_user_email');
}

// Remove o usuário logado (logout)
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('logged_user_email');
}
