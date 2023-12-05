import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../sessionUser/sessionUser.dart';
import '../main.dart'; // Make sure Supabase is initialized here

class EscanerQr extends StatefulWidget {
  const EscanerQr({Key? key}) : super(key: key);

  @override
  _EscanerQrState createState() => _EscanerQrState();
}

class _EscanerQrState extends State<EscanerQr> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanningEnabled = true;
  int? idAsignatura;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: (controller) {
              this.controller = controller;
              _onQRViewCreated(controller);
            },
            overlay: QrScannerOverlayShape(
              borderColor: Colors.cyan,
              borderLength: 30,
              borderWidth: 3,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          _buildScanMessage(context),
        ],
      ),
    );
  }

  Widget _buildScanMessage(BuildContext context) {
    return const Positioned(
      top: 160,
      child: Text(
        'Escanea el código QR en pantalla',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      if (scanningEnabled && scanData.code != null) {
        scanningEnabled = false;
        idAsignatura = _parseIdAsignatura(scanData.code!);
        _showDialog(scanData.code!);
      }
    });
  }

  int? _parseIdAsignatura(String qrData) {
    List<String> keyValuePairs = qrData.split(', ');
    for (String pair in keyValuePairs) {
      List<String> keyValue = pair.split(': ');
      if (keyValue.length == 2) {
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        if (key == 'id_asignatura') {
          try {
            return int.parse(value);
          } catch (e) {
            print("Error parsing id_asignatura: $e");
            return null;
          }
        }
      }
    }
    return null;
  }

  void _showDialog(String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Widget> parsedDataWidgets = _parseQRData(qrData);

        return AlertDialog(
          title: Text('Datos escaneados'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: parsedDataWidgets,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showConfirmationDialog();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Confirmar Asistencia?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Aquí agregas la lógica para confirmar la asistencia e insertar en la base de datos
                await _confirmarAsistencia(); // Función para confirmar asistencia
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarAsistencia() async {
    try {
      // Insertar en la tabla 'asistencia'
      await supabaseClient.from('asistencia').upsert([
        {
          'id_estudiante': SessionUser.idEstudiante,
          'id_asignatura': idAsignatura,
        },
      ]).execute();

      // Manejar el éxito (puedes mostrar un mensaje, actualizar el estado, etc.)
      print('Asistencia confirmada con éxito');
    } catch (error) {
      // Manejar el error (puedes mostrar un mensaje de error, realizar un seguimiento, etc.)
      print('Error al confirmar la asistencia: $error');
    }
  }

  List<Widget> _parseQRData(String qrData) {
    List<String> lines = qrData.split(',');
    List<Widget> widgets = [];

    for (String line in lines) {
      widgets.add(Text(line.trim()));
    }

    return widgets;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
