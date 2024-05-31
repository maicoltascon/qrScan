import 'package:flutter/material.dart';
import 'package:qr_reader/widgets/scan_tiles.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return const ScanTiles(type: 'geo');
  }

}