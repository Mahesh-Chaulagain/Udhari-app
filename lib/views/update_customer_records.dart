import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/views/add_customer_page.dart';

class UpdateCustomerRecords extends StatefulWidget {
  final int sno;
  final double previousAmount;
  final int previousCrate;
  final String? name;
  final String? location;
  final int? page;

  const UpdateCustomerRecords(
      {required this.sno,
      required this.previousAmount,
      required this.previousCrate,
      super.key,
      this.name,
      this.location,
      this.page});

  @override
  State<UpdateCustomerRecords> createState() => _UpdateCustomerRecordsState();
}

class _UpdateCustomerRecordsState extends State<UpdateCustomerRecords> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController =
        TextEditingController(text: DateTime.now().toString().split(' ')[0]);
    final TextEditingController billAmountController = TextEditingController();
    final TextEditingController billCrateController = TextEditingController();
    final TextEditingController rashidAmountController =
        TextEditingController();
    final TextEditingController rashidCrateController = TextEditingController();
    final TextEditingController newPageController =
        TextEditingController(text: widget.page?.toString() ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer Data'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 50),
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
                              dateController.text =
                                  pickedDate.toLocal().toString().split(' ')[0];
                            });
                          }
                        }),
                  ),
                  SizedBox(
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
              SizedBox(
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
                  SizedBox(
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
              SizedBox(
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
                  SizedBox(
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
                  double billAmount =
                      double.tryParse(billAmountController.text) ?? 0;
                  int billCrate = int.tryParse(billCrateController.text) ?? 0;
                  int rashidAmount =
                      int.tryParse(rashidAmountController.text) ?? 0;
                  int rashidCrate =
                      int.tryParse(rashidCrateController.text) ?? 0;
                  int newPage = int.tryParse(newPageController.text) ?? 0;

                  double updatedAmount = widget.previousAmount +
                      billAmount -
                      rashidAmount -
                      rashidCrate * 300;

                  int updatedCrate =
                      widget.previousCrate + billCrate - rashidCrate;

                  // Update database with the new values
                  context.read<DatabaseProvider>().updateRecord(
                        widget.name!,
                        widget.location!,
                        updatedAmount,
                        updatedCrate,
                        newPage,
                        widget.sno,
                      );
                  Navigator.pop(context, true);
                },
                child: Text('Update Data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}