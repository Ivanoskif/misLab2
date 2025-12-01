import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/favorites_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesService = FavoritesService();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites recipes")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: favoritesService.getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Empty"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final recipeId = docs[index].id;
              final name = data['name'];
              final thumbnail = data['thumbnail'];

              return ListTile(
                leading: Image.network(thumbnail, width: 50, fit: BoxFit.cover),
                title: Text(name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => favoritesService.removeFavorite(recipeId),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(mealId: recipeId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}