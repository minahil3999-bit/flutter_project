import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl; // Online image URL

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Online image
        Image.network(
          imageUrl,
          height: 200,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const CircularProgressIndicator(color: Colors.white);
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.white, size: 50);
          },
        ),
        const SizedBox(height: 30),
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        // Subtitle
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
