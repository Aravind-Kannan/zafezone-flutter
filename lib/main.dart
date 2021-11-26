import 'package:flutter/material.dart';
import 'package:zafezone/pages/index.dart';
import 'package:zafezone/theme/colors.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: primary
    ),
    home: IndexPage(),
  )
);
