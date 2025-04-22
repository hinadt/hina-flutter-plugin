

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hina_flutter_plugin/hina_autotrack_config.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutsState();
}

class _AboutsState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(
            child: GestureDetector(
                key: HNElementKey('back_settings_key', properties: {'product_num': 100}, isIgnore: false),
                child: Text('back_settings'), onTap: () {
              Navigator.of(context).pop(false);
            }),
          ),
        )
    );
  }

}