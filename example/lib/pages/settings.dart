

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
          child: Center(child: Container(height: 600,
            child: Column(children: [
              GestureDetector(key: HNElementKey('open_about_key', isIgnore: false), child: Text('open_about'), onTap: () {
                Navigator.of(context).pushNamed('/about');
              }),
              SizedBox(height: 60,),
              GestureDetector(key: HNElementKey('back_home_key', isIgnore: false), child: Text('back_home'), onTap: () {
                Navigator.of(context).pop();
              }),
              SizedBox(height: 60,),
              ListTile(key: HNElementKey('back_home_key', isIgnore: false), title: Text('back_home_listtile'), onTap: () {
                Navigator.of(context).pop();
              }),
              SizedBox(height: 60,),
              ElevatedButton(key: HNElementKey("s001", properties: {"obj": {"a":"b"}}),child: Text('back_home_ElevateButton'), onPressed: () {
                Navigator.of(context).pop();
              }),
              SizedBox(height: 60,),
              InkWell(key: HNElementKey("s001", properties: {"pro": "500"}),child: Text('back_home_InkWell'), onTap: () {
                Navigator.of(context).pop();
              },)
            ],)
          ),),
        )
    );
  }

}