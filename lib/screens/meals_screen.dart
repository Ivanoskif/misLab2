import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/meal_tile.dart';
import 'detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  const MealsScreen({required this.category, super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ApiService api = ApiService();
  final FavoritesService favoritesService = FavoritesService();
  List<Meal> meals = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    api.fetchMealsByCategory(widget.category).then((data) {
      setState(() => meals = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = meals
        .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search meals'),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: favoritesService.getFavorites(),
              builder: (context, snapshot) {
                final favorites = snapshot.data ?? {};
                return GridView.count(
                  crossAxisCount: 2,
                  children: filtered.map((m) {
                    final isFav = favorites.containsKey(m.id);
                    return MealTile(
                      meal: m,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(mealId: m.id),
                        ),
                      ),
                      isFavorite: isFav,
                      onFavoriteToggle: () {
                        if (isFav) {
                          favoritesService.removeFavorite(m.id);
                        } else {
                          favoritesService.addFavorite(m.id, m.name, m.thumbnail);
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}