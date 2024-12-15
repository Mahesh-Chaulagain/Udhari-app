import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/models/database_helper.dart';
import 'package:udhari/views/add_customer_page.dart';
import 'package:udhari/views/history_page.dart';
import 'package:udhari/views/update_customer_records.dart';

class UpdateButtons extends StatefulWidget {
  List<Map<String, dynamic>> allRecords;
  int index;
  UpdateButtons({required this.allRecords, required this.index, super.key});

  @override
  State<UpdateButtons> createState() => _UpdateButtonsState();
}

class _UpdateButtonsState extends State<UpdateButtons> {
  @override
  void initState() {
    super.initState();
    _getRecords();
  }

  Future<void> _getRecords() async {
    var provider = await context.read<DatabaseProvider>();
    provider.getInitialRecords();
    print("Fetching data...");
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> results = widget.allRecords;
    int index = widget.index;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Edit Button
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomerPage(
                    isUpdate: true,
                    name: results[index][DatabaseHelper.COLUMN_CUSTOMER_NAME],
                    location: results[index]
                        [DatabaseHelper.COLUMN_CUSTOMER_LOCATION],
                    amount: results[index]
                        [DatabaseHelper.COLUMN_CUSTOMER_AMOUNT],
                    crate: results[index][DatabaseHelper.COLUMN_CUSTOMER_CRATE],
                    page: results[index][DatabaseHelper.COLUMN_CUSTOMER_PAGE],
                    sno: results[index][DatabaseHelper.COLUMN_CUSTOMER_SNO],
                  ),
                ),
              );
              if (result == true) {
                _getRecords();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile Edited Successfully')));
              }
            },
            child: const Icon(
              Icons.edit,
              size: 30, // Make the icon size larger
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 30),

          // Update Button
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateCustomerRecords(
                    sno: results[index][DatabaseHelper.COLUMN_CUSTOMER_SNO],
                    previousAmount: results[index]
                        [DatabaseHelper.COLUMN_CUSTOMER_AMOUNT],
                    previousCrate: results[index]
                        [DatabaseHelper.COLUMN_CUSTOMER_CRATE],
                    name: results[index][DatabaseHelper.COLUMN_CUSTOMER_NAME],
                    location: results[index]
                        [DatabaseHelper.COLUMN_CUSTOMER_LOCATION],
                    page: results[index][DatabaseHelper.COLUMN_CUSTOMER_PAGE],
                    previousHistory: results[index]
                        [DatabaseHelper.COLUMN_CUSTOMER_HISTORY],
                  ),
                ),
              );
              if (result == true) {
                _getRecords();
                if (result == true) {
                  _getRecords();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Transaction Added Successfully')));
                }
              }
            },
            child: const Icon(
              Icons.add_to_photos,
              size: 30, // Make the icon size larger
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 30),

          // History Button
          GestureDetector(
            onTap: () {
              // Fetch the history for this customer
              var history = results[index]['history'] ??
                  ''; // Make sure history is non-null

              // Navigate to the HistoryPage with the history string
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(history: history),
                ),
              );
            },
            child: const Icon(
              Icons.history,
              size: 30, // Make the icon size larger
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
