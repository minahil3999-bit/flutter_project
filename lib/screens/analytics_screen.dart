import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../models/quote_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteProvider>();
    final allQuotes = provider.quotes;

    Map<String, List<QuoteModel>> categoryMap = {};
    for (var q in allQuotes) {
      categoryMap.putIfAbsent(q.category, () => []).add(q);
    }

    double overallAvg = allQuotes.isEmpty
        ? 0
        : allQuotes.map((q) => q.rating).reduce((a, b) => a + b) /
            allQuotes.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: const Text('Total Quotes'),
                trailing: Text('${allQuotes.length}'),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Overall Average Rating'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < overallAvg.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Category-wise Ratings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...categoryMap.entries.map((entry) {
              final avg = entry.value.isEmpty
                  ? 0
                  : entry.value.map((q) => q.rating).reduce((a, b) => a + b) /
                      entry.value.length;
              return Card(
                child: ListTile(
                  title: Text(entry.key),
                  subtitle: Text('${entry.value.length} quotes'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < avg.round() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
