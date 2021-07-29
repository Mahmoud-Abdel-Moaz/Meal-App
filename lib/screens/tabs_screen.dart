import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/screens/categories_screen.dart';
import 'package:meal_app/screens/favorites_screen.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const routeName='tab_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  List<Map<String, Object>> _pages ;


  @override
  void initState() {
    Provider.of<MealProvider>(context,listen: false).getData();
    Provider.of<ThemeProvider>(context,listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context,listen: false).getThemeColors();
    Provider.of<LanguageProvider>(context,listen: false).getLan();
    var lan= Provider.of<LanguageProvider>(context,listen: true);

    _pages = [
      {
        'page': CategoriesScreen(),
        'title': lan.getTexts('categories')
      },
      {
        'page': FavoritesScreen(),
        'title': lan.getTexts('your_favorites')
      },
    ];
    super.initState();

  }

  int _selectedPageIndex=0;
  void _selectPage(int value) {
    setState(() {
      _selectedPageIndex=value;
    });
  }
  @override
  Widget build(BuildContext context) {
    var lan= Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pages[_selectedPageIndex]['title']),
        ),
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.category),
              label: lan.getTexts('categories')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.star),
              label: lan.getTexts('your_favorites')
            ),
          ],
        ),
        drawer: MainDrawer(),
      ),
    );
  }


}
