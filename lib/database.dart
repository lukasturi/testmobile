import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserBasic(
    String nome, String email, String senha, String telefone) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('nome', nome);
  await prefs.setString('email', email);
  await prefs.setString('senha', senha);
  await prefs.setString('telefone', telefone);
}

Future<Map<String, String>?> getUserByEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  final savedEmail = prefs.getString('email');

  if (savedEmail == null || savedEmail != email) {
    return null; // usuário não encontrado
  }

  // Retorna todos os dados do usuário
  return {
    'nome': prefs.getString('nome') ?? '',
    'email': savedEmail,
    'senha': prefs.getString('senha') ?? '',
    'telefone': prefs.getString('telefone') ?? '',
  };
}
