import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/screens/meal_detail_screen.dart';
import 'package:provider/provider.dart';

class MealItem extends StatelessWidget {
  final Meal categoryMeal;
  final Function removeItem;

  /*String _title;
  String _imageUrl;
  int _duration;
  Complexity _complexity;
  AbsorbPointer _absorbPointer;*/

  const MealItem({@required this.categoryMeal, @required this.removeItem});

  String get complexityText {
    switch (categoryMeal.complexity) {
      case Complexity.Simple:
        return "Simple";
        break;
      case Complexity.Challenging:
        return "Challenging";
        break;
      case Complexity.Hard:
        return "Hard";
        break;
      default:
        return "Unknown";
        break;
    }
  }

  String get affordabilityText {
    switch (categoryMeal.affordability) {
      case Affordability.Affordable:
        return "Affordable";
        break;
      case Affordability.Pricey:
        return "Pricey";
        break;
      case Affordability.Luxurious:
        return "Luxurious";
        break;
      default:
        return "Unknown";
        break;
    }
  }

  void selectMeal(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MealDetailScreen.routeName, arguments: categoryMeal.id)
        .then((result) => {
            //  if (result != null) {removeItem(result)}
            });
  }

  @override
  Widget build(BuildContext context) {
    var lan= Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: InkWell(
        onTap: () => selectMeal(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Hero(
                      tag:categoryMeal.id,
                      child:InteractiveViewer(
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/a2.png'),
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                          image: NetworkImage(categoryMeal.imageUrl,),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      width: 300,
                      color: Colors.black45,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Text(
                        lan.getTexts('meal-${categoryMeal.id}'),
                        style: TextStyle(fontSize: 25, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule,color: Theme.of(context).buttonColor,),
                        SizedBox(
                          width: 5,
                        ),
                        Text("${categoryMeal.duration} "+ lan.getTexts('min')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.work,color: Theme.of(context).buttonColor,),
                        SizedBox(
                          width: 5,
                        ),
                        Text(lan.getTexts('${categoryMeal.complexity}')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.attach_money,color: Theme.of(context).buttonColor,),
                        SizedBox(
                          width: 5,
                        ),
                        Text(lan.getTexts('${categoryMeal.affordability}')),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
