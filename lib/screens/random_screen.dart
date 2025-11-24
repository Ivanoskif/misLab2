import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('Random Recipe')),
      body: FutureBuilder<Recipe>(
        future: api.fetchRandomRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No recipe found'));
          }

          final recipe = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(recipe.thumbnail),
                const SizedBox(height: 16),
                Text(recipe.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Instructions:',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                Text(recipe.instructions),
                const SizedBox(height: 16),
                Text('Ingredients:',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                ...recipe.ingredients.map((ing) => Text('• $ing')).toList(),
                const SizedBox(height: 16),
                if (recipe.youtube != null && recipe.youtube!.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      // You can use url_launcher package for opening links
                      // launchUrl(Uri.parse(recipe.youtube!));
                    },
                    child: Text('Watch on YouTube: ${recipe.youtube}'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}