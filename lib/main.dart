import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/generate_recipe/presentation/GenerateRecipeScreen.dart';



void main() async{
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope( // 👈 wraps your entire app so Riverpod works
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod MVVM Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RecipeFinderScreen(),
    );
  }
}