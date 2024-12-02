import 'dart:io';
import 'package:EDS/src/feacture/tela_foto_people/tela_foto_people.dart';
import 'package:EDS/src/model/user_model.dart';
import 'package:EDS/src/ui/message.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CapturePhotoScreen extends StatefulWidget {
  final UserModel user;

  const CapturePhotoScreen({super.key, required this.user});

  @override
  _CapturePhotoScreenState createState() => _CapturePhotoScreenState();
}

class _CapturePhotoScreenState extends State<CapturePhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _photos = [];

  Future<void> _capturePhoto() async {
    if (_photos.length >= 3) return; // Impede de tirar mais que 3 fotos

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _photos.add(photo);
        widget.user.fotos
            .add(photo.path); // Adiciona foto à lista de fotos do usuário
      });
    }
  }

  Future<bool?> showDialogConfirm() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Confirmação",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Tens certeza que as fotografias no BI foram tiradas correctamente?",
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
          'FOTOS DO B.I',
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
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            _photos.isEmpty
                ? const Center(
                    child: const Text(
                      "Sem fotos capturadas",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.black, width: 4)),
                      height: 200,
                      child: Image.file(
                        File(_photos[index].path),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: FloatingActionButton(
                child: _photos.length < 2
                    ? const Text('CAPTURAR FOTO',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))
                    : const Text('AVANÇAR',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: _photos.length < 2
                    ? _capturePhoto
                    : () async {
                        bool? result;

                        result = await showDialogConfirm();

                        if (result ?? false) {
                          print("Angola");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TelaFotoPeople(user: widget.user),
                            ),
                          );
                        } else {
                          Message.showInfo(
                              "Por favor verifica as fotos tiradas!", context);
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
