import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/models/database_helper.dart';

class ViewAllRecords extends StatefulWidget {
  const ViewAllRecords({super.key});

  @override
  State<ViewAllRecords> createState() => _ViewAllRecordsState();
}

class _ViewAllRecordsState extends State<ViewAllRecords> {
  @override
  void initState() {
    super.initState();
    var provider = context.read<DatabaseProvider>();
    provider.getInitialRecords();
    print("Fetching data...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Records'),
      ),
      body: Consumer<DatabaseProvider>(builder: (ctx, provider, _) {
        List<Map<String, dynamic>> allRecords = provider.getRecords();

        return allRecords.isNotEmpty
            ? ListView.builder(
                itemCount: allRecords.length,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                    )),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${allRecords[index][DatabaseHelper.COLUMN_CUSTOMER_NAME]}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Location: ${allRecords[index][DatabaseHelper.COLUMN_CUSTOMER_LOCATION]}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Amount: ${allRecords[index][DatabaseHelper.COLUMN_CUSTOMER_AMOUNT].toString()}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Crate: ${allRecords[index][DatabaseHelper.COLUMN_CUSTOMER_CRATE].toString()}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Page: ${allRecords[index][DatabaseHelper.COLUMN_CUSTOMER_PAGE].toString()}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ]),
                  );
                })
            : const Center(
                child: Text('No Records Found'),
              );
      }),
    );
  }
}
