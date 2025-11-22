// --- Custom Widget for Recipe Display ---
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/Recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8),

            // Details Row
            Wrap(
              // 1. Spacing provides horizontal gap between chips
              spacing: 8.0,
              // 2. runSpacing provides vertical gap between rows of chips
              runSpacing: 4.0,
              children: [
                // SizedBoxes are removed, as spacing handles the gaps
                Chip(label: Text(recipe.level), backgroundColor: Colors.amber[100]),
                Chip(label: Text(recipe.duration), backgroundColor: Colors.blue[100]),

                // Displaying labels
                ...recipe.descriptionLabels.take(2).map((label) => Chip(
                  label: Text(label),
                  backgroundColor: Colors.grey[200],
                )),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            // Displaying ingredients list
            ...recipe.ingredients.map((ing) => Text('• ${ing.detail}')).toList(),
          ],
        ),
      ),
    );
  }
}