import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io' show Platform; // For reading environment variables
import 'dart:convert';



import 'package:google_generative_ai/google_generative_ai.dart';

import '../../models/RecipeListContainer.dart';

/// Defines the structure for a single ingredient within a recipe.
final ingredientSchema = Schema(
  SchemaType.object,
  properties: {
    'detail': Schema(
      SchemaType.string,
      description: 'The ingredient, amount, and unit combined (e.g., "200g pasta (penne or fusili)", "1 can (400g) sliced tomatoes")',
    ),
  },
  requiredProperties: ['detail'],
);

/// Defines the structure for a single recipe.
final recipeSchema = Schema(
  SchemaType.object,
  properties: {
    'title': Schema(
      SchemaType.string,
      description: 'The creative title of the recipe.',
    ),
    'description_labels': Schema(
      SchemaType.array,
      description: 'A list of labels/tags for the recipe (e.g., "quick", "healthy", "cheap", "vegetarian").',
      items: Schema(SchemaType.string),
    ),
    'level': Schema(
      SchemaType.string,
      description: 'The difficulty level of the recipe prep. Must be "easy", "medium", or "hard".',
      // Using an enum is a great way to constrain text output
      enumValues: ['easy', 'medium', 'hard'],
    ),
    'duration': Schema(
       SchemaType.string,
      description: 'The total time required to prepare the meal (e.g., "30 minutes", "1.5 hours").',
    ),
    'ingredients': Schema(
      SchemaType.array,
      description: 'A list of all required ingredients, each with a detailed amount.',
      items: ingredientSchema, // Nested schema for the ingredient details
    ),
    'instructions': Schema(
       SchemaType.array,
      description: 'A step-by-step list of instructions to cook the meal.',
      items: Schema(SchemaType.string),
    ),
  },
  requiredProperties: ['title', 'description_labels', 'level', 'duration', 'ingredients', 'instructions'],
);

/// Defines the final top-level JSON structure.
final recipeListSchema = Schema(
  SchemaType.object,
  properties: {
    'recipes': Schema(
      SchemaType.array,
      description: 'A list of possible recipes based on the user-provided ingredients.',
      items: recipeSchema, // The array contains objects conforming to the recipe schema
    ),
  },
  requiredProperties: ['recipes'],
);
















class GeminiService {

// ... imports for GenerativeModel and Schema ...

// Initialize your model (assuming API key is handled securely)
final model = GenerativeModel(
  model: 'gemini-2.5-flash',
  apiKey: 'AIzaSyBEx0HHu0DRDTAfQXoZ-EO8lT8J2PnPhag',
);

/*Future<Map<String, dynamic>> generateRecipesJson(List<String> ingredients) async {
  final ingredientsString = ingredients.join(', ');

  final prompt = '''
    The user has the following ingredients in their fridge: $ingredientsString.
    Please generate all creative, complete, and practical recipes using these ingredients.
    The response must strictly adhere to the provided JSON schema.
  ''';

  // 1. Define the Generation Configuration
  final config = GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: recipeListSchema, // Use the top-level schema
  );

  try {
    // 2. Make the one-off structured call
    final response = await model.generateContent(
      [Content.text(prompt)],
      generationConfig: config,
    );

    final rawJsonString = response.text;

    // 3. Parse the guaranteed JSON string
    if (rawJsonString != null) {
      // The model returns only the JSON object, which can be directly decoded.
      return jsonDecode(rawJsonString) as Map<String, dynamic>;
    }

    throw Exception('Model returned an empty response.');
  } catch (e) {
    print('Error generating structured recipes: $e');
    // Provide a default error structure that your app can handle gracefully
    return {'recipes': []};
  }
}*/

  Future<RecipeListContainer> generateRecipes(List<String> ingredients) async {
    final ingredientsString = ingredients.join(', ');

    final prompt = '''
    The user has the following ingredients in their fridge: $ingredientsString.
    Please generate as many complete, and practical recipes as possible, using these ingredients.
    The response must strictly adhere to the provided JSON schema.
  ''';

    final config = GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: recipeListSchema,
    );

    try {
      final response = await model.generateContent(
        [Content.text(prompt)],
        generationConfig: config,
      );

      final rawJsonString = response.text;

      print("GEMENI PRINTER == \n $rawJsonString");

      if (rawJsonString != null) {
        // 1. Decode the guaranteed JSON string into a raw Dart Map
        final jsonMap = jsonDecode(rawJsonString) as Map<String, dynamic>;

        // 2. Map the JSON Map to the Dart Model object
        return RecipeListContainer.fromJson(jsonMap);
      }

      throw Exception('Model returned an empty response.');
    } catch (e) {

      print('GEMENI PRINTER == Error generating structured recipes: $e');
      // For robust error handling, return a model with an empty list
      return RecipeListContainer(recipes: []);
    }
  }

// Example usage:
/*
void fetchRecipes() async {
  final userIngredients = ['tomato', 'cheese', 'mozzarella', 'basil', 'pasta'];
  final recipeData = await generateRecipesJson(userIngredients);

  // Now, recipeData is a guaranteed Map<String, dynamic> like:
  // {
  //   "recipes": [
  //     {
  //       "title": "Quick Caprese Pasta",
  //       "description_labels": ["quick", "vegetarian"],
  //       // ... etc.
  //     }
  //   ]
  // }

  // Your Flutter app can now safely use recipeData['recipes'] as a List<dynamic>
}
*/
}





/* todo handle retry when model is overloaded
GEMENI PRINTER == Error generating structured recipes: GenerativeAIException: Server Error [503]: {
"error": {
"code": 503,
"message": "The model is overloaded. Please try again later.",
"status": "UNAVAILABLE"
}
}*/
