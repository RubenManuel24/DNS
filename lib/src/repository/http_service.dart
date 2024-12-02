import 'package:EDS/src/feacture/home/home_scren.dart';
import 'package:EDS/src/model/user_model.dart';
import 'package:EDS/src/ui/loader_animation.dart';
import 'package:EDS/src/ui/message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class HttpService {
  Future<void> sendData(BuildContext context, UserModel user) async {
    // Exibir o loader antes da requisição
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoaderAnimation(); // Exibir animação de carregamento
      },
    );

    try {
      final response = await http.post(
        Uri.parse(
            'https://sua-api.com/endpoint'), // Substituir pela URL correta
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      // Fechar o loader após a resposta
      Navigator.pop(context);

      if (response.statusCode == 200) {
        user = UserModel(
          nomeCompleto: '',
          numeroBI: '',
          localResidencia: '',
          dataNascimento: '',
          genero: '',
          estadoCivil: '',
          fotos: [],
          dataEmissao: '',
          localEmissao: '',
          dataValidade: '',
        );

        Message.showSucess("Dados enviados com sucesso!", context);
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );

      } else {
        Message.showErro(
          "Falha ao enviar os dados",
          context,
        );
      }
    } catch (e) {
      // Fechar o loader em caso de erro
      Navigator.pop(context);
      Message.showErro("Erro de conexão", context);
    }
  }
}
