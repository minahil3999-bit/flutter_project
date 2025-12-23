import 'package:hive/hive.dart';
part 'quote_model.g.dart';

@HiveType(typeId: 0)
class QuoteModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final bool isFavorite;
  @HiveField(5)
  final int rating;

  QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    this.isFavorite = false,
    this.rating = 0,
  });

  QuoteModel copyWith({
    String? text,
    String? author,
    String? category,
    bool? isFavorite,
    int? rating,
  }) {
    return QuoteModel(
      id: id,
      text: text ?? this.text,
      author: author ?? this.author,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
    );
  }
}
