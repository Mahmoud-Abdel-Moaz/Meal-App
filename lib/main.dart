import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/screens/filters_screen.dart';
import 'package:meal_app/screens/meal_detail_screen.dart';
import 'package:meal_app/screens/on_boarding_screen.dart';
import 'package:meal_app/screens/tabs_screen.dart';
import 'package:meal_app/screens/theme_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/categories_screen.dart';
import './screens/catgury_meals_screen.dart';
import 'package:provider/provider.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs=await SharedPreferences.getInstance();
   Widget homeScreen=(prefs.getBool("watched")??false)?TabsScreen():OnBoardingScreen();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MealProvider>(
          create: (BuildContext context) => MealProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (BuildContext context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (BuildContext context) => LanguageProvider(),
        )
      ],
      child: MyApp(homeScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget mainScreen;

  MyApp(this.mainScreen);
  @override
  Widget build(BuildContext context) {
    Provider.of<MealProvider>(context,listen: false).getData();
    Provider.of<ThemeProvider>(context,listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context,listen: false).getThemeColors();
    Provider.of<LanguageProvider>(context,listen: false).getLan();
    var primaryColor = Provider.of<ThemeProvider>(context).primaryColor;
    var accentColor = Provider.of<ThemeProvider>(context).accentColor;
    var tm = Provider.of<ThemeProvider>(context).tm;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: tm,
      title: 'Flutter Demo',
      darkTheme: ThemeData(
          primarySwatch: primaryColor,
          accentColor: accentColor,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Releway',
          buttonColor: Colors.black87,
          cardColor: Color.fromRGBO(255, 254, 229, 1),
          shadowColor: Colors.black54,
          unselectedWidgetColor: Colors.white70,
          textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              headline6: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontFamily: "RobotoCondensed",
                  fontWeight: FontWeight.bold))),
      theme: ThemeData(
          primarySwatch: primaryColor,
          accentColor: accentColor,
          canvasColor: Color.fromRGBO(14, 22, 33, 1),
          fontFamily: 'Releway',
          buttonColor: Colors.white,
          cardColor: Color.fromRGBO(35, 34, 39, 1),
          shadowColor: Colors.white60,
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              headline6: TextStyle(
                  color: Colors.white60,
                  fontSize: 24,
                  fontFamily: "RobotoCondensed",
                  fontWeight: FontWeight.bold))),
      // home: MyHomePage(),
      //   home: CategoriesScreen(),
      routes: {
        '/': (context) => mainScreen,
        CategoryMealScreen.routeName: (context) => CategoryMealScreen(),
        MealDetailScreen.routeName: (context) => MealDetailScreen(),
        FiltersScreen.routeName: (context) => FiltersScreen(),
        ThemeScreen.routeName: (context) => ThemeScreen(),
        TabsScreen.routeName: (context) => TabsScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal App"),
      ),
      body: null,
    );
  }
}
