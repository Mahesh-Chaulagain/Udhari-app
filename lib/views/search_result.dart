import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/models/database_helper.dart';
import 'package:udhari/views/add_customer_page.dart';
import 'package:udhari/views/history_page.dart';
import 'package:udhari/views/update_customer_records.dart';

class SearchResultsPage extends StatefulWidget {
  final String? name;
  final String? location;

  const SearchResultsPage({super.key, this.name, this.location});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    _searchRecords();
  }

  Future<void> _searchRecords() async {
    await context
        .read<DatabaseProvider>()
        .searchRecords(widget.name!, widget.location!);
    setState(() {
      results = context.read<DatabaseProvider>().searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: results.isNotEmpty
          ? ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                var record = results[index];
                return ListTile(
                    title: Text(
                        "${record['name'] ?? 'No Name'} - ${record['location'] ?? 'No Location'}"),
                    subtitle: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Amount: ${record['amount'] ?? 0}'),
                          Text('Crate: ${record['crate'] ?? 0}'),
                          Text('Page: ${record['page'] ?? 0}')
                        ],
                      ),
                    ),
                    trailing: SizedBox(
                      width: 90, // Adjust width if needed
                      height: 80, // Adjust height if needed
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
                                    name: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_NAME],
                                    location: results[index][DatabaseHelper
                                        .COLUMN_CUSTOMER_LOCATION],
                                    amount: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_AMOUNT],
                                    crate: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_CRATE],
                                    page: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_PAGE],
                                    sno: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_SNO],
                                  ),
                                ),
                              );
                              if (result == true) {
                                _searchRecords();
                              }
                            },
                            child: const Icon(
                              Icons.edit,
                              size: 30, // Make the icon size larger
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Update Button
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateCustomerRecords(
                                    sno: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_SNO],
                                    previousAmount: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_AMOUNT],
                                    previousCrate: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_CRATE],
                                    name: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_NAME],
                                    location: results[index][DatabaseHelper
                                        .COLUMN_CUSTOMER_LOCATION],
                                    page: results[index]
                                        [DatabaseHelper.COLUMN_CUSTOMER_PAGE],
                                    previousHistory: results[index][
                                        DatabaseHelper.COLUMN_CUSTOMER_HISTORY],
                                  ),
                                ),
                              );
                              if (result == true) {
                                _searchRecords();
                              }
                            },
                            child: const Icon(
                              Icons.upgrade_rounded,
                              size: 30, // Make the icon size larger
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // History Button
                          GestureDetector(
                            onTap: () {
                              // Fetch the history for this customer
                              var history = record['history'] ??
                                  ''; // Make sure history is non-null

                              // Navigate to the HistoryPage with the history string
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HistoryPage(history: history),
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
                    ));
              },
            )
          : const Center(
              child: Text('No Records Found'),
            ),
    );
  }
}
