import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dadosbase.dart';
import 'altpassword.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  bool _isLoading = true;

  Map<String, bool> _editando = {
    'telefone': false,
    'rua': false,
    'numero': false,
    'cidade': false,
    'estado': false,
    'cep': false,
  };

  @override
  void initState() {
    super.initState();
    _carregarDadosPerfil();
  }

  Future<void> _carregarDadosPerfil() async {
    String? emailLogado = await getLoggedUserEmail();
    if (emailLogado == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final user = await getUserByEmail(emailLogado);

    setState(() {
      _nomeController.text = user?['nome'] ?? '';
      _emailController.text = user?['email'] ?? '';
      _telefoneController.text = user?['telefone'] ?? '';
      _ruaController.text = user?['rua'] ?? '';
      _numeroController.text = user?['numero'] ?? '';
      _cidadeController.text = user?['cidade'] ?? '';
      _estadoController.text = user?['estado'] ?? '';
      _cepController.text = user?['cep'] ?? '';
      _isLoading = false;
    });
  }

  Future<void> _salvarCampo(String campo, String valor) async {
    String? emailLogado = await getLoggedUserEmail();
    if (emailLogado == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString('users_basic');
    List<dynamic> users = [];

    if (usersJson != null) {
      final decoded = jsonDecode(usersJson);
      if (decoded is List) users = decoded;
    }

    int userIndex = users.indexWhere((u) => u['email'] == emailLogado);
    if (userIndex >= 0) {
      users[userIndex][campo] = valor;
      await prefs.setString('users_basic', jsonEncode(users));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$campo salvo com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Meu Perfil',
          style: TextStyle(fontSize: 28, color: Colors.white),
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Color(0xFF388E3C),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        label: 'Nome',
                        controller: _nomeController,
                        icon: Icons.person,
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'Email',
                        controller: _emailController,
                        icon: Icons.email,
                        enabled: false,
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField(
                        label: 'Telefone',
                        controller: _telefoneController,
                        icon: Icons.phone,
                        campo: 'telefone',
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField(
                        label: 'Rua',
                        controller: _ruaController,
                        icon: Icons.location_city,
                        campo: 'rua',
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField(
                        label: 'Número',
                        controller: _numeroController,
                        icon: Icons.format_list_numbered,
                        campo: 'numero',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField(
                        label: 'Cidade',
                        controller: _cidadeController,
                        icon: Icons.location_city,
                        campo: 'cidade',
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField(
                        label: 'Estado',
                        controller: _estadoController,
                        icon: Icons.map,
                        campo: 'estado',
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField(
                        label: 'CEP',
                        controller: _cepController,
                        icon: Icons.local_post_office,
                        campo: 'cep',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AltPassword()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Alterar Senha'),
                        ),
                      ),
                      const SizedBox(height: 80), // espaço para rodapé
                    ],
                  ),
                ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
  }) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF388E3C)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF388E3C)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF9E9E9E)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF388E3C)),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String campo,
    TextInputType keyboardType = TextInputType.text,
  }) {
    bool isEditing = _editando[campo] ?? false;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: isEditing,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: const Color(0xFF388E3C)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF388E3C)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF388E3C)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9E9E9E)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, preencha o campo $label';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit,
              color: const Color(0xFF388E3C)),
          onPressed: () async {
            if (isEditing) {
              // salva a edição ao clicar no check
              if (_formKey.currentState!.validate()) {
                await _salvarCampo(campo, controller.text);
                setState(() {
                  _editando[campo] = false;
                });
              }
            } else {
              // ativa edição
              setState(() {
                _editando[campo] = true;
              });
            }
          },
        ),
      ],
    );
  }
}
