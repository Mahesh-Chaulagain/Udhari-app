import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';

class UpdateCustomerRecords extends StatefulWidget {
  final int sno;
  final int previousAmount;
  final int previousCrate;
  final String? name;
  final String? location;
  final int? page;
  final String? previousHistory;

  const UpdateCustomerRecords({
    required this.sno,
    required this.previousAmount,
    required this.previousCrate,
    super.key,
    this.name,
    this.location,
    this.page,
    this.previousHistory,
  });

  @override
  State<UpdateCustomerRecords> createState() => _UpdateCustomerRecordsState();
}

class _UpdateCustomerRecordsState extends State<UpdateCustomerRecords> {
  late TextEditingController dateController;
  final TextEditingController billAmountController = TextEditingController();
  final TextEditingController billCrateController = TextEditingController();
  final TextEditingController rashidAmountController = TextEditingController();
  final TextEditingController rashidCrateController = TextEditingController();
  final TextEditingController newPageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the dateController with today's date
    dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    newPageController.text = widget.page?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer Data'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onTap: () async {
                        // Date picker dialog for better date input
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            // Format the selected date in 'yyyy-MM-dd' format using the intl package
                            dateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: newPageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Page',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: billAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Bill Amount',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: rashidAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Rashid Amount',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: billCrateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Bill Crate',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: rashidCrateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Rashid Crate',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  int billAmount = int.tryParse(billAmountController.text) ?? 0;
                  int billCrate = int.tryParse(billCrateController.text) ?? 0;
                  int rashidAmount =
                      int.tryParse(rashidAmountController.text) ?? 0;
                  int rashidCrate =
                      int.tryParse(rashidCrateController.text) ?? 0;
                  int newPage = int.tryParse(newPageController.text) ?? 0;

                  int updatedAmount = widget.previousAmount +
                      billAmount -
                      rashidAmount -
                      rashidCrate * 300;

                  int updatedCrate =
                      widget.previousCrate + billCrate - rashidCrate;

                  // Use the intl package for proper date formatting
                  String currentDate =
                      DateFormat('MM-dd').format(DateTime.now());

                  // Build the history string
                  StringBuffer historyBuffer = StringBuffer();

                  // if billAmount is non-zero, add it to the history with the current date
                  if (billAmount != 0) {
                    historyBuffer.write('($currentDate) +$billAmount');
                  }

                  // if rashidAmount is non-zero, subtract it to the history with the current date
                  if (rashidAmount != 0) {
                    historyBuffer.write('($currentDate) -$rashidAmount');
                  }

                  // if rashidCrate is non-zero, subtract it to the history with the current date
                  if (rashidCrate != 0) {
                    historyBuffer.write('($currentDate) -$rashidCrate * 300');
                  }

                  // final history string
                  String updatedHistory = historyBuffer.toString().trim();

                  // Check if the updated amount results in zero
                  String finalHistory = '';
                  if (updatedHistory.isNotEmpty) {
                    finalHistory =
                        (widget.previousHistory ?? '') + ' ' + updatedHistory;
                  }

                  // Update database with the new values
                  context.read<DatabaseProvider>().updateRecord(
                      widget.name!,
                      widget.location!,
                      updatedAmount,
                      updatedCrate,
                      newPage,
                      widget.sno,
                      finalHistory);

                  Navigator.pop(context, true);
                },
                child: const Text('Update Data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
