import 'package:flutter/foundation.dart';

class FoodProduct {
  String name;
  double calories;
  double servingSize;
  double totalFat,
      saturatedFat,
      transFat,
      polyUnsaturatedFat,
      monoUnsaturatedFat;
  double cholestrol;
  double sodium;
  double totalCarbohydrates, dietaryFiber, solubleFiber, insolubleFiber;
  double totalSugars, addedSugars;
  double protein;
  double vitaminD, iron, calcium, potassium;

  FoodProduct(
      {@required this.name,
      @required this.calories,
      this.servingSize,
      @required this.totalFat,
      this.saturatedFat,
      this.transFat,
      this.polyUnsaturatedFat,
      this.monoUnsaturatedFat,
      this.cholestrol,
      this.sodium,
      @required this.totalCarbohydrates,
      this.dietaryFiber,
      this.solubleFiber,
      this.insolubleFiber,
      this.totalSugars,
      this.addedSugars,
      @required this.protein,
      this.vitaminD,
      this.iron,
      this.calcium,
      this.potassium});

  Map<String, dynamic> toMap() => {
        'name': this.name,
        'calories': this.calories,
        'totalFat': this.totalFat,
        'saturatedFat': this.saturatedFat,
        'transFat': this.transFat,
        'polyUnsaturatedFat': this.polyUnsaturatedFat,
        'monoUnsaturatedFat': this.monoUnsaturatedFat,
        'cholestrol': this.cholestrol,
        'sodium': this.sodium,
        'totalCarbohydrates': this.totalCarbohydrates,
        'dietaryFiber': this.dietaryFiber,
        'solubleFiber': this.solubleFiber,
        'insolubleFiber': this.insolubleFiber,
        'totalSugars': this.totalSugars,
        'addedSugars': this.addedSugars,
        'protein': this.protein,
        'vitaminD': this.vitaminD,
        'iron': this.iron,
        'calcium': this.calcium,
        'potassium': this.potassium,
      };

  FoodProduct.fromMap(Map<dynamic, dynamic> map)
      : name = map['name'],
        calories = map['calories'],
        totalFat = map['totalFat'],
        saturatedFat = map['saturatedFat'],
        transFat = map['transFat'],
        polyUnsaturatedFat = map['polyUnsaturatedFat'],
        monoUnsaturatedFat = map['monoUnsaturatedFat'],
        cholestrol = map['cholestrol'],
        sodium = map['sodium'],
        totalCarbohydrates = map['totalCarbohydrates'],
        dietaryFiber = map['dietaryFiber'],
        solubleFiber = map['solubleFiber'],
        insolubleFiber = map['insolubleFiber'],
        totalSugars = map['totalSugars'],
        addedSugars = map['addedSugars'],
        protein = map['protein'],
        vitaminD = map['vitaminD'],
        iron = map['iron'],
        calcium = map['calcium'],
        potassium = map['potassium'];
}
