import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsName),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, theme, child) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fontsSize,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: theme.fontSize),
              ),
              SfSlider(
                  min: 10,
                  max: 30,
                  value: theme.fontSize,
                  onChanged: ((val) {
                    theme.setFontSize(val);
                  })),
              Row(
                children: [
                  Text(
                    darkTheme,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  Switch(
                      value: theme.isDarkMode,
                      onChanged: ((val) {
                        theme.toggleTheme();
                      }))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
