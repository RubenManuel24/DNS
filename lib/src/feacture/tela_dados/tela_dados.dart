// lib/screens/tela_dados.dart
import 'package:EDS/src/feacture/capture_phofo_screen/capture_phofo_screen.dart';
import 'package:EDS/src/model/user_model.dart';
import 'package:flutter/material.dart';

class TelaDados extends StatelessWidget {
  final UserModel user;

  const TelaDados({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('DADOS DO BI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildReadOnlyField('Nome Completo', user.nomeCompleto),
              _buildReadOnlyField('Número do BI', user.numeroBI),
              _buildReadOnlyField('Local de Residência', user.localResidencia),
              _buildReadOnlyField('Data de Nascimento', user.dataNascimento ),
              _buildReadOnlyField('Gênero', user.genero),
              _buildReadOnlyField('Estado Civil', user.estadoCivil),
              _buildReadOnlyField('Data de Emissão', user.dataEmissao),
              _buildReadOnlyField('Data de Validade', user.dataValidade ),
              _buildReadOnlyField('Local de Emissão', user.localEmissao),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size.fromHeight(56)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CapturePhotoScreen(user: user)),
                  );
                },
                child: Text('AVANÇAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }
}
