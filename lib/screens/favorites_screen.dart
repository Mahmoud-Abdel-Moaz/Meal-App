import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/widgets/meal_item.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final List<Meal> favoritesMeals=Provider.of<MealProvider>(context,listen: true).favoritesMeals;
    bool isLandscape= MediaQuery.of(context).orientation==Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var lan= Provider.of<LanguageProvider>(context,listen: true);
    if(favoritesMeals.isEmpty){
      return Directionality(
        textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
        child: Center(
          child: Text(lan.getTexts('favorites_text')),
        ),
      );
    }else{
      return Directionality(
        textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: dw<= 400?400:500/*Width*/,
            childAspectRatio: isLandscape?dw/(dw*0.8):dw/(dw*0.75),/*لكل 1 من العرض اديني اتنين من الطول*/
            crossAxisSpacing: 2,
            mainAxisSpacing: 0,
          ),
          itemBuilder: (ctx, index) {
            return MealItem(
              categoryMeal: favoritesMeals[index],
            );
          },
          itemCount: favoritesMeals.length,
        ),
      );
    }


  }
}
