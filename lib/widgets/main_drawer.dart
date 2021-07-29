import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/screens/filters_screen.dart';
import 'package:meal_app/screens/tabs_screen.dart';
import 'package:meal_app/screens/theme_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  Widget buildListTile(String title,IconData icon,Function tapHandler,BuildContext ctx){
    return ListTile(
      leading: Icon(icon,size: 25,color: Theme.of(ctx).textTheme.bodyText2.color,),
      title: Text(title,style: TextStyle(
        color: Theme.of(ctx).textTheme.bodyText2.color,
        fontSize: 24,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
      ),),
      onTap: tapHandler,
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    bool isEn= Provider.of<LanguageProvider>(context,listen: false).isEn;
    var lan= Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Drawer(
        elevation: 0,
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: lan.isEn
              ?Alignment.centerLeft
              :Alignment.centerRight,
              color: Theme.of(context).accentColor,
              child: Text(lan.getTexts('drawer_name'),style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor,
              ),),
            ),
            SizedBox(height:20),
            buildListTile("drawer_item1", Icons.restaurant,(){Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);},context),
            buildListTile("drawer_item1", Icons.settings,(){Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);},context ),
            buildListTile("drawer_item3", Icons.color_lens,(){Navigator.of(context).pushReplacementNamed(ThemeScreen.routeName);},context ),
            Divider(
              height: 15,
              color: Colors.black54,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 20,right: 22),
              child: Text(
                lan.getTexts('drawer_switch_title'),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: (lan.isEn?0:20),left: (lan.isEn?0:20),bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(lan.getTexts('drawer_switch_item2'),
                  style: Theme.of(context).textTheme.headline6,),
                  Switch(
                    //title: Text(lan.getTexts('drawer_switch_title'),style: Theme.of(context).textTheme.headline6,),
                    value:
                    Provider.of<LanguageProvider>(context,listen: false).isEn,
                    //subtitle:Text(lan.getTexts('drawer_switch_subtitle')),
                    onChanged: (newValue){
                      Provider.of<LanguageProvider>(context,listen: false)
                          .changeLan(newValue);
                      Navigator.of(context).pop();
                    },
                    inactiveTrackColor:Provider.of<ThemeProvider>(context).tm==ThemeMode.light
                        ?null
                        :Colors.black,
                  ),
                  Text(lan.getTexts('drawer_switch_item1'),
                  style: Theme.of(context).textTheme.headline6,),
                ],
              ),
            ),
            Divider(
              height: 10,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }
}
