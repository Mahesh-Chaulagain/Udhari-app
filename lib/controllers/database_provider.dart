import 'package:flutter/material.dart';
import 'package:udhari/models/database_helper.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseHelper databaseHelper;
  DatabaseProvider({required this.databaseHelper});
  List<Map<String, dynamic>> _cData = [];
  List<Map<String, dynamic>> _searchResults = [];

  // add records
  void addRecord(
      String name, String location, double amount, int crate, int page) async {
    bool check = await databaseHelper.addData(
        name: name,
        location: location,
        amount: amount,
        crate: crate,
        page: page);

    if (check) {
      _cData = await databaseHelper.getAllData();
      notifyListeners();
    }
  }

  // get all records
  List<Map<String, dynamic>> getRecords() => _cData;

  void getInitialRecords() async {
    _cData = await databaseHelper.getAllData();
    notifyListeners();
  }

  List<Map<String, dynamic>> get searchResults => _searchResults;

  Future<void> searchRecords(String name, String location) async {
    // If both are provided, search by both (you may need to create a custom query for this)
    if (name.isNotEmpty && location.isNotEmpty) {
      _searchResults = await DatabaseHelper.getInstance
          .searchByNameAndLocation(name, location);
    }
    // If name is provided, search by name
    else if (name.isNotEmpty) {
      _searchResults = await DatabaseHelper.getInstance.searchByName(name);
    }
    // If location is provided, search by location
    else if (location.isNotEmpty) {
      _searchResults =
          await DatabaseHelper.getInstance.searchByLocation(location);
    }
    // If neither is provided
    else {
      _searchResults = [];
    }

    // Notify listeners after the search results are updated
    notifyListeners();
  }

  // Update Record
  void updateRecord(String name, String location, double amount, int crate,
      int page, int sno) async {
    bool check = await databaseHelper.updateData(
        name: name,
        location: location,
        amount: amount,
        crate: crate,
        page: page,
        sno: sno);

    if (check) {
      // Refresh the list of records in memory
      _cData = await databaseHelper.getAllData();

      // If you're currently performing a search, update the search results as well
      if (_searchResults.isNotEmpty) {
        _searchResults = _cData
            .where((record) =>
                (record['name'] == name || record['location'] == location))
            .toList();
      }

      // Notify listeners after updating in-memory data
      notifyListeners();
    }
  }
}
