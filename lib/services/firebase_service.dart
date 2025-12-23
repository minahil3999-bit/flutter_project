import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote_model.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance.collection('quotes');

  Future<List<QuoteModel>> fetchQuotesOnce() async {
    final snap = await _db.get();
    return snap.docs.map((d) {
      final data = d.data();
      return QuoteModel(
        id: d.id,
        text: data['text'] ?? '',
        author: data['author'] ?? '',
        category: data['category'] ?? '',
        isFavorite: data['isFavorite'] ?? false,
        rating: data['rating'] ?? 0,
      );
    }).toList();
  }

  Future<void> addQuote(QuoteModel q) async {
    await _db.doc(q.id).set({
      'text': q.text,
      'author': q.author,
      'category': q.category,
      'isFavorite': q.isFavorite,
      'rating': q.rating,
    });
  }

  Future<void> deleteQuote(String id) async {
    await _db.doc(id).delete();
  }

  Future<void> updateFavorite(QuoteModel q) async {
    await _db.doc(q.id).update({'isFavorite': q.isFavorite});
  }

  Future<void> updateRating(QuoteModel q) async {
    await _db.doc(q.id).update({'rating': q.rating});
  }
}
