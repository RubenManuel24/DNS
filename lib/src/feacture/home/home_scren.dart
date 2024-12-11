import 'package:EDS/src/feacture/tela_dados/tela_dados.dart';
import 'package:EDS/src/model/user_model.dart';
import 'package:EDS/src/ui/loader_animation.dart';
import 'package:EDS/src/ui/message.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var ligth = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isQRViewOpen = false;
  bool isProcessing = false; // Controla o processamento

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'LEITOR DE CÓDIGO QR DO B.I',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                    Image.asset('assets/log/image.png',
                        width: 200, height: 200),
                    const SizedBox(height: 20),
                    const Text(
                      "Clique no botão abaixo para escanear o QR do B.I",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                  },
                  child: Icon(Icons.close, color: Colors.white),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Visibility(
                visible: isQRViewOpen,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (isQRViewOpen) {
                      await controller
                          .toggleFlash(); // Alterna o flash da câmera
                      bool? flashStatus = await controller
                          .getFlashStatus(); // Obtém o status atual do flash

                      setState(() {
                        ligth = flashStatus ??
                            false; // Atualiza o estado do ícone com o status real
                      });
                    }
                  },
                  child: Icon(
                    ligth
                        ? Icons.flashlight_off_outlined
                        : Icons.flashlight_on_outlined,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.black,
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
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        "LER O CÓDIGO QR",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

    controller.scannedDataStream.listen((scanData) async {
      final data = scanData.code;

      if (data != null && !isProcessing) {
        setState(() {
          isProcessing = true; // Bloqueia novos processamentos
        });

        // Exibe o Loader
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const LoaderAnimation();
          },
        );

        try {
          // Simulação de um delay para processamento (opcional)
          await Future.delayed(const Duration(seconds: 2));

          // Processa os dados do QR Code
          UserModel user = UserModel.fromQR(data);

          // Fecha o Loader antes de navegar
          if (Navigator.canPop(context)) Navigator.pop(context);

          // Navega para a tela de dados
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaDados(user: user)),
          );
        } catch (e) {
          // Fecha o Loader em caso de erro
          if (Navigator.canPop(context)) Navigator.pop(context);

          // Exibe a mensagem de erro
          Message.showErro("Erro ao processar QR: Dados inválidos!", context);
        } finally {
          // Libera para novo processamento
          setState(() {
            isProcessing = false;
          });
        }
      }
    });
  }
}
