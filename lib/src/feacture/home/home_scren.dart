import 'package:EDS/src/feacture/tela_dados/tela_dados.dart';
import 'package:EDS/src/model/user_model.dart';
import 'package:EDS/src/ui/message.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:torch_light/torch_light.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isQRViewOpen = false;

  @override
  void dispose() {
    controller.dispose();
    _turnOffTorch();  // Garante que a lanterna será desligada ao sair da tela
    super.dispose();
  }

  Future<void> _turnOnTorch() async {
    try {
      await TorchLight.enableTorch();
    } catch (e) {
      print('Erro ao ligar a lanterna: $e');
    }
  }

  Future<void> _turnOffTorch() async {
    try {
      await TorchLight.disableTorch();
    } catch (e) {
      print('Erro ao desligar a lanterna: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('LEITOR DE CÓDIGO QR DO B.I', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            if (isQRViewOpen)
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderColor: Colors.black,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            if (!isQRViewOpen)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/log/image.png', width: 200, height: 200),
                    const SizedBox(height: 20),
                    const Text(
                      "Clique no botão abaixo para escanear o QR do B.I",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            Positioned(
              top: 40,
              right: 20,
              child: Visibility(
                visible: isQRViewOpen,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isQRViewOpen = false;
                    });
                    controller.pauseCamera();
                    _turnOffTorch();
                  },
                  child: Icon(Icons.close, color: Colors.white),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Offstage(
                offstage: isQRViewOpen,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isQRViewOpen = !isQRViewOpen;
                    });
                    if (isQRViewOpen) {
                      _turnOnTorch();  // Liga a lanterna ao abrir o QR scanner
                    } else {
                      _turnOffTorch();  // Desliga a lanterna ao fechar o scanner
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code, color: Colors.white),
                      SizedBox(width: 4,),
                      Text(
                        "LER O CÓDIGO QR",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    bool isProcessing = false;

    controller.scannedDataStream.listen((scanData) {
      final data = scanData.code;
      if (data != null && !isProcessing) {
        isProcessing = true;
        try {
          print("Data :::::::::::::::::: $data");
          UserModel user = UserModel.fromQR(data);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaDados(user: user)),
          ).then((_) {
            isProcessing = false; // Reseta o flag após retorno
          });
          Message.showSucess("Código QR do BI lido com sucesso!", context);
          isProcessing = false;
        } catch (e) {
          isProcessing = false;
           Message.showErro("Erro ao processar QR: Dados inválidos!", context);
      
        }
      }
    });
  }
}
