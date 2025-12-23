import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'quotes_by_category_screen.dart';
import 'favorites_screen.dart';
import 'analytics_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'title': 'Love', 'icon': Icons.favorite, 'color': Colors.pink},
    {'title': 'Motivation', 'icon': Icons.trending_up, 'color': Colors.blue},
    {'title': 'Study', 'icon': Icons.school, 'color': Colors.green},
    {'title': 'Birthday', 'icon': Icons.cake, 'color': Colors.purple},
    {'title': 'Friendship', 'icon': Icons.people, 'color': Colors.teal},
    {'title': 'Custom', 'icon': Icons.edit, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuotesByCategoryScreen(category: cat['title']),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (cat['color'] as Color).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat['icon'] as IconData, size: 40, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      cat['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
