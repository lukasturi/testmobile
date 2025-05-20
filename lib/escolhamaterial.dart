import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'perfil.dart';
import 'listdoador.dart';

class EscolhaMaterial extends StatefulWidget {
  const EscolhaMaterial({super.key});

  @override
  State<EscolhaMaterial> createState() => _EscolhaMaterialState();
}

class _EscolhaMaterialState extends State<EscolhaMaterial> {
  final Map<String, bool> _materiaisSelecionados = {
    'Garrafa PET': false,
    'Óleo de cozinha': false,
    'Tampinha de Plástico': false,
    'Lata de Alumínio': false,
  };

  final Map<String, String> _imagensMateriais = {
    'Garrafa PET': 'images/garrafa_pet.png',
    'Óleo de cozinha': 'images/oleo_cozinha.png',
    'Tampinha de Plástico': 'images/tampinha.png',
    'Lata de Alumínio': 'images/lata_aluminio.png',
  };

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_user_email'); // remove usuário logado
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int horaAtual = DateTime.now().hour;
    String saudacao =
        (horaAtual >= 5 && horaAtual < 12) ? "Bom dia" : "Boa noite";

    bool algumSelecionado = _materiaisSelecionados.containsValue(true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Green Code',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Perfil()),
                );
              } else if (value == 'sair') {
                logout(context);
              }
            },
            icon: const Icon(Icons.dehaze, size: 28, color: Colors.white),
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
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              saudacao,
              style: const TextStyle(
                fontSize: 35,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Qual material você deseja coletar hoje?',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                children: _materiaisSelecionados.keys.map((material) {
                  final isSelected = _materiaisSelecionados[material] ?? false;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _materiaisSelecionados[material] = !isSelected;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF4CAF50) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF4CAF50),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_imagensMateriais[material] != null)
                            Image.asset(
                              _imagensMateriais[material]!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            )
                          else
                            const Icon(Icons.help_outline,
                                size: 80, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text(
                            material,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF4CAF50),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            if (algumSelecionado)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PerfisCorrespondentes(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text(
                    'Próximo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
