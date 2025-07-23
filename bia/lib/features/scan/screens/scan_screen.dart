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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          if (_isProcessing) return;
          setState(() {
            _isProcessing = true;
          });

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              final product = await _firestoreService.getProductByBarcode(code);
              if (mounted) { // Verificar si el widget todavía está en el árbol
                if (product != null) {
                  // Producto encontrado, navegar a detalles
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                } else {
                  // Producto no encontrado, navegar a formulario
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewProductFormScreen(barcode: code),
                    ),
                  );
                }
              }
            }
          }

          // Pequeño delay para evitar múltiples escaneos y dar tiempo a la navegación
          Future.delayed(const Duration(seconds: 3), () {
            if(mounted){
              setState(() {
                _isProcessing = false;
              });
            }
          });
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
