import 'package:flutter/material.dart';

// Supondo que você tenha essas telas já criadas
import 'perfil.dart';
import 'login.dart';

class AgendamentoColeta extends StatefulWidget {
  final String nomePessoa;

  const AgendamentoColeta({Key? key, required this.nomePessoa})
      : super(key: key);

  @override
  State<AgendamentoColeta> createState() => _AgendamentoColetaState();
}

class _AgendamentoColetaState extends State<AgendamentoColeta> {
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  final TextEditingController _enderecoController = TextEditingController();

  String get _dataFormatada {
    if (_dataSelecionada == null) return 'Selecione a data';
    return '${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}';
  }

  String get _horaFormatada {
    if (_horaSelecionada == null) return 'Selecione a hora';
    final hora = _horaSelecionada!.hour.toString().padLeft(2, '0');
    final minuto = _horaSelecionada!.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaSelecionada = hora;
      });
    }
  }

  void _confirmarAgendamento() {
    if (_dataSelecionada == null ||
        _horaSelecionada == null ||
        _enderecoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    print('Agendamento confirmado para ${widget.nomePessoa}:');
    print('Data: $_dataFormatada');
    print('Hora: $_horaFormatada');
    print('Endereço: ${_enderecoController.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agendamento realizado com sucesso!')),
    );

    // Opcional: limpar campos após confirmação
    setState(() {
      _dataSelecionada = null;
      _horaSelecionada = null;
      _enderecoController.clear();
    });
  }

  @override
  void dispose() {
    _enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int horaAtual = DateTime.now().hour;
    String saudacao =
        (horaAtual >= 5 && horaAtual < 12) ? "Bom dia" : "Boa noite";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Agendamento de Coleta',
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
              '$saudacao, ${widget.nomePessoa}',
              style: const TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Agende a coleta para esta pessoa:',
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ListTile(
              title: Text(
                'Data: $_dataFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarData,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Hora: $_horaFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarHora,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(
                labelText: 'Endereço para coleta',
                labelStyle: const TextStyle(color: Color(0xFF4CAF50)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF388E3C)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _confirmarAgendamento,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  'Confirmar Agendamento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
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
