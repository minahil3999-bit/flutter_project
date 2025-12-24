import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/quote_provider.dart';
import '../models/quote_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _searchQuery = '';
  String _sortType = 'Alphabetically';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteProvider>();

    List<QuoteModel> quotes = provider.quotes.where((q) => q.isFavorite).where((q) {
      return q.text.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sorting
    // Sorting
if (_sortType == 'Alphabetically') {
  quotes.sort((a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()));
} else if (_sortType == 'By Length') {
  quotes.sort((a, b) => a.text.length.compareTo(b.text.length)); // Shortest first
}

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search Favorites',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
         DropdownButton<String>(
  value: _sortType,
  items: ['Alphabetically', 'By Length'] // Latest removed
      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
      .toList(),
  onChanged: (val) {
    setState(() {
      _sortType = val!;
    });
  },
),

        ],
      ),
      body: quotes.isEmpty
          ? const Center(child: Text('No favorite quotes found'))
          : ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(quote.text),
                    subtitle: Text(quote.author),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            quote.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () => provider.toggleFavorite(quote.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: quote.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Quote copied to clipboard')),
                            );
                          },
                        ),
                        
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
