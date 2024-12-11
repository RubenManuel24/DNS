import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:EDS/src/ui/message.dart';
import 'package:EDS/src/model/user_model.dart';
import 'package:EDS/src/ui/loader_animation.dart';
import 'package:EDS/src/feacture/home/home_scren.dart';

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

      // Criar a requisição multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.22.50.55:3333/clientes'), // Substituir pela URL correta
      );
      
      // Adicionar campos de texto ao formulário
      request.fields['primeiro_nome'] = user.nomeCompleto;
      request.fields['bi_identidade'] = user.numeroBI;
      request.fields['created_at'] = user.localResidencia;
      request.fields['dt_nascimento'] = user.dataNascimento;
      request.fields['genero'] = user.genero;
      request.fields['estado_civil'] = user.estadoCivil;
      request.fields['dt_emissao'] = user.dataEmissao;
      request.fields['dt_caducidade'] = user.dataValidade;
      request.fields['local_emissao'] = user.localEmissao;

      // Adicionar a foto principal (personFotos) como arquivo
      if (user.personFotos.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto', // Nome esperado pelo back-end
            user.personFotos,
          ),
        );
      }
      if (user.personFotos.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'doc_front', // Nome esperado pelo back-end
            user.docFront,
          ),
        );
      }
      if (user.personFotos.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'doc_back', // Nome esperado pelo back-end
            user.docBack,
          ),
        );
      }

      // Enviar a requisição
      var response = await request.send();

      // Fechar o loader após a resposta
      Navigator.pop(context);

      if (response.statusCode == 200) {
        Message.showSucess("Dados enviados com sucesso!", context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );

      } else {
        Message.showErro("Falha ao enviar os dados", context);
      }

    } catch (e, s) {
      // Fechar o loader em caso de erro
      log(error: e, stackTrace: s, 'Erro encontrado');
      Navigator.pop(context);
      Message.showErro("Erro de conexão ${e}", context);
    }
  }
}
