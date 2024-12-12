import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/views/add_customer_page.dart';
import 'package:udhari/views/search_result.dart';
import 'package:udhari/views/view_all_records.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchByLocation = TextEditingController();
    TextEditingController searchByName = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.view_carousel),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewAllRecords()));
            },
            label: const Text('View All'),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: searchByName,
              decoration: InputDecoration(
                  labelText: 'Search by Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: searchByLocation,
              decoration: InputDecoration(
                  labelText: 'Search by Location',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                String name = searchByName.text;
                String location = searchByLocation.text;
                searchByName.clear();
                searchByLocation.clear();
                // Call the search method from your provider
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchResultsPage(name: name, location: location),
                  ),
                );
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddCustomerPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}