import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/quote_model.dart';
import '../services/firebase_service.dart';
import '../services/hive_service.dart';

class QuoteProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final List<QuoteModel> _quotes = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<QuoteModel> get quotes => _quotes;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _quotes.clear();
    _quotes.addAll(HiveService.getQuotes());

    try {
      final firebaseQuotes = await _firebaseService.fetchQuotesOnce();
      for (final q in firebaseQuotes) {
        if (!_quotes.any((e) => e.id == q.id)) {
          _quotes.add(q);
          HiveService.addQuote(q);
        }
      }
    } catch (e) {
      debugPrint('Firebase fetch error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addQuote(String text, String author, String category) async {
    final quote = QuoteModel(
      id: const Uuid().v4(),
      text: text,
      author: author,
      category: category,
      isFavorite: false,
      rating: 0,
    );

    await HiveService.addQuote(quote);
    await _firebaseService.addQuote(quote);

    _quotes.add(quote);
    notifyListeners();
  }

  List<QuoteModel> getByCategory(String category) {
    return _quotes
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  

  Future<void> toggleFavorite(String id) async {
    final index = _quotes.indexWhere((q) => q.id == id);
    if (index == -1) return;

    final updated = _quotes[index].copyWith(isFavorite: !_quotes[index].isFavorite);
    _quotes[index] = updated;

    await HiveService.updateQuote(updated);
    await _firebaseService.updateFavorite(updated);

    notifyListeners();
  }

  Future<void> deleteQuote(String id) async {
    final index = _quotes.indexWhere((q) => q.id == id);
    if (index == -1) return;

    final removed = _quotes.removeAt(index);
    await HiveService.deleteQuote(removed.id);
    await _firebaseService.deleteQuote(removed.id);

    notifyListeners();
  }

  Future<void> updateRating(String id, int rating) async {
    final index = _quotes.indexWhere((q) => q.id == id);
    if (index == -1) return;

    final updated = _quotes[index].copyWith(rating: rating);
    _quotes[index] = updated;

    await HiveService.updateQuote(updated);
    await _firebaseService.updateRating(updated);

    notifyListeners();
  }
  // ✅ Add remove rating feature
  Future<void> removeRating(String id) async {
    final index = _quotes.indexWhere((q) => q.id == id);
    if (index == -1) return;

    final updated = _quotes[index].copyWith(rating: 0); // 0 = no rating
    _quotes[index] = updated;

    await HiveService.updateQuote(updated);
    await _firebaseService.updateRating(updated);

    notifyListeners();
  }
}
