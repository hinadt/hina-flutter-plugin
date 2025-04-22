

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hina_flutter_plugin/hina_autotrack_config.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(child: Container(height: 200,
            child: Column(children: [
              GestureDetector(key: HNElementKey('open_about_key', isIgnore: false), child: Text('open_about'), onTap: () {
                Navigator.of(context).pushNamed('/about');
              }),
              SizedBox(height: 80,),
              GestureDetector(key: HNElementKey('back_home_key', isIgnore: false), child: Text('back_home'), onTap: () {
                Navigator.of(context).pop();
              }),
            ],)
          ),),
        )
    );
  }

}