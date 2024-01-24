import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {

  Example({super.key, required this.datas});
  Map<String, dynamic> datas;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
        color: Color(datas['color']),
        child: Text(datas['title']),

    );
  }
}
