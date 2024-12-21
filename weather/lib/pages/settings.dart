import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/brightness.dart';
import 'package:weather/providers/home_town.dart';

List<String> supportedTowns = [
  "",
  'Nairobi',
  'Mombasa',
  'Kisumu',
  'Eldoret',
  'Nakuru',
  'Nyeri',
  'Marsabit',
  'Kakamega',
  'Lamu',
  'Garissa',
  'Lodwar',
  'Makindu',
  'Malindi',
  'Mandera',
  'Voi',
  'Moyale',
  'Wajir',
  'Kericho',
  'Narok',
  'Kitale',
  'Meru',
  'Kisii',
  'Machakos',
];

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // home town
          ListTile(
            title: const Text('Home Town'),
            trailing: DropdownButton<String>(
              value: Provider.of<HomeTownProvider>(context).homeTown,
              onChanged: (String? value) {
                Provider.of<HomeTownProvider>(context, listen: false)
                    .setHomeTown(value!);
              },
              items: supportedTowns
                  .map(
                    (town) => DropdownMenuItem(
                      value: town,
                      child: Text(town),
                    ),
                  )
                  .toList(),
            ),
          ),

          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: Provider.of<BrightnessProvider>(context).brightness ==
                  Brightness.dark,
              onChanged: (value) {
                Provider.of<BrightnessProvider>(context, listen: false)
                    .toggleBrightness();
              },
            ),
          ),
        ],
      ),
    );
  }
}
