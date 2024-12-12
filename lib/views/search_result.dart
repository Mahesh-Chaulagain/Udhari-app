import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';

class SearchResultsPage extends StatefulWidget {
  final String? name;
  final String? location;

  SearchResultsPage({this.name, this.location});

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
      appBar: AppBar(title: Text('Search Results')),
      body: results.isNotEmpty
          ? ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                var record = results[index];
                return ListTile(
                  title: Text(record['name'] ?? 'No Name'),
                  subtitle: Text(record['location'] ?? 'No Location'),
                  trailing: Text('Amount: ${record['amount'] ?? 0}'),
                );
              },
            )
          : Center(
              child: Text('No Records Found'),
            ),
    );
  }
}
