import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:meal_app/dummy_data.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = 'meal_detail';

  Widget buildSectionTitle(String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildContainer(Widget child,BuildContext context) {
    var dw = MediaQuery.of(context).size.width;
    var dh = MediaQuery.of(context).size.height;
    bool isLandscape= MediaQuery.of(context).orientation==Orientation.landscape;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      height: isLandscape? dh*0.5:dh*0.25,
      width: isLandscape?(dw*0.5-30):dw,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan= Provider.of<LanguageProvider>(context,listen: true);
    bool isLandscape= MediaQuery.of(context).orientation==Orientation.landscape;
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final accentColor = Theme.of(context).accentColor;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    var dw = MediaQuery.of(context).size.width;
    var steps=lan.getTexts('steps-$mealId')as List<String>;

    var liSteps =ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text("# ${index + 1}"),
            ),
            title: Text(steps[index],
              style: TextStyle(color: Colors.black),),
          ),
          Divider()
        ],
      ),
      itemCount: steps.length,
    );
    var ingredients=lan.getTexts('ingredients-$mealId')as List<String>;
    var liIngredients =ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Card(
        color: accentColor,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(ingredients[index],
            style: TextStyle(color:useWhiteForeground(accentColor)?Colors.white:Colors.black),),
        ),
      ),
      itemCount: ingredients.length,
    );

    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(lan.getTexts('meal-$mealId')),
                background: Hero(
                  tag: mealId,
                  child: InteractiveViewer(
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/a2.png'),
                      fit: BoxFit.cover,
                      image: NetworkImage(selectedMeal.imageUrl,),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(delegate:SliverChildListDelegate([
              if(isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        buildSectionTitle(lan.getTexts("Ingredients"), context),
                        buildContainer(liIngredients,context),
                      ],
                    ),
                    Column(
                      children: [
                        buildSectionTitle(lan.getTexts("Steps"), context),
                        buildContainer(liSteps,context),
                      ],
                    )
                  ],
                ),
              if(!isLandscape)
                Column(
                  children: [
                    buildSectionTitle(lan.getTexts("Ingredients"), context),
                    buildContainer(liIngredients,context),
                    buildSectionTitle(lan.getTexts("Steps"), context),
                    buildContainer(liSteps,context),
                  ],
                ),
            ],),),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Provider.of<MealProvider>(context,listen: false).toggleFavorite(mealId),
          //onPressed: (){Navigator.of(context).pop(mealId);},
          child: Icon(
              Provider.of<MealProvider>(context,listen: true).isMealFavorite(mealId)?Icons.star:Icons.star_border,
          ),
        ),
        /*
        floatingActionButton: FloatingActionButton(
          onPressed: (){Navigator.of(context).pop(mealId);},
          child: Icon(Icons.delete),
        ),*/
      ),
    );
  }
}
