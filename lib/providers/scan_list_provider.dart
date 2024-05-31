

import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {

  List<ScanModel> scans = [];
  String selectedType = 'http';

  newScan( String valor) async {
    final newScan = ScanModel(valor: valor);
    final id = await DbProvider.db.newScan(newScan);
    newScan.id = id;

    if (selectedType == newScan.tipo) {
      scans.add(newScan);
      notifyListeners();
    }
  }


  loadScans() async {
    final scans = await DbProvider.db.getScans();
    this.scans = [...scans];
    notifyListeners();
  }

  loadScansByType(String type) async {
    final scans = await DbProvider.db.getScansByType(type);
    this.scans = [...scans];
    selectedType = type;
    notifyListeners();
  }

  deleteAll() async {
    await DbProvider.db.deleteAllScan();
    scans = [];
    notifyListeners();
  }

  deleteScanById(int id) async {
    await DbProvider.db.deleteByIdScan(id);
    loadScansByType(selectedType);
  }
  deleteScanByType(String type) async {
    await DbProvider.db.deleteByTypeScan(type);
    loadScansByType(selectedType);
  }


}


