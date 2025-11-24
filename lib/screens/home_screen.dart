import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'meals_screen.dart';
import 'random_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  List<Category> categories = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    api.fetchCategories().then((data) => setState(() => categories = data));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = categories.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RandomScreen())),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search categories'),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          Expanded(
            child: ListView(
              children: filtered.map((c) => CategoryCard(
                category: c,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MealsScreen(category: c.name))),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}