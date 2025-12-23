import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.quotes.isEmpty
              ? const Center(child: Text('No quotes found'))
              : ListView.builder(
                  itemCount: provider.quotes.length,
                  itemBuilder: (context, index) {
                    final quote = provider.quotes[index];
                    return ListTile(
                      title: Text(quote.text),
                      subtitle: Text(quote.author),
                      trailing: IconButton(
                        icon: Icon(
                          quote.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            provider.toggleFavorite(quote.id),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddQuoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddQuoteDialog(BuildContext context) {
    final textController = TextEditingController();
    final authorController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Quote'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty &&
                  authorController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty) {
                context.read<QuoteProvider>().addQuote(
                      textController.text,
                      authorController.text,
                      categoryController.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
