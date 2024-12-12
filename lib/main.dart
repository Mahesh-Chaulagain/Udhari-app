import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhari/controllers/database_provider.dart';
import 'package:udhari/models/database_helper.dart';
import 'package:udhari/views/homepage.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) =>
        DatabaseProvider(databaseHelper: DatabaseHelper.getInstance),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDHARI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
