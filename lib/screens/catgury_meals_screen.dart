import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/widgets/meal_item.dart';
import '../dummy_data.dart';
import 'package:provider/provider.dart';
class CategoryMealScreen extends StatefulWidget {
  static const routeName = 'category_meals';

//  const CategoryMealScreen({Key key}) : super(key: key);



  @override
  _CategoryMealScreenState createState() => _CategoryMealScreenState();
}

class _CategoryMealScreenState extends State<CategoryMealScreen> {
  String categoryTitle;
  List<Meal> categoryMeals;
  String categoryId;

  //زي دالة initState بتشتغل قبل بناء الودجت
  @override
  void didChangeDependencies() {
    final List<Meal> availableMeals=Provider.of<MealProvider>(context).availableMeals;
    final routArg =
    ModalRoute.of(context).settings.arguments as Map<String, String>;
    categoryId = routArg['id'];
    categoryTitle = routArg['title'];
    categoryMeals = availableMeals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  void _removeMeal(String mealId) {
    setState(() {
      categoryMeals.removeWhere((meal) => mealId==meal.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape= MediaQuery.of(context).orientation==Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var lan= Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lan.getTexts('cat-$categoryId')),
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: dw<= 400?400:500/*Width*/,
              childAspectRatio: isLandscape?dw/(dw*0.8):dw/(dw*0.75),/*لكل 1 من العرض اديني اتنين من الطول*/
              crossAxisSpacing: 2,
              mainAxisSpacing: 0,
            ),
          itemBuilder: (ctx, index) {
            return MealItem(
              categoryMeal: categoryMeals[index],
            //  removeItem: _removeMeal,
            );
          },
          itemCount: categoryMeals.length,
        ),
      ),
    );
  }
}
