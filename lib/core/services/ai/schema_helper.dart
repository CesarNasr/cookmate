import 'package:google_generative_ai/google_generative_ai.dart';



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











/* JSON SAMPLE :
*
{
  "recipes": [
    {
      "title": "Quick Caprese Pasta Salad",
      "description_labels": [
        "quick",
        "vegetarian",
        "healthy"
      ],
      "level": "easy",
      "duration": "20 minutes",
      "ingredients": [
        {
          "detail": "250g dried pasta (penne or fusili)"
        },
        {
          "detail": "150g cherry tomatoes, halved"
        },
        {
          "detail": "150g fresh mozzarella balls (bocconcini), quartered"
        },
        {
          "detail": "50g fresh basil leaves, roughly chopped"
        },
        {
          "detail": "3 tbsp olive oil"
        },
        {
          "detail": "1 tbsp balsamic vinegar (optional)"
        }
      ],
      "instructions": [
        "Cook the pasta according to package directions until al dente.",
        "While pasta cooks, combine tomatoes, mozzarella, and basil in a large bowl.",
        "Drain the pasta and rinse quickly with cold water to stop cooking and cool it down.",
        "Add the cooled pasta to the bowl with the other ingredients.",
        "Drizzle with olive oil, balsamic vinegar (if using), and season with salt and pepper.",
        "Toss gently until all ingredients are well combined and serve immediately or chill."
      ]
    },
    {
      "title": "One-Pan Baked Tomato & Mozzarella",
      "description_labels": [
        "easy",
        "cheap",
        "side-dish"
      ],
      "level": "easy",
      "duration": "35 minutes",
      "ingredients": [
        {
          "detail": "500g large tomatoes, sliced"
        },
        {
          "detail": "200g sliced hard cheese (cheddar or provolone)"
        },
        {
          "detail": "150g fresh mozzarella, torn into pieces"
        },
        {
          "detail": "2 cloves garlic, minced"
        },
        {
          "detail": "Dried herbs (oregano or thyme)"
        }
      ],
      "instructions": [
        "Preheat oven to 200°C (390°F).",
        "Arrange the tomato slices in a single layer in a baking dish.",
        "Sprinkle with minced garlic and dried herbs.",
        "Layer the slices of hard cheese and torn mozzarella over the tomatoes.",
        "Bake for 20-25 minutes, or until the cheese is bubbly and lightly browned.",
        "Let cool slightly before serving as a side dish or light main."
      ]
    }
  ]
}
*
* */