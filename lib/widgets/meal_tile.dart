import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const MealTile({
    required this.meal,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GridTile(
        child: Image.network(meal.thumbnail, fit: BoxFit.cover),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(meal.name),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: onFavoriteToggle,
          ),
        ),
      ),
    );
  }
}