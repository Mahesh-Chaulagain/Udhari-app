import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/models/database_helper.dart';
import 'package:udhari/views/add_customer_page.dart';
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
                      width: 40, // specify width here
                      height: 40, // specify height (if required)
                      child: Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
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
                                      amount: results[index][DatabaseHelper
                                          .COLUMN_CUSTOMER_AMOUNT],
                                      crate: results[index][
                                          DatabaseHelper.COLUMN_CUSTOMER_CRATE],
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
                                  Icons.edit), // Your icon or button here
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateCustomerRecords(
                                      sno: results[index]
                                          [DatabaseHelper.COLUMN_CUSTOMER_SNO],
                                      previousAmount: results[index][
                                          DatabaseHelper
                                              .COLUMN_CUSTOMER_AMOUNT],
                                      previousCrate: results[index][
                                          DatabaseHelper.COLUMN_CUSTOMER_CRATE],
                                      name: results[index]
                                          [DatabaseHelper.COLUMN_CUSTOMER_NAME],
                                      location: results[index][DatabaseHelper
                                          .COLUMN_CUSTOMER_LOCATION],
                                      page: results[index]
                                          [DatabaseHelper.COLUMN_CUSTOMER_PAGE],
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  _searchRecords();
                                }
                              },
                              child: const Icon(Icons.upgrade_rounded),
                            ),
                          )
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
