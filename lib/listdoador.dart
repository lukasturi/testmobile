import 'package:flutter/material.dart';
import 'agendamento_coleta.dart';
import 'perfil.dart';
import 'login.dart';

class PerfisCorrespondentes extends StatefulWidget {
  const PerfisCorrespondentes({super.key});

  @override
  State<PerfisCorrespondentes> createState() => _PerfisCorrespondentesState();
}

class _PerfisCorrespondentesState extends State<PerfisCorrespondentes> {
  final Map<int, bool> _isHovered = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Fundo claro sustentável
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Green Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81C784), // Verde claro
                Color(0xFF388E3C), // Verde escuro
                Color.fromARGB(255, 74, 110, 76), // Verde escuro
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
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Perfis correspondentes à sua escolha e localização',
              style: TextStyle(
                fontSize: 22,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildPerfilCard(
              context,
              index: 0,
              nome: 'Ana Souza',
              material: 'Doando: Garrafas PET (15 unidades)',
              localizacao: 'Bairro Jardim das Flores',
              distanciaKm: 2.4,
            ),
            _buildPerfilCard(
              context,
              index: 1,
              nome: 'Carlos Silva',
              material: 'Doando: Óleo de cozinha (2 Litros)',
              localizacao: 'Centro',
              distanciaKm: 1.1,
            ),
            _buildPerfilCard(
              context,
              index: 2,
              nome: 'Marina Oliveira',
              material: 'Doando: Tampinhas de plástico (1 sacola cheia)',
              localizacao: 'Vila Verde',
              distanciaKm: 3.7,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilCard(
    BuildContext context, {
    required int index,
    required String nome,
    required String material,
    required String localizacao,
    required double distanciaKm,
  }) {
    final hovered = _isHovered[index] ?? false;
    final Color corCaixa = hovered
        ? const Color.fromARGB(255, 6, 190, 90)
        : const Color.fromARGB(255, 4, 167, 59);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered[index] = true),
        onExit: (_) => setState(() => _isHovered[index] = false),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AgendamentoColeta(nomePessoa: nome),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: corCaixa,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  material,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  '📍 Localização: $localizacao',
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  '📏 Distância: ${distanciaKm.toStringAsFixed(1)} km de você',
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
