import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../sessionUser/sessionUser.dart';
import '../main.dart';

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
  String? fechaAsistencia;

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
        fechaAsistencia =
            _parseFechaAsistencia(scanData.code!); // Almacenar la fecha
        _showDialog(scanData.code!, fechaAsistencia);
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

  String? _parseFechaAsistencia(String qrData) {
    List<String> keyValuePairs = qrData.split(', ');
    for (String pair in keyValuePairs) {
      List<String> keyValue = pair.split(': ');
      if (keyValue.length == 2) {
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        if (key == 'fecha') {
          return value;
        }
      }
    }
    return null;
  }

  void _showDialog(String qrData, String? fechaAsistencia) {
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
              children: [
                if (fechaAsistencia != null) Text('Fecha: $fechaAsistencia'),
                ...parsedDataWidgets,
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showConfirmationDialog(fechaAsistencia);
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarAsistencia(String? fechaAsistencia) async {
    try {
      // Verificar nuevamente antes de confirmar para evitar duplicados
      bool asistenciaRegistrada = await _verificarAsistenciaRegistrada();

      if (asistenciaRegistrada) {
        // Mostrar un cuadro de diálogo indicando que ya se registró la asistencia
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('¡Atención!'),
              content: Text('Usted ya registró su asistencia.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );

        return;
      }

      // Insertar en la tabla 'asistencia' con la fecha
      await supabaseClient.from('asistencia').upsert([
        {
          'id_estudiante': SessionUser.idEstudiante,
          'id_asignatura': idAsignatura,
          'fecha_asistencia': fechaAsistencia, // Agregar la fecha
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

  Future<bool> _verificarAsistenciaRegistrada() async {
    try {
      if (fechaAsistencia != null) {
        final response = await supabaseClient
            .from('asistencia')
            .select('id_estudiante, id_asignatura, fecha_asistencia')
            .eq('id_estudiante', SessionUser.idEstudiante)
            .eq('id_asignatura', idAsignatura)
            .eq('fecha_asistencia', fechaAsistencia!)
            .execute();

        // Si la consulta devuelve datos, significa que ya se registró la asistencia
        return response.data != null && response.data!.length > 0;
      } else {
        // Manejar el caso en que la fecha no esté disponible
        return false;
      }
    } catch (error) {
      // Manejar el error (puedes mostrar un mensaje de error, realizar un seguimiento, etc.)
      print('Error al verificar la asistencia: $error');
      return false;
    }
  }

  void _showConfirmationDialog(String? fechaAsistencia) async {
    bool asistenciaRegistrada = await _verificarAsistenciaRegistrada();

    if (asistenciaRegistrada) {
      // Mostrar un cuadro de diálogo indicando que ya se registró la asistencia
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¡Atención!'),
            content: Text('Usted ya registró su asistencia.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      // Mostrar el cuadro de diálogo de confirmación
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¿Confirmar Asistencia?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await _confirmarAsistencia(fechaAsistencia);
                  Navigator.of(context).pop();
                },
                child: Text('Confirmar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
