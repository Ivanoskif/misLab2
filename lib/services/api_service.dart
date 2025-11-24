import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    final data = jsonDecode(response.body);
    return (data['categories'] as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    final data = jsonDecode(response.body);
    return (data['meals'] as List)
        .map((json) => Meal.fromJson(json))
        .toList();
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    final data = jsonDecode(response.body);
    return (data['meals'] as List)
        .map((json) => Meal.fromJson(json))
        .toList();
  }

  Future<Recipe> fetchRecipe(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    final data = jsonDecode(response.body);
    return Recipe.fromJson(data['meals'][0]);
  }

  Future<Recipe> fetchRandomRecipe() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    final data = jsonDecode(response.body);
    return Recipe.fromJson(data['meals'][0]);
  }
}