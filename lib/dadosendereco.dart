import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Salva ou atualiza um usuário completo (básico + endereço)
Future<void> saveUserBasic(Map<String, dynamic> user) async {
  final prefs = await SharedPreferences.getInstance();

  List<dynamic> users = [];

  final String? usersJson = prefs.getString('users_basic');
  if (usersJson != null && usersJson.isNotEmpty) {
    try {
      final decoded = jsonDecode(usersJson);
      if (decoded is List) users = decoded;
    } catch (_) {
      // Se falhar, assume lista vazia
    }
  }

  // Atualiza usuário existente ou adiciona novo
  int index = users.indexWhere((u) => u['email'] == user['email']);
  if (index >= 0) {
    users[index] = user;
  } else {
    users.add(user);
  }

  await prefs.setString('users_basic', jsonEncode(users));
}

/// Busca um usuário pelo e-mail
Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();

  final String? usersJson = prefs.getString('users_basic');
  if (usersJson == null || usersJson.isEmpty) return null;

  try {
    final decoded = jsonDecode(usersJson);
    if (decoded is List) {
      final user =
          decoded.firstWhere((u) => u['email'] == email, orElse: () => null);
      if (user != null) {
        return Map<String, dynamic>.from(user);
      }
    }
  } catch (_) {
    // erro ao decodificar ou buscar usuário
  }

  return null;
}

/// Salva o e-mail do usuário logado
Future<void> saveLoggedUser(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('logged_user_email', email);
}

/// Recupera o e-mail do usuário logado
Future<String?> getLoggedUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('logged_user_email');
}

/// Realiza logout do usuário
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('logged_user_email');
}
