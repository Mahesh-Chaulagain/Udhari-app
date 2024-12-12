import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/main.dart';

class AddCustomerPage extends StatelessWidget {
  int sno;
  String? name;
  String? location;
  double? amount;
  int? crate;
  int? page;

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController crateController = TextEditingController();
  TextEditingController pageController = TextEditingController();

  AddCustomerPage({
    super.key,
    this.sno = 0,
    this.name = "",
    this.location = "",
    this.amount = 0.0,
    this.crate = 0,
    this.page = -0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Record'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 21,
              ),
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
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
              TextField(
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
              const SizedBox(
                height: 20,
              ),
              TextField(
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
              const SizedBox(
                height: 20,
              ),
              TextField(
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
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        var name = nameController.text;
                        var location = locationController.text;
                        var amount =
                            double.tryParse(amountController.text) ?? .0;
                        var crate = int.tryParse(crateController.text) ?? 0;
                        var page = int.tryParse(pageController.text) ?? 0;

                        context
                            .read<DatabaseProvider>()
                            .addRecord(name, location, amount, crate, page);

                        // Clear fields after saving
                        nameController.clear();
                        locationController.clear();
                        amountController.clear();
                        crateController.clear();
                        pageController.clear();

                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
