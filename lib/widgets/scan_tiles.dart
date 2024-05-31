import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  const ScanTiles({Key? key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    // ignore: no_leading_underscores_for_local_identifiers
    Future<bool?> _showDeleteConfirmationDialog(
        BuildContext context, int scanId) async {
      return await showDialog<bool?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmación"),
            content: const Text("¿Seguro que quieres eliminar este elemento?"),
            actions: <Widget>[
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.cancel, color: Colors.red),
                label:
                    const Text("Cancelar", style: TextStyle(color: Colors.red)),
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.delete, color: Colors.red),
                label:
                    const Text("Eliminar", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: Key(scans[i].id.toString()),
        background: const _BackgroundContainer(),
        direction: DismissDirection
            .endToStart, // Dirección de deslizamiento para eliminar de derecha a izquierda
        confirmDismiss: (direction) async {
          return await _showDeleteConfirmationDialog(context, scans[i].id!);
        },
        onDismissed: (direction) {
          scanListProvider.deleteScanById(scans[i].id!);
        },
        child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.grey[
                        300]!), // Añadir un borde en la parte inferior de cada elemento
              ),
            ),
            child: lisTyle(context, scans, i, type)),
      ),
    );
  }

  ListTile lisTyle(
      BuildContext context, List<ScanModel> scans, int i, String type) {
    return ListTile(
      leading: type == 'geo'
          ? Icon(
              Icons.map,
              color: Theme.of(context).primaryColor,
            )
          : Icon(
              Icons.home_outlined,
              color: Theme.of(context).primaryColor,
            ),
      title: Text(scans[i].valor),
      trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
      onTap: () => launchURL(context, scans[i]),
    );
  }
}

class _BackgroundContainer extends StatelessWidget {
  const _BackgroundContainer();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 124, 14, 6),
            Color.fromARGB(255, 230, 88, 88)
          ],
          stops: [0.6, 1.0],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              10.0), // Ajusta el valor para cambiar la curvatura del borde superior izquierdo
          bottomLeft: Radius.circular(
              10.0), // Ajusta el valor para cambiar la curvatura del borde inferior izquierdo
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      duration: const Duration(milliseconds: 300),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
