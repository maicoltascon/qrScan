import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/address_page.dart';
import 'package:qr_reader/pages/maps_page.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/floating_button.dart';
import 'package:qr_reader/widgets/custom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    final appBar = AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Historial',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () => _showDeleteConfirmationDialog(
              context, currentIndex, scanListProvider),
          icon: const Icon(Icons.delete, color: Colors.white),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: const _HomePageBody(),
      bottomNavigationBar: const CustomNavigatorBar(),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int currentIndex,
      ScanListProvider scanListProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
              '¿Seguro que quieres eliminar este elemento?'),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
              label:
                  const Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            TextButton.icon(
              onPressed: () {
                // Perform the deletion operation based on the current index
                if (currentIndex == 0) {
                  scanListProvider.deleteScanByType('geo');
                } else if (currentIndex == 1) {
                  scanListProvider.deleteScanByType('http');
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label:
                  const Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody();

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.loadScansByType('geo');
        return const MapsPage();
      case 1:
        scanListProvider.loadScansByType('http');
        return const AddressPage();
      default:
        scanListProvider.loadScansByType('geo');
        return const MapsPage();
    }
  }
}
