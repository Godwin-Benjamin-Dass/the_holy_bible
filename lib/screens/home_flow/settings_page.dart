import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) => Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      BackButton(),
                      Tooltip(
                          message: theme.settingsName,
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * .6,
                            child: AutoSizeText(
                              theme.settingsName,
                              maxFontSize: 17,
                              minFontSize: 17,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                theme.fontsSize,
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
                    theme.darkTheme,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  Switch(
                      value: theme.isDarkMode,
                      onChanged: ((val) {
                        theme.toggleTheme();
                      }))
                ],
              ),
              Text(
                theme.languageSettings,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: theme.fontSize),
              ),
              ListTile(
                onTap: () {
                  theme.setFormat('tamilEnglish');
                },
                leading: Radio(
                    value: 'tamilEnglish',
                    groupValue: theme.format,
                    onChanged: (val) {
                      theme.setFormat(val!);
                    }),
                title: Text(
                  'Tamil followed by English',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  theme.setFormat('englishTamil');
                },
                leading: Radio(
                    value: 'englishTamil',
                    groupValue: theme.format,
                    onChanged: (val) {
                      theme.setFormat(val!);
                    }),
                title: Text(
                  'English followed by Tamil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  theme.setFormat('onlyTamil');
                },
                leading: Radio(
                    value: 'onlyTamil',
                    groupValue: theme.format,
                    onChanged: (val) {
                      theme.setFormat(val!);
                    }),
                title: Text(
                  'Only Tamil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  theme.setFormat('onlyEnglish');
                },
                leading: Radio(
                    value: 'onlyEnglish',
                    groupValue: theme.format,
                    onChanged: (val) {
                      theme.setFormat(val!);
                    }),
                title: Text(
                  'Only English',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
