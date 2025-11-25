import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('${baseUrl}categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['categories'];
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Meal>> getMealsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('${baseUrl}filter.php?c=$category'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['meals'];
      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('${baseUrl}search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] == null) return [];

      final List list = data['meals'];
      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  static Future<MealDetail> getMealDetail(String id) async {
    final response = await http.get(Uri.parse('${baseUrl}lookup.php?i=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) throw Exception('Meal not found');
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  static Future<MealDetail> getRandomMeal() async {
    final response = await http.get(Uri.parse('${baseUrl}random.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) throw Exception('No meal found');
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}
