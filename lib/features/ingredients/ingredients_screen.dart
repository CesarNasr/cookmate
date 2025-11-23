import 'package:flutter/material.dart';

class IngredientsScreen extends StatelessWidget{
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients'),
      ),
      body: Center(
        child: Text('Ingredients Screen'),
      ),
    );
  }

}