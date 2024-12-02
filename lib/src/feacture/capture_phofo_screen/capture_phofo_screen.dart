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

  XFile? _docFront; // Foto da frente do BI
  XFile? _docBack; // Foto do verso do BI

  Future<void> _capturePhoto(String photoType) async {
    // Impede de capturar mais de duas fotos
    if ((_docFront != null && photoType == 'front') ||
        (_docBack != null && photoType == 'back')) return;

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        if (photoType == 'front') {
          _docFront = photo; // Atribui foto da frente
          widget.user.docFront = photo.path; // Atualiza no modelo
        } else if (photoType == 'back') {
          _docBack = photo; // Atribui foto do verso
          widget.user.docBack = photo.path; // Atualiza no modelo
        }
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
            setState(() {
              widget.user.docFront = ''; // Limpa a foto da frente
              widget.user.docBack = ''; // Limpa a foto do verso
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            (_docFront == null && _docBack == null)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_outlined,
                          color: Colors.black,
                          size: 50,
                        ),
                        Text(
                          "Sem fotos capturadas",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      if (_docFront != null)
                        Column(
                          children: [
                             SizedBox(height: 10),
                            Text(
                              "FRENTE",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                border:
                                    Border.all(color: Colors.black, width: 4),
                              ),
                              height: 200,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_docFront!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                   Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _docFront = null; // Remove a foto atual
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                    
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text("Foto excluída com sucesso!", style: TextStyle(color: Colors.white),),
                                    ),
                                  );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (_docBack != null)
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Offstage(
                              offstage: _docFront == null,
                              child: Divider(color: Colors.grey.shade700,height: 5 )),
                            SizedBox(height: 10),
                            Text(
                              "VERSO",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                border:
                                    Border.all(color: Colors.black, width: 4),
                              ),
                              height: 200,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_docBack!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                   Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _docBack = null; // Remove a foto atual
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                    
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text("Foto excluída com sucesso!", style: TextStyle(color: Colors.white),),
                                    ),
                                  );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: FloatingActionButton(
                child: _docFront == null || _docBack == null
                    ? const Text('CAPTURAR FOTO',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text('AVANÇAR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                onPressed: _docFront == null || _docBack == null
                    ? () async {
                        if (_docFront == null) {
                          await _capturePhoto('front');
                        } else if (_docBack == null) {
                          await _capturePhoto('back');
                        }
                      }
                    : () async {
                        bool? result = await showDialogConfirm();

                        if (result ?? false) {
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
