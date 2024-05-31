import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';

class MapPage extends StatelessWidget {
   
  const MapPage({super.key});

  
  
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context)?.settings.arguments as ScanModel;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('cordenadas QR: ${scan.valor}', style: const TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
         child: Text(scan.valor),
      ),
    );
  }
}