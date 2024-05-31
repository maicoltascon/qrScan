import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      mini: true,
      tooltip: 'Scan QR',
      onPressed: () async {
       /*  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3D8BEF', 'Cancel', false, ScanMode.QR); */

        const barcodeScanRes = 'geo:45.521563, -122.677433';

        if (barcodeScanRes == '-1') return;

        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

        final newSacn = await scanListProvider.newScan( barcodeScanRes);

        if (newSacn == null) return;

        launchURL(context, newSacn);
        
      },
      child: const Icon(Icons.filter_center_focus, color: Colors.white),
    );
  }
}
