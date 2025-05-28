import 'package:flutter/material.dart';
import 'login.dart';
import 'perfil.dart';
import 'donationsucess.dart'; // IMPORTAÇÃO da tela de sucesso

class DoarMaterial extends StatefulWidget {
  const DoarMaterial({Key? key}) : super(key: key);

  @override
  State<DoarMaterial> createState() => _DoarMaterialState();
}

class _DoarMaterialState extends State<DoarMaterial> {
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

  final Map<String, double> _quantidadesSelecionadas = {};

  @override
  void initState() {
    super.initState();
    for (var material in _materiaisSelecionados.keys) {
      _quantidadesSelecionadas[material] = 0.5;
    }
  }

  void _selecionarQuantidade(String material) async {
    final isOleo = material == 'Óleo de cozinha';
    final unidade = isOleo ? 'litros' : 'kg';

    final quantidadeSelecionada = await showDialog<double>(
      context: context,
      builder: (context) {
        double selecionadoTemp = _quantidadesSelecionadas[material] ?? 0.5;
        return AlertDialog(
          title: Text('Selecione a quantidade em $unidade para $material'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  final quantidade = (index + 1) * 0.5;
                  return RadioListTile<double>(
                    title: Text('${quantidade.toStringAsFixed(1)} $unidade'),
                    value: quantidade,
                    groupValue: selecionadoTemp,
                    onChanged: (valor) {
                      setState(() {
                        selecionadoTemp = valor!;
                      });
                      (context as Element).markNeedsBuild();
                    },
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(selecionadoTemp),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (quantidadeSelecionada != null) {
      setState(() {
        _materiaisSelecionados[material] = true;
        _quantidadesSelecionadas[material] = quantidadeSelecionada;
      });
    }
  }

  void _confirmarDoacao() {
    Map<String, double> doacao = {};

    for (var material in _materiaisSelecionados.keys) {
      if (_materiaisSelecionados[material] == true) {
        final qtd = _quantidadesSelecionadas[material] ?? 0.5;
        doacao[material] = qtd;
      }
    }

    if (doacao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um material para doar.')),
      );
      return;
    }

    print('Doação confirmada:');
    doacao.forEach((material, qtd) {
      final unidade = material == 'Óleo de cozinha' ? 'litros' : 'kg';
      print('$material: ${qtd.toStringAsFixed(1)} $unidade');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Doação realizada com sucesso!')),
    );

    // Limpa as seleções
    setState(() {
      for (var material in _materiaisSelecionados.keys) {
        _materiaisSelecionados[material] = false;
        _quantidadesSelecionadas[material] = 0.5;
      }
    });

    // Navega para a tela de sucesso da doação
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DonationSuccess()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int horaAtual = DateTime.now().hour;
    String saudacao = (horaAtual >= 5 && horaAtual < 12) ? "Bom dia" : "Boa noite";

    bool algumSelecionado = _materiaisSelecionados.containsValue(true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Doar Materiais',
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
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
              'Quais materiais você deseja doar hoje?',
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
                  final quantidade = _quantidadesSelecionadas[material] ?? 0.5;
                  final unidade = material == 'Óleo de cozinha' ? 'litros' : 'kg';

                  return GestureDetector(
                    onTap: () {
                      _selecionarQuantidade(material);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.white : const Color(0xFF4CAF50),
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
                            const Icon(Icons.help_outline, size: 80, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text(
                            material,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF4CAF50),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isSelected)
                            Text(
                              '${quantidade.toStringAsFixed(1)} $unidade',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
                  onPressed: _confirmarDoacao,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Confirmar Doação',
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
