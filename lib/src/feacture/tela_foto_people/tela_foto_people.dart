import 'dart:io';
import 'package:EDS/src/model/user_model.dart';
import 'package:EDS/src/repository/http_service.dart';
import 'package:EDS/src/ui/message.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TelaFotoPeople extends StatefulWidget {
  UserModel user;

  TelaFotoPeople({super.key, required this.user});

  @override
  State<TelaFotoPeople> createState() => _TelaFotoPeopleState();
}

class _TelaFotoPeopleState extends State<TelaFotoPeople> {
  final ImagePicker _picker = ImagePicker();
  XFile? _photos;
  final HttpService httpService = HttpService();

  Future<void> _capturePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _photos = photo; // Corrigido o operador de atribuição
        widget.user.fotos.add(photo.path);
      });
    }
  }

  Future<bool?> showDialogConfirm() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Confirmação",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Tens certeza que a fotografia meio corpo foi tirada corretamente?",
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Não",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "Sim",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FOTO PESSOAL',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            _photos == null
                ? const Center(
                    child: Text(
                      "Sem foto capturada",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                : Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 4),
                      ),
                      height: 400,
                      child: Column(
                        children: [
                          Image.file(
                            File(_photos!.path),
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: FloatingActionButton.extended(
                label: Text(
                  _photos == null ? 'CAPTURAR FOTO' : 'ENVIAR OS DADOS',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: _photos == null
                    ? _capturePhoto
                    : () async {
                        final result = await showDialogConfirm();
                        if (result ?? false) {
                          print("Datos da pessoa:: ${widget.user.fotos}");
                          httpService.sendData(context, widget.user);
                        } else {
                          Message.showInfo(
                              "Por favor verifica a foto tirada!", context);
                        }
                      },
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
