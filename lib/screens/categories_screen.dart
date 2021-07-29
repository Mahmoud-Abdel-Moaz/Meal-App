import 'package:flutter/material.dart';
import 'package:meal_app/dummy_data.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/widgets/category_item.dart';
import 'package:provider/provider.dart';
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lan= Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        //appBar: AppBar(title: Text("meal"),),
        body: GridView(
            padding: EdgeInsets.all(25),
            children: Provider.of<MealProvider>(context).availableCategories
                .map((e) =>
                CategoryItem(e.id, e.title, e.color),
                // Text(e.title,style: TextStyle(backgroundColor: e.color,color: Colors.white),)
            ).toList(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            )),
      ),
    );
  }
}
