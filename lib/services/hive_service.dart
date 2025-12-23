import 'package:hive/hive.dart';
import '../models/quote_model.dart';

class HiveService {
  static Box<QuoteModel> get _box => Hive.box<QuoteModel>('quotesBox');

  static List<QuoteModel> getQuotes() => _box.values.toList();

  static Future<void> addQuote(QuoteModel q) async {
    await _box.put(q.id, q);
  }

  static Future<void> updateQuote(QuoteModel q) async {
    await _box.put(q.id, q);
  }

  static Future<void> deleteQuote(String id) async {
    await _box.delete(id);
  }
}
