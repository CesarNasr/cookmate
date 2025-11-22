import 'package:cookmate/core/services/ai/schema_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import '../../models/RecipeListContainer.dart';

//const geminiKey = String.fromEnvironment('gemini_key');


class GeminiService {

// ... imports for GenerativeModel and Schema ...

// Initialize your model (assuming API key is handled securely)
final model = GenerativeModel(
  model: 'gemini-2.5-flash',
  apiKey: dotenv.env['GEMINI_KEY'].toString(),
);

  Future<RecipeListContainer> generateRecipes(List<String> ingredients) async {
    final ingredientsString = ingredients.join(', ');

    final prompt = '''
    The user has the following ingredients available: $ingredientsString.
    Please generate all complete and practical recipes, using these ingredients only.
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
      print('GEMENI PRINTER ==  gemini key: ${dotenv.env['GEMINI_KEY'].toString()}');
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
