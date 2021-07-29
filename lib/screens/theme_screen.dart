import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatefulWidget {
  static const routeName = '/theme';
  final bool fromOnBoarding;

  ThemeScreen({this.fromOnBoarding = false});

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  Widget buildSwitchListTile(String title, String description, bool currenValue,
      Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      value: currenValue,
      subtitle: Text(description),
      onChanged: updateValue,
      inactiveTrackColor: Colors.black,
    );
  }

  Widget buildRadioListTile(
      ThemeMode themeVal, String txt, IconData icon, BuildContext ctx) {
    return RadioListTile(
      secondary: Icon(
        icon,
        color: Theme.of(ctx).buttonColor,
      ),
      value: themeVal,
      groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
      onChanged: (newThemeVal) {
        Provider.of<ThemeProvider>(ctx, listen: false)
            .themeModeChange(newThemeVal);
      },
      title: Text(txt),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              title: widget.fromOnBoarding
                  ? null
                  : Text(lan.getTexts('theme_appBar_title')),
              backgroundColor: widget.fromOnBoarding
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
              elevation: widget.fromOnBoarding ? 0 : 5,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      lan.getTexts("theme_screen_title"),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      lan.getTexts("theme_mode_title"),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  buildRadioListTile(ThemeMode.system,
                      lan.getTexts("System_default_theme"), null, context),
                  buildRadioListTile(
                      ThemeMode.light,
                      lan.getTexts("light_theme"),
                      Icons.wb_sunny_outlined,
                      context),
                  buildRadioListTile(ThemeMode.dark, lan.getTexts("dark_theme"),
                      Icons.nights_stay_outlined, context),
                  buildListTile(context, "primary"),
                  buildListTile(context, "accent"),
                  SizedBox(
                    height: widget.fromOnBoarding ? 80 : 0,
                  )
                ],
              ),
            ),
          ],
        ),
        drawer: widget.fromOnBoarding ? null : MainDrawer(),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, txt) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    var primaryColor = Provider.of<ThemeProvider>(context).primaryColor;
    var accentColor = Provider.of<ThemeProvider>(context).accentColor;

    return ListTile(
      title: Text(
        txt == "primary" ? lan.getTexts("primary") : lan.getTexts("accent"),
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: CircleAvatar(
          backgroundColor: txt == "primary" ? primaryColor : accentColor),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              elevation: 4,
              titlePadding: const EdgeInsets.all(0.0),
              contentPadding: const EdgeInsets.all(0.0),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: txt == "primary"
                      ? Provider.of<ThemeProvider>(context).primaryColor
                      : Provider.of<ThemeProvider>(context).accentColor,
                  onColorChanged: (Color newColor) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .onChange(newColor, txt == "primary" ? 1 : 2);
                  },
                  colorPickerWidth: 300.0,
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: false,
                  displayThumbColor: true,
                  showLabel: false,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
