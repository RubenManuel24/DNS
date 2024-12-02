// lib/screens/tela_dados.dart
import 'package:EDS/src/feacture/capture_phofo_screen/capture_phofo_screen.dart';
import 'package:EDS/src/feacture/home/home_scren.dart';
import 'package:EDS/src/model/user_model.dart';
import 'package:EDS/src/ui/message.dart';
import 'package:flutter/material.dart';

class TelaDados extends StatefulWidget {
  final UserModel user;

  const TelaDados({super.key, required this.user});

  @override
  State<TelaDados> createState() => _TelaDadosState();
}

class _TelaDadosState extends State<TelaDados> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 2),() => Message.showSucess("Código QR do BI lido com sucesso!", context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'DADOS DO BI',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _buildReadOnlyField('Nome Completo', widget.user.nomeCompleto),
              _buildReadOnlyField('Número do BI', widget.user.numeroBI),
              _buildReadOnlyField(
                  'Local de Residência', widget.user.localResidencia),
              _buildReadOnlyField(
                  'Data de Nascimento', widget.user.dataNascimento),
              _buildReadOnlyField('Gênero', widget.user.genero),
              _buildReadOnlyField('Estado Civil', widget.user.estadoCivil),
              _buildReadOnlyField('Data de Emissão', widget.user.dataEmissao),
              _buildReadOnlyField('Data de Validade', widget.user.dataValidade),
              _buildReadOnlyField('Local de Emissão', widget.user.localEmissao),
              SizedBox(height: 10),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CapturePhotoScreen(user: widget.user)),
                  );
                },
                label: Text(
                  'AVANÇAR',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
