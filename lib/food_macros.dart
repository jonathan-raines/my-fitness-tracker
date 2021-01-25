class Macros {
  String productName;
  String servingSize;

  Macros({this.productName, this.servingSize});

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
        productName: json['productName'], servingSize: json['servingSize']);
  }
}
