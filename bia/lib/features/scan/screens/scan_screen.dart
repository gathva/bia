import 'package:bia/core/services/firestore_service.dart';
import 'package:bia/features/scan/screens/new_product_form_screen.dart';
import 'package:bia/features/scan/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isProcessing = false;

  Future<void> _processBarcode(String code) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    final product = await _firestoreService.getProductByBarcode(code);
    if (mounted) {
      if (product != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewProductFormScreen(barcode: code),
          ),
        );
      }
    }

    // Pequeño retraso para evitar múltiples detecciones o procesamientos rápidos
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  Future<void> _showManualInputDialog(BuildContext context) async {
    final barcodeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ingresar Código Manualmente'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: barcodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Código de Barras',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un código';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  _processBarcode(barcodeController.text); // Procesar el código ingresado
                }
              },
              child: const Text('Buscar'),
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
        title: const Text('Escanear Código'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: () => _showManualInputDialog(context),
            tooltip: 'Ingreso Manual',
          ),
          ValueListenableBuilder(
            valueListenable: cameraController,
            builder: (context, state, child) {
              return Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(
                      state.torchState == TorchState.on
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: state.torchState == TorchState.on
                          ? Colors.yellow
                          : Colors.grey,
                    ),
                    iconSize: 32.0,
                    onPressed: () => cameraController.toggleTorch(),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(
                     state.cameraDirection == CameraFacing.front
                          ? Icons.camera_front
                          : Icons.camera_rear,
                    ),
                    iconSize: 32.0,
                    onPressed: () => cameraController.switchCamera(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          if (capture.barcodes.isNotEmpty) {
            final String? code = capture.barcodes.first.rawValue;
            if (code != null) {
              _processBarcode(code);
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}