import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveEndereco({
  required String rua,
  required String numero,
  required String cidade,
  required String estado,
  required String cep,
}) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, String> endereco = {
    'rua': rua,
    'numero': numero,
    'cidade': cidade,
    'estado': estado,
    'cep': cep,
  };
  await prefs.setString('user_endereco', jsonEncode(endereco));
}

// Opcional: função para carregar os dados do endereço
Future<Map<String, String>?> loadEndereco() async {
  final prefs = await SharedPreferences.getInstance();
  String? enderecoString = prefs.getString('user_endereco');
  Map<String, dynamic> enderecoMap = jsonDecode(enderecoString!);
  return enderecoMap.map((key, value) => MapEntry(key, value.toString()));
}
