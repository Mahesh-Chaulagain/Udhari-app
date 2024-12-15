// AddCustomerPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';

class AddCustomerPage extends StatefulWidget {
  bool isUpdate;
  int sno;
  String? name;
  String? location;
  int? amount;
  int? crate;
  int? page;
  String? previousHistory; // Add previousHistory field

  AddCustomerPage({
    super.key,
    this.isUpdate = false,
    this.sno = 0,
    this.name = "",
    this.location = "",
    this.amount = 0,
    this.crate = 0,
    this.page = 0,
    this.previousHistory = "", // Default to an empty string
  });

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController crateController = TextEditingController();
  TextEditingController pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      // Initialize controllers with existing data if in update mode
      nameController = TextEditingController(text: widget.name ?? '');
      locationController = TextEditingController(text: widget.location ?? '');
      amountController =
          TextEditingController(text: widget.amount?.toString() ?? '');
      crateController =
          TextEditingController(text: widget.crate?.toString() ?? '');
      pageController =
          TextEditingController(text: widget.page?.toString() ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? 'Update Record' : 'Add Record'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 21),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  label: const Text('Name'),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  label: const Text('Location'),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text('Amount'),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: crateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text('Crate'),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text('Page'),
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
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        var name = nameController.text;
                        var location = locationController.text;
                        var amount = int.tryParse(amountController.text) ?? 0;
                        var crate = int.tryParse(crateController.text) ?? 0;
                        var page = int.tryParse(pageController.text) ?? 0;
                        // var newHistory =
                        //     'Updated record on ${DateTime.now().toString()}';

                        if (name.isNotEmpty && location.isNotEmpty) {
                          if (widget.isUpdate) {
                            // Update the record, appending new history
                            String updatedHistory = '+$amount';
                            context.read<DatabaseProvider>().updateRecord(
                                name,
                                location,
                                amount,
                                crate,
                                page,
                                widget.sno,
                                updatedHistory);

                            // show snackbar on success
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Record Updated Successfully'),
                              backgroundColor: Colors.green,
                            ));
                          } else {
                            String newHistory = '+$amount';
                            context.read<DatabaseProvider>().addRecord(name,
                                location, amount, crate, page, newHistory);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Record Added Successfully'),
                              backgroundColor: Colors.green,
                            ));
                          }
                        }
                        // Clear fields after saving
                        nameController.clear();
                        locationController.clear();
                        amountController.clear();
                        crateController.clear();
                        pageController.clear();

                        Navigator.pop(context, true);
                      },
                      child: Text(widget.isUpdate ? "Update" : "Save"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
