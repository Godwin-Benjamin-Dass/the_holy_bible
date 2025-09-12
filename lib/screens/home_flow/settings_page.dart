import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:url_launcher/url_launcher.dart';

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
        appBar: AppBar(
          title: AutoSizeText(
            theme.settingsName,
            maxFontSize: 20,
            minFontSize: 18,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: const BackButton(),
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Font Size Section
            _buildSectionTitle(theme.fontsSize, theme),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Adjust Bible Font Size",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    SfSlider(
                      min: 10,
                      max: 30,
                      value: theme.fontSize,
                      interval: 5,
                      showTicks: true,
                      showLabels: true,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (val) {
                        theme.setFontSize(val);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dark Mode Section
            _buildSectionTitle(theme.darkTheme, theme),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: SwitchListTile(
                title: const Text(
                  "Enable Dark Mode",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                value: theme.isDarkMode,
                onChanged: (_) => theme.toggleTheme(),
                secondary: const Icon(Icons.dark_mode),
              ),
            ),

            const SizedBox(height: 20),

            // Language Section
            _buildSectionTitle(theme.languageSettings, theme),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildLanguageTile(
                    theme,
                    "Tamil followed by English",
                    "tamilEnglish",
                  ),
                  _buildLanguageTile(
                    theme,
                    "English followed by Tamil",
                    "englishTamil",
                  ),
                  _buildLanguageTile(
                    theme,
                    "Only Tamil",
                    "onlyTamil",
                  ),
                  _buildLanguageTile(
                    theme,
                    "Only English",
                    "onlyEnglish",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // About Section
            _buildSectionTitle("About", theme),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: const Text(
                  "Scripture Source",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  "All Bible verses are from the King James Version (KJV).",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.ads_click),
                title: const Text(
                  "Offline And Completly Ad Free",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  "Enjoy the Ad free version of Offline Bible app.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),

            // Contact Section
            _buildSectionTitle("Contact Us", theme),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text(
                  "godwinsinfotech@gmail.com",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        tooltip: "Send Email",
                        onPressed: _launchEmail,
                        icon: const Icon(Icons.send)),
                    IconButton(
                        tooltip: "Copy Email",
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(
                              text: "godwinsinfotech@gmail.com"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Copied to clipboard")),
                          );
                        },
                        icon: const Icon(Icons.copy)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: theme.fontSize,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(ThemeProvider theme, String label, String value) {
    return RadioListTile(
      value: value,
      groupValue: theme.format,
      onChanged: (val) => theme.setFormat(val!),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'godwinsinfotech@gmail.com',
      queryParameters: {
        'subject': 'From Bible App',
        'body': '',
      },
    );
    await launchUrl(emailLaunchUri);
  }
}
