import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String title, String content){
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content:Container(
    child: Row(
      children: [
        Expanded(child: Text(content))
      ],
    ),
  )));
}