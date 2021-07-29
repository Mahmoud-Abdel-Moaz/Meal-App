import 'package:flutter/material.dart';
import 'package:meal_app/models/category.dart';
import 'package:meal_app/models/meal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dummy_data.dart';

class MealProvider extends ChangeNotifier {
  Map<String, bool> filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<String> prefMealsId = [];
  List<Meal> availableMeals = DUMMY_MEALS;
  List<Meal> favoritesMeals = [];
  List<Category> availableCategories = [];


  void toggleFavorite(String mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final existingIndex =
        favoritesMeals.indexWhere((meal) => meal.id == mealId);

    if (existingIndex != -1) {
      favoritesMeals.removeAt(existingIndex);
      prefMealsId.remove(mealId);
    } else {
      favoritesMeals.add(DUMMY_MEALS.firstWhere((meal) => mealId == meal.id));
      prefMealsId.add(mealId);
    }
    prefs.setStringList('prefMealsId', prefMealsId);
    notifyListeners();
  }

  bool isMealFavorite(String id) {
    return favoritesMeals.any((meal) => meal.id == id);
    notifyListeners();
  }

  void setFilters() async {
    // filters = _filterDate;

    availableMeals = DUMMY_MEALS.where((meal) {
      if (filters['gluten'] && !meal.isGlutenFree) {
        return false;
      }
      if (filters['lactose'] && !meal.isLactoseFree) {
        return false;
      }
      if (filters['vegan'] && !meal.isVegan) {
        return false;
      }
      if (filters['vegetarian'] && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();
    

    
    List<Category> ac=[];
    availableMeals.forEach((meal) {
      meal.categories.forEach((catId) {
        DUMMY_CATEGORIES.forEach((cat) {
          if(cat.id==catId&&!ac.contains(cat)){
            ac.add(cat);
          }
        });
      });
    });
    availableCategories=ac;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('gluten', filters['gluten']);
    prefs.setBool('lactose', filters['lactose']);
    prefs.setBool('vegan', filters['vegan']);
    prefs.setBool('vegetarian', filters['vegetarian']);
    notifyListeners();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filters['gluten'] = prefs.getBool('gluten') ?? false;
    filters['lactose'] = prefs.getBool('lactose') ?? false;
    filters['vegan'] = prefs.getBool('vegan') ?? false;
    filters['vegetarian'] = prefs.getBool('vegetarian') ?? false;
    prefMealsId = prefs.getStringList('prefMealsId') ?? [];
    for (var mealId in prefMealsId) {
      final existingIndex =
          favoritesMeals.indexWhere((meal) => meal.id == mealId);

      if (existingIndex < 0) {
        favoritesMeals.add(DUMMY_MEALS.firstWhere((meal) => mealId == meal.id));
      }
    }
    List<Meal> fm=[];
    favoritesMeals.forEach((favMeal) {
      availableMeals.forEach((avMeal) {
        if(favMeal.id==avMeal.id&&!fm.contains(avMeal)){
          fm.add(avMeal);
        }
      });
    });
    favoritesMeals=fm;

    notifyListeners();
  }


  }
