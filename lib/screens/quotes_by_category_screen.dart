import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/quote_provider.dart';
import '../models/quote_model.dart';

class QuotesByCategoryScreen extends StatefulWidget {
  final String category;

  const QuotesByCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuotesByCategoryScreen> createState() =>
      _QuotesByCategoryScreenState();
}

class _QuotesByCategoryScreenState
    extends State<QuotesByCategoryScreen> {
  String _searchQuery = '';
  String _sortType = 'Favorite';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteProvider>();
    List<QuoteModel> quotes =
        provider.getByCategory(widget.category);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      quotes = quotes
          .where((q) =>
              q.text
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              q.author
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sorting 
    quotes.sort((a, b) {
      switch (_sortType) {
        case 'Favorite':
          if (a.isFavorite == b.isFavorite) return 0;
          if (a.isFavorite) return -1; // favorite upar
          return 1;
        case 'Alphabetically':
          return a.author
              .toLowerCase()
              .compareTo(b.author.toLowerCase());
        default:
          return 0;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search quotes...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                  },
                ),
              ),

              // Sorting dropdown
              Padding(
                padding:
                    const EdgeInsets.only(right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Sort by:  '),
                    DropdownButton<String>(
                      value: _sortType,
                      items: const [
                        DropdownMenuItem(
                            value: 'Favorite',
                            child: Text('Favorite')),
                        DropdownMenuItem(
                            value: 'Alphabetically',
                            child: Text('Alphabetically')),
                      ],
                      onChanged: (val) {
                        setState(() => _sortType = val!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      //  Quotes list
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quotes.isEmpty
              ? const Center(child: Text('No quotes found'))
              : ListView.builder(
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    final quote = quotes[index];

                    return Dismissible(
                      key: Key(quote.id),
                      direction: widget.category == 'Custom'
                          ? DismissDirection.endToStart
                          : DismissDirection.none,

                      confirmDismiss: (_) async {
                        if (widget.category != 'Custom') {
                          return false;
                        }
                        return await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Quote'),
                            content: const Text(
                                'Are you sure you want to delete this quote?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },

                      onDismissed: (_) {
                        provider.deleteQuote(quote.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('Quote deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                provider.addQuote(
                                  quote.text,
                                  quote.author,
                                  quote.category,
                                );
                              },
                            ),
                          ),
                        );
                      },

                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20),
                        child: const Icon(Icons.delete,
                            color: Colors.white),
                      ),

                      child: _quoteTile(provider, quote),
                    );
                  },
                ),

      // Add quote (Custom only)
      floatingActionButton: widget.category == 'Custom'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () =>
                  _showAddQuoteDialog(context, provider),
            )
          : null,
    );
  }

  // ===================== QUOTE TILE =====================

  Widget _quoteTile(
      QuoteProvider provider, QuoteModel quote) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(quote.text),
        subtitle: Text('- ${quote.author}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Favorite
            IconButton(
              icon: Icon(
                quote.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () =>
                  provider.toggleFavorite(quote.id),
            ),

            // Copy
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: quote.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Quote copied to clipboard')),
                );
              },
            ),
          ],
        ),
        onTap: () =>
            _showRatingDialog(context, provider, quote),
      ),
    );
  }

  // ===================== ADD QUOTE =====================

  void _showAddQuoteDialog(
      BuildContext context, QuoteProvider provider) {
    final textCtrl = TextEditingController();
    final authorCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textCtrl,
              decoration:
                  const InputDecoration(labelText: 'Quote'),
            ),
            TextField(
              controller: authorCtrl,
              decoration:
                  const InputDecoration(labelText: 'Author'),
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
              if (textCtrl.text.isNotEmpty &&
                  authorCtrl.text.isNotEmpty) {
                provider.addQuote(
                  textCtrl.text,
                  authorCtrl.text,
                  widget.category,
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

  // ===================== RATING =====================

  void _showRatingDialog(
      BuildContext context,
      QuoteProvider provider,
      QuoteModel quote) {
    int selectedRating = quote.rating;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rate this quote'),
        content: StatefulBuilder(
          builder: (_, setState) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return IconButton(
                icon: Icon(
                  selectedRating >= i + 1
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () =>
                    setState(() => selectedRating = i + 1),
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.removeRating(quote.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Rating removed')),
              );
            },
            child: const Text('Remove'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateRating(
                  quote.id, selectedRating);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Rating saved')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
