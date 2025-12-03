

class Ingredient {
  final String detail;

  Ingredient({required this.detail});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      detail: json['detail'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
    };
  }
}