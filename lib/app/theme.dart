import 'package:flutter/material.dart';

final lightTheme= ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),useMaterial3: true
    
);
final darkTheme=ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6),brightness: Brightness.dark)
,
  useMaterial3: true,);
