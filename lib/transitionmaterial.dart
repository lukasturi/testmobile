import 'package:flutter/material.dart';
import 'selecionaraction.dart'; // Certifique-se que o caminho está correto

class TransitionMaterial extends StatefulWidget {
  const TransitionMaterial({super.key});

  @override
  _TransitionMaterialState createState() => _TransitionMaterialState();
}

class _TransitionMaterialState extends State<TransitionMaterial> {
  @override
  void initState() {
    super.initState();
    // Aguarda 3 segundos e navega para Selecionaraction
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Selecionaraction()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo com imagem - importante: se for Flutter Web, remova a barra inicial do caminho!
          Image.asset(
            'images/reciclagem.png', // Cheque se a imagem está em assets/images/reciclagem.png e se foi declarada no pubspec.yaml
            fit: BoxFit.cover,
          ),

          // Conteúdo centralizado sobre a imagem
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Green Code',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 111, 161, 114),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Inovação que transforma o futuro, tecnologia que respeita o planeta.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 111, 161, 114),
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
