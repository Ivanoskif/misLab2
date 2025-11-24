import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealTile({required this.meal, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GridTile(
        child: Image.network(meal.thumbnail, fit: BoxFit.cover),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(meal.name),
        ),
      ),
    );
  }
}