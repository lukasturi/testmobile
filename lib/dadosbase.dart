import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Salva usuário completo (básico + endereço) na lista 'users_basic' no SharedPreferences
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
  int index = users.indexWhere((u) => u['email'] == user['email']);
  if (index >= 0) {
    // Atualiza o usuário existente
    users[index] = user;
  } else {
    // Adiciona novo usuário
    users.add(user);
  }

  // Salva a lista atualizada
  await prefs.setString('users_basic', jsonEncode(users));
}

/// Busca usuário pelo email na lista 'users_basic' no SharedPreferences
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

/// Atualiza os dados de um usuário existente pelo email
Future<bool> updateUserByEmail(String email, Map<String, dynamic> updatedData) async {
  final prefs = await SharedPreferences.getInstance();

  final String? usersJson = prefs.getString('users_basic');
  if (usersJson == null) return false;

  List<dynamic> users = [];
  final decoded = jsonDecode(usersJson);
  if (decoded is List) {
    users = decoded;
  }

  final index = users.indexWhere((u) => u['email'] == email);
  if (index == -1) return false;

  users[index] = updatedData;
  await prefs.setString('users_basic', jsonEncode(users));
  return true;
}

/// Atualiza somente a senha do usuário pelo email
Future<bool> updateUserPassword(String email, String novaSenha) async {
  final prefs = await SharedPreferences.getInstance();

  final String? usersJson = prefs.getString('users_basic');
  if (usersJson == null) return false;

  List<dynamic> users = [];
  final decoded = jsonDecode(usersJson);
  if (decoded is List) {
    users = decoded;
  }

  final index = users.indexWhere((u) => u['email'] == email);
  if (index == -1) return false;

  Map<String, dynamic> user = Map<String, dynamic>.from(users[index]);
  user['senha'] = novaSenha;
  users[index] = user;

  await prefs.setString('users_basic', jsonEncode(users));
  return true;
}

/// Salva o email do usuário logado para manter a sessão ativa
Future<void> saveLoggedUser(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('logged_user_email', email);
}

/// Recupera o email do usuário logado (se houver)
Future<String?> getLoggedUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('logged_user_email');
}

/// Remove o usuário logado (logout)
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('logged_user_email');
}
