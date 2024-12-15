import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final String history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show the message when history is empty or only whitespace
            if (history.trim().isEmpty)
              const Center(child: Text("No history available"))
            else
              Expanded(
                child: ListView(
                  children: history.split('\n').map((entry) {
                    // Split by line break, if that's how you want to structure history
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        entry
                            .trim(), // Ensure there is no leading/trailing space
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
